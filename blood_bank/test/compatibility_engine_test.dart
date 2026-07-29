import 'package:blood_bank/models/blood_group.dart';
import 'package:blood_bank/services/compatibility_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Blood Compatibility Engine Tests', () {
    test('O- is Universal Donor for all 8 blood groups', () {
      final recipientGroups = BloodGroupType.values;
      for (final recipient in recipientGroups) {
        final isCompatible = CompatibilityEngine.isCompatible(
          donor: BloodGroupType.oNegative,
          recipient: recipient,
        );
        expect(isCompatible, isTrue,
            reason: 'O- should be compatible with ${recipient.label}');
      }
    });

    test('AB+ is Universal Recipient from all 8 blood groups', () {
      final donorGroups = BloodGroupType.values;
      for (final donor in donorGroups) {
        final isCompatible = CompatibilityEngine.isCompatible(
          donor: donor,
          recipient: BloodGroupType.abPositive,
        );
        expect(isCompatible, isTrue,
            reason: '${donor.label} should be compatible with AB+');
      }
    });

    test('O- Recipient can ONLY receive from O-', () {
      final compatibleDonors =
          CompatibilityEngine.getCompatibleDonors(BloodGroupType.oNegative);
      expect(compatibleDonors, equals([BloodGroupType.oNegative]));
    });

    test('A+ Recipient can receive from A+, A-, O+, O-', () {
      final compatibleDonors =
          CompatibilityEngine.getCompatibleDonors(BloodGroupType.aPositive);
      expect(
        compatibleDonors,
        containsAll([
          BloodGroupType.aPositive,
          BloodGroupType.aNegative,
          BloodGroupType.oPositive,
          BloodGroupType.oNegative,
        ]),
      );
      expect(compatibleDonors.length, equals(4));
    });

    test('B- Donor can give to B-, B+, AB-, AB+', () {
      final canGiveTo =
          CompatibilityEngine.getCanDonateTo(BloodGroupType.bNegative);
      expect(
        canGiveTo,
        containsAll([
          BloodGroupType.bNegative,
          BloodGroupType.bPositive,
          BloodGroupType.abNegative,
          BloodGroupType.abPositive,
        ]),
      );
      expect(canGiveTo.length, equals(4));
    });

    test('BloodGroupType string parser handles various text inputs', () {
      expect(BloodGroupTypeExtension.fromString('A+'), equals(BloodGroupType.aPositive));
      expect(BloodGroupTypeExtension.fromString('O-'), equals(BloodGroupType.oNegative));
      expect(BloodGroupTypeExtension.fromString('AB+'), equals(BloodGroupType.abPositive));
      expect(BloodGroupTypeExtension.fromString('b negative'), equals(BloodGroupType.bNegative));
    });
  });
}
