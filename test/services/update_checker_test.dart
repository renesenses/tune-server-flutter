import 'package:flutter_test/flutter_test.dart';
import 'package:tune_server/services/update_checker.dart';

// Les six cas du passage 0.9.169 → 1.0.0-rc1 (29/09/2026).
void main() {
  group('UpdateChecker.isNewer — pré-versions', () {
    test('0.9.169 → 1.0.0-rc1 : proposée', () {
      expect(UpdateChecker.isNewer('1.0.0-rc1', '0.9.169'), isTrue);
    });
    test('1.0.0-rc1 → 1.0.0-rc2 : proposée', () {
      expect(UpdateChecker.isNewer('1.0.0-rc2', '1.0.0-rc1'), isTrue);
    });
    test('1.0.0-rc1 → 1.0.0 : la finale passe après sa pré-version', () {
      expect(UpdateChecker.isNewer('1.0.0', '1.0.0-rc1'), isTrue);
    });
    test('1.0.0 → 1.0.1 : proposée', () {
      expect(UpdateChecker.isNewer('1.0.1', '1.0.0'), isTrue);
    });
    test('égalité : rien à proposer', () {
      expect(UpdateChecker.isNewer('1.0.0-rc1', '1.0.0-rc1'), isFalse);
      expect(UpdateChecker.isNewer('v1.0.0', '1.0.0'), isFalse);
    });
    test('1.0.0-rc1 → 0.9.169 : jamais de retour en arrière', () {
      expect(UpdateChecker.isNewer('0.9.169', '1.0.0-rc1'), isFalse);
    });
    test('une version illisible ne passe jamais pour plus récente', () {
      expect(UpdateChecker.isNewer('pas-une-version', '0.9.169'), isFalse);
    });
  });
}
