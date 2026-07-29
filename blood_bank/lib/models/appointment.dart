import 'blood_group.dart';

class HealthScreeningQuiz {
  final bool weightAbove50kg;
  final bool noRecentMedication;
  final bool noTattooLast6Months;
  final bool feelsHealthyToday;

  HealthScreeningQuiz({
    required this.weightAbove50kg,
    required this.noRecentMedication,
    required this.noTattooLast6Months,
    required this.feelsHealthyToday,
  });

  bool get isEligibleToBook {
    return weightAbove50kg &&
        noRecentMedication &&
        noTattooLast6Months &&
        feelsHealthyToday;
  }
}

class DonationAppointment {
  final String id;
  final String centerName;
  final DateTime appointmentDateTime;
  final BloodGroupType bloodGroup;
  final String donationType;
  final HealthScreeningQuiz quiz;
  final String bookingConfirmationCode;
  final bool isConfirmed;

  DonationAppointment({
    required this.id,
    required this.centerName,
    required this.appointmentDateTime,
    required this.bloodGroup,
    required this.donationType,
    required this.quiz,
    required this.bookingConfirmationCode,
    this.isConfirmed = true,
  });
}
