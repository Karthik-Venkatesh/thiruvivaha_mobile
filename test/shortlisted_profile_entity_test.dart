import 'package:flutter_test/flutter_test.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/shortlisted_profile.dart';

void main() {
  test('ShortlistedProfile.fromMap parses profile fields', () {
    final profile = ShortlistedProfile.fromMap({
      'id': 'profile-1',
      'full_name': 'Aarav Sharma',
      'date_of_birth': '1998-04-12',
      'occupation': 'Engineering / IT',
      'city': 'Bengaluru',
      'state': 'Karnataka',
      'primary_photo': 'https://example.com/photo.jpg',
      'shortlisted_at': '2026-05-25T09:00:00.000Z',
    });

    expect(profile.profileId, 'profile-1');
    expect(profile.fullName, 'Aarav Sharma');
    expect(profile.age, 28);
    expect(profile.occupation, 'Engineering / IT');
    expect(profile.city, 'Bengaluru');
    expect(profile.state, 'Karnataka');
    expect(profile.primaryPhoto, 'https://example.com/photo.jpg');
    expect(profile.shortlistedAt, isNotNull);
  });

  test('ShortlistedProfile.displayLocation falls back to state', () {
    final profile = ShortlistedProfile.fromMap({
      'id': 'profile-2',
      'full_name': 'Nisha Rao',
      'date_of_birth': null,
      'occupation': null,
      'city': '',
      'state': 'Tamil Nadu',
    });

    expect(profile.displayLocation, 'Tamil Nadu');
  });
}
