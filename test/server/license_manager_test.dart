// Tests for LicenseManager: effective tier (license key OR account SSO premium),
// offline grace window, subscription expiry, and the Free zone limit (3).
// Ported from tune-core/src/license.rs.
//
// Run with : flutter test test/server/license_manager_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/server/license/license_manager.dart';

String _nowIso() => DateTime.now().toUtc().toIso8601String();
String _futureIso(int days) =>
    DateTime.now().toUtc().add(Duration(days: days)).toIso8601String();
String _pastIso(int days) =>
    DateTime.now().toUtc().subtract(Duration(days: days)).toIso8601String();

LicenseState _state(
  Tier tier, {
  bool accountPremium = false,
  String? accountPremiumExpires,
  String? accountPremiumChecked,
}) =>
    LicenseState(
      tier: tier,
      accountPremium: accountPremium,
      accountPremiumExpires: accountPremiumExpires,
      accountPremiumChecked: accountPremiumChecked,
    );

void main() {
  group('Tier serde', () {
    test('round-trip strings', () {
      expect(Tier.premium.asString, 'premium');
      expect(Tier.free.asString, 'free');
      expect(Tier.fromString('premium'), Tier.premium);
      expect(Tier.fromString('free'), Tier.free);
      expect(Tier.fromString(null), Tier.free);
      expect(Tier.fromString('garbage'), Tier.free);
    });
  });

  group('effectiveTier', () {
    test('free when nothing', () {
      expect(effectiveTierForTest(_state(Tier.free)), Tier.free);
    });

    test('premium via license key alone', () {
      expect(effectiveTierForTest(_state(Tier.premium)), Tier.premium);
    });

    test('premium via account, confirmed now, no expiry', () {
      expect(
        effectiveTierForTest(_state(Tier.free,
            accountPremium: true, accountPremiumChecked: _nowIso())),
        Tier.premium,
      );
    });

    test('premium via account with future subscription end', () {
      expect(
        effectiveTierForTest(_state(Tier.free,
            accountPremium: true,
            accountPremiumExpires: _futureIso(30),
            accountPremiumChecked: _nowIso())),
        Tier.premium,
      );
    });

    test('free when account subscription expired', () {
      expect(
        effectiveTierForTest(_state(Tier.free,
            accountPremium: true,
            accountPremiumExpires: _pastIso(1),
            accountPremiumChecked: _nowIso())),
        Tier.free,
      );
    });

    test('free when account grace window expired (checked 40d ago)', () {
      expect(
        effectiveTierForTest(_state(Tier.free,
            accountPremium: true, accountPremiumChecked: _pastIso(40))),
        Tier.free,
      );
    });

    test('free when account never checked', () {
      expect(
        effectiveTierForTest(
            _state(Tier.free, accountPremium: true)),
        Tier.free,
      );
    });

    test('license key survives a lapsed account premium', () {
      expect(
        effectiveTierForTest(_state(Tier.premium,
            accountPremium: true,
            accountPremiumExpires: _pastIso(1),
            accountPremiumChecked: _nowIso())),
        Tier.premium,
      );
    });
  });

  group('isExpired', () {
    test('true for old date', () {
      expect(isExpiredForTest('2020-01-01T00:00:00Z', 30), isTrue);
    });
    test('false for now', () {
      expect(isExpiredForTest(_nowIso(), 30), isFalse);
    });
    test('true for unparseable', () {
      expect(isExpiredForTest('not-a-date', 30), isTrue);
    });
  });

  group('zone limit (Free = 10)', () {
    test('constant is 10', () {
      expect(LicenseManager.freeMaxZones, 10);
      expect(LicenseManager.freeZoneLimit, 10);
    });

    test('free tier allows up to 10 zones then blocks', () {
      final free = _state(Tier.free);
      expect(checkZoneLimitForTest(free, 0), isTrue);
      expect(checkZoneLimitForTest(free, 9), isTrue);
      expect(checkZoneLimitForTest(free, 10), isFalse);
      expect(checkZoneLimitForTest(free, 11), isFalse);
    });

    test('premium is unlimited', () {
      final premium = _state(Tier.premium);
      expect(checkZoneLimitForTest(premium, 10), isTrue);
      expect(checkZoneLimitForTest(premium, 100), isTrue);
    });

    test('active account premium lifts the cap', () {
      final acct = _state(Tier.free,
          accountPremium: true, accountPremiumChecked: _nowIso());
      expect(checkZoneLimitForTest(acct, 5), isTrue);
    });
  });
}
