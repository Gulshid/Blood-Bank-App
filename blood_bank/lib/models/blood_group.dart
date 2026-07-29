/// Enum representing all 8 human blood groups with helper extension methods
enum BloodGroupType {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative,
}

extension BloodGroupTypeExtension on BloodGroupType {
  String get label {
    switch (this) {
      case BloodGroupType.aPositive:
        return 'A+';
      case BloodGroupType.aNegative:
        return 'A-';
      case BloodGroupType.bPositive:
        return 'B+';
      case BloodGroupType.bNegative:
        return 'B-';
      case BloodGroupType.abPositive:
        return 'AB+';
      case BloodGroupType.abNegative:
        return 'AB-';
      case BloodGroupType.oPositive:
        return 'O+';
      case BloodGroupType.oNegative:
        return 'O-';
    }
  }

  String get fullDescription {
    switch (this) {
      case BloodGroupType.aPositive:
        return 'A Positive';
      case BloodGroupType.aNegative:
        return 'A Negative';
      case BloodGroupType.bPositive:
        return 'B Positive';
      case BloodGroupType.bNegative:
        return 'B Negative';
      case BloodGroupType.abPositive:
        return 'AB Positive (Universal Recipient)';
      case BloodGroupType.abNegative:
        return 'AB Negative';
      case BloodGroupType.oPositive:
        return 'O Positive';
      case BloodGroupType.oNegative:
        return 'O Negative (Universal Donor)';
    }
  }

  bool get isUniversalDonor => this == BloodGroupType.oNegative;
  bool get isUniversalRecipient => this == BloodGroupType.abPositive;

  static BloodGroupType fromString(String text) {
    final clean = text.trim().toUpperCase().replaceAll(' ', '');
    switch (clean) {
      case 'A+':
      case 'APOSITIVE':
        return BloodGroupType.aPositive;
      case 'A-':
      case 'ANEGATIVE':
        return BloodGroupType.aNegative;
      case 'B+':
      case 'BPOSITIVE':
        return BloodGroupType.bPositive;
      case 'B-':
      case 'BNEGATIVE':
        return BloodGroupType.bNegative;
      case 'AB+':
      case 'ABPOSITIVE':
        return BloodGroupType.abPositive;
      case 'AB-':
      case 'ABNEGATIVE':
        return BloodGroupType.abNegative;
      case 'O+':
      case 'OPOSITIVE':
        return BloodGroupType.oPositive;
      case 'O-':
      case 'ONEGATIVE':
      default:
        return BloodGroupType.oNegative;
    }
  }
}
