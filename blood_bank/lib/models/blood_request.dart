import 'blood_group.dart';

enum UrgencyLevel { critical, urgent, standard }

extension UrgencyLevelExtension on UrgencyLevel {
  String get label {
    switch (this) {
      case UrgencyLevel.critical:
        return 'CRITICAL (Immediate)';
      case UrgencyLevel.urgent:
        return 'URGENT (24 Hours)';
      case UrgencyLevel.standard:
        return 'STANDARD (Within 3 Days)';
    }
  }
}

class BloodRequest {
  final String id;
  final String patientName;
  final BloodGroupType bloodGroup;
  final int unitsNeeded;
  final int unitsFulfilled;
  final String hospitalName;
  final String hospitalAddress;
  final double distanceKm;
  final String contactPhone;
  final UrgencyLevel urgency;
  final DateTime createdAt;
  final String medicalReason;
  final bool isCompleted;

  BloodRequest({
    required this.id,
    required this.patientName,
    required this.bloodGroup,
    required this.unitsNeeded,
    this.unitsFulfilled = 0,
    required this.hospitalName,
    required this.hospitalAddress,
    required this.distanceKm,
    required this.contactPhone,
    required this.urgency,
    required this.createdAt,
    required this.medicalReason,
    this.isCompleted = false,
  });

  BloodRequest copyWith({
    String? id,
    String? patientName,
    BloodGroupType? bloodGroup,
    int? unitsNeeded,
    int? unitsFulfilled,
    String? hospitalName,
    String? hospitalAddress,
    double? distanceKm,
    String? contactPhone,
    UrgencyLevel? urgency,
    DateTime? createdAt,
    String? medicalReason,
    bool? isCompleted,
  }) {
    return BloodRequest(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      unitsNeeded: unitsNeeded ?? this.unitsNeeded,
      unitsFulfilled: unitsFulfilled ?? this.unitsFulfilled,
      hospitalName: hospitalName ?? this.hospitalName,
      hospitalAddress: hospitalAddress ?? this.hospitalAddress,
      distanceKm: distanceKm ?? this.distanceKm,
      contactPhone: contactPhone ?? this.contactPhone,
      urgency: urgency ?? this.urgency,
      createdAt: createdAt ?? this.createdAt,
      medicalReason: medicalReason ?? this.medicalReason,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
