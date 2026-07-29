import 'blood_group.dart';

enum DonorAvailability { available, eligibleSoon, unavailable }

class DonationRecord {
  final String id;
  final DateTime date;
  final String location;
  final BloodGroupType bloodGroup;
  final int volumeMl;
  final String donationType; // Whole Blood, Platelets, Plasma

  DonationRecord({
    required this.id,
    required this.date,
    required this.location,
    required this.bloodGroup,
    required this.volumeMl,
    this.donationType = 'Whole Blood',
  });
}

class DonorBadge {
  final String title;
  final String description;
  final String iconName;
  final bool isUnlocked;

  DonorBadge({
    required this.title,
    required this.description,
    required this.iconName,
    required this.isUnlocked,
  });
}

class DonorProfile {
  final String id;
  final String name;
  final String email;
  final String phone;
  final BloodGroupType bloodGroup;
  final double distanceKm;
  final String city;
  final String donorPassCode;
  final DateTime? lastDonationDate;
  final int totalDonationsCount;
  final int livesSavedEstimate;
  final DonorAvailability availability;
  final List<DonationRecord> donationHistory;
  final List<DonorBadge> badges;
  final bool isVerifiedMedical;

  DonorProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.bloodGroup,
    required this.distanceKm,
    required this.city,
    required this.donorPassCode,
    this.lastDonationDate,
    this.totalDonationsCount = 0,
    this.livesSavedEstimate = 0,
    required this.availability,
    required this.donationHistory,
    required this.badges,
    this.isVerifiedMedical = true,
  });

  /// 56 days interval required between Whole Blood donations
  int get daysUntilNextEligible {
    if (lastDonationDate == null) return 0;
    final nextEligible = lastDonationDate!.add(const Duration(days: 56));
    final diff = nextEligible.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  bool get isCurrentlyEligible => daysUntilNextEligible == 0;
}
