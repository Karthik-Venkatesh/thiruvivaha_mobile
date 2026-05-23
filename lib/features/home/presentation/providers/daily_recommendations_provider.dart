import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/daily_recommendation.dart';

final dailyRecommendationsProvider = FutureProvider<List<DailyRecommendation>>((
  ref,
) async {
  AppLogger.debug('dailyRecommendations: ── fetch started ──');

  final authUserId = SupabaseConfig.auth.currentUser?.id;
  AppLogger.debug('dailyRecommendations: auth user id = $authUserId');

  if (authUserId == null) {
    AppLogger.warning('dailyRecommendations: no authenticated user — aborting');
    return [];
  }

  try {
    AppLogger.debug(
      'dailyRecommendations: calling rpc get_daily_recommendations',
    );

    final response = await SupabaseConfig.client.rpc(
      'get_daily_recommendations',
    );

    AppLogger.debug(
      'dailyRecommendations: rpc returned, type = ${response.runtimeType}',
    );
    AppLogger.debug('dailyRecommendations: raw response = $response');

    final rows = response as List<dynamic>;
    AppLogger.debug('dailyRecommendations: row count = ${rows.length}');

    if (rows.isEmpty) {
      AppLogger.warning(
        'dailyRecommendations: empty result — no profiles matched the preferences',
      );
      return [];
    }

    final results = <DailyRecommendation>[];
    for (int i = 0; i < rows.length; i++) {
      final map = rows[i] as Map<String, dynamic>;
      AppLogger.debug(
        'dailyRecommendations: [$i] id=${map['id']} '
        'name=${map['full_name']} gender=${map['gender']} '
        'city=${map['city']} occupation=${map['occupation']}',
      );
      results.add(DailyRecommendation.fromMap(map));
    }

    AppLogger.debug(
      'dailyRecommendations: ── fetch complete (${results.length} profiles) ──',
    );
    return results;
  } catch (e, st) {
    AppLogger.error('dailyRecommendations: rpc failed — $e\n$st');
    rethrow;
  }
});
