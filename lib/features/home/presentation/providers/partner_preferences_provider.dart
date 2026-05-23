import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/features/home/data/repositories/partner_preferences_repository.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/partner_preferences.dart';

final partnerPreferencesRepositoryProvider =
    Provider<PartnerPreferencesRepository>(
      (_) => PartnerPreferencesRepositoryImpl(),
    );

final partnerPreferencesProvider = FutureProvider<PartnerPreferences?>((ref) {
  return ref.watch(partnerPreferencesRepositoryProvider).fetchForCurrentUser();
});
