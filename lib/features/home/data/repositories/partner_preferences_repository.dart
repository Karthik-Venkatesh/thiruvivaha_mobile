import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/partner_preferences.dart';

abstract class PartnerPreferencesRepository {
  Future<PartnerPreferences?> fetchForCurrentUser();
}

class PartnerPreferencesRepositoryImpl implements PartnerPreferencesRepository {
  @override
  Future<PartnerPreferences?> fetchForCurrentUser() async {
    try {
      AppLogger.debug(
        'PartnerPreferencesRepository: fetchForCurrentUser started',
      );

      final authUserId = SupabaseConfig.auth.currentUser?.id;
      if (authUserId == null) {
        AppLogger.warning(
          'PartnerPreferencesRepository: no authenticated user',
        );
        return null;
      }
      AppLogger.debug(
        'PartnerPreferencesRepository: auth user id = $authUserId',
      );

      final profileRow = await SupabaseConfig.client
          .from('profiles')
          .select('id')
          .eq('auth_user_id', authUserId)
          .maybeSingle();

      if (profileRow == null) {
        AppLogger.warning(
          'PartnerPreferencesRepository: no profile found for auth user $authUserId',
        );
        return null;
      }

      final profileId = profileRow['id'] as String;
      AppLogger.debug(
        'PartnerPreferencesRepository: resolved profile id = $profileId',
      );

      final prefRow = await SupabaseConfig.client
          .from('partner_preferences')
          .select()
          .eq('profile_id', profileId)
          .maybeSingle();

      if (prefRow == null) {
        AppLogger.warning(
          'PartnerPreferencesRepository: no partner preferences found for profile $profileId',
        );
        return null;
      }

      AppLogger.debug(
        'PartnerPreferencesRepository: preferences fetched successfully',
      );
      return PartnerPreferences.fromMap(prefRow);
    } catch (e, st) {
      AppLogger.error(
        'PartnerPreferencesRepository: fetchForCurrentUser failed - $e\n$st',
      );
      rethrow;
    }
  }
}
