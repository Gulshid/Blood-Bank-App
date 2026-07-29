import '../models/blood_group.dart';

/// Scientific Blood & Platelet Compatibility Matching Engine
class CompatibilityEngine {
  /// Returns a list of compatible donor blood groups for a given recipient.
  /// E.g. Recipient A+ can receive from A+, A-, O+, O-
  static List<BloodGroupType> getCompatibleDonors(BloodGroupType recipient) {
    switch (recipient) {
      case BloodGroupType.aPositive:
        return [
          BloodGroupType.aPositive,
          BloodGroupType.aNegative,
          BloodGroupType.oPositive,
          BloodGroupType.oNegative,
        ];
      case BloodGroupType.aNegative:
        return [
          BloodGroupType.aNegative,
          BloodGroupType.oNegative,
        ];
      case BloodGroupType.bPositive:
        return [
          BloodGroupType.bPositive,
          BloodGroupType.bNegative,
          BloodGroupType.oPositive,
          BloodGroupType.oNegative,
        ];
      case BloodGroupType.bNegative:
        return [
          BloodGroupType.bNegative,
          BloodGroupType.oNegative,
        ];
      case BloodGroupType.abPositive:
        // Universal Recipient for RBCs
        return BloodGroupType.values;
      case BloodGroupType.abNegative:
        return [
          BloodGroupType.abNegative,
          BloodGroupType.aNegative,
          BloodGroupType.bNegative,
          BloodGroupType.oNegative,
        ];
      case BloodGroupType.oPositive:
        return [
          BloodGroupType.oPositive,
          BloodGroupType.oNegative,
        ];
      case BloodGroupType.oNegative:
        // O- can only receive from O-
        return [
          BloodGroupType.oNegative,
        ];
    }
  }

  /// Returns list of blood groups a donor can safely give blood to.
  /// E.g. Donor O- can give to all 8 blood groups (Universal Donor)
  static List<BloodGroupType> getCanDonateTo(BloodGroupType donor) {
    switch (donor) {
      case BloodGroupType.oNegative:
        return BloodGroupType.values;
      case BloodGroupType.oPositive:
        return [
          BloodGroupType.oPositive,
          BloodGroupType.aPositive,
          BloodGroupType.bPositive,
          BloodGroupType.abPositive,
        ];
      case BloodGroupType.aNegative:
        return [
          BloodGroupType.aNegative,
          BloodGroupType.aPositive,
          BloodGroupType.abNegative,
          BloodGroupType.abPositive,
        ];
      case BloodGroupType.aPositive:
        return [
          BloodGroupType.aPositive,
          BloodGroupType.abPositive,
        ];
      case BloodGroupType.bNegative:
        return [
          BloodGroupType.bNegative,
          BloodGroupType.bPositive,
          BloodGroupType.abNegative,
          BloodGroupType.abPositive,
        ];
      case BloodGroupType.bPositive:
        return [
          BloodGroupType.bPositive,
          BloodGroupType.abPositive,
        ];
      case BloodGroupType.abNegative:
        return [
          BloodGroupType.abNegative,
          BloodGroupType.abPositive,
        ];
      case BloodGroupType.abPositive:
        return [
          BloodGroupType.abPositive,
        ];
    }
  }

  /// Check if a specific donor group is compatible with a recipient group
  static bool isCompatible({
    required BloodGroupType donor,
    required BloodGroupType recipient,
  }) {
    return getCompatibleDonors(recipient).contains(donor);
  }

  /// Returns medical advice summary for blood compatibility
  static String getCompatibilityNote(BloodGroupType recipient) {
    if (recipient.isUniversalRecipient) {
      return 'Universal Recipient: Can receive red blood cells from any blood type.';
    } else if (recipient == BloodGroupType.oNegative) {
      return 'Restricted Recipient: Can only receive O- red blood cells, but O- is a Universal Donor.';
    } else {
      final donors = getCompatibleDonors(recipient).map((e) => e.label).join(', ');
      return 'Can receive blood from: $donors';
    }
  }
}
