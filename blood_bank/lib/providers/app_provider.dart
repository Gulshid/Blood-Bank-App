import 'package:flutter/material.dart';
import '../models/blood_group.dart';
import '../models/blood_request.dart';
import '../models/donor_profile.dart';
import '../models/blood_inventory.dart';
import '../models/appointment.dart';
import '../services/blood_bank_repository.dart';

class AppProvider extends ChangeNotifier {
  final BloodBankRepository _repository = BloodBankRepository();

  // Selected filters for donor directory
  BloodGroupType? selectedFilterGroup;
  double maxDistanceFilterKm = 25.0;
  bool showOnlyAvailableDonors = true;

  // Selected tab index
  int currentTabIndex = 0;

  // Theme mode toggle
  bool isDarkMode = true;

  AppProvider() {
    _repository;
  }

  DonorProfile get currentUser => _repository.currentUserProfile;
  List<BloodRequest> get activeRequests =>
      _repository.requests.where((r) => !r.isCompleted).toList();
  List<BloodRequest> get allRequests => _repository.requests;
  List<BloodBankCenter> get bloodCenters => _repository.bloodCenters;
  List<DonationAppointment> get appointments => _repository.userAppointments;

  /// Filtered donor list based on user selections
  List<DonorProfile> get filteredDonors {
    return _repository.registeredDonors.where((donor) {
      if (selectedFilterGroup != null) {
        if (donor.bloodGroup != selectedFilterGroup) return false;
      }
      if (donor.distanceKm > maxDistanceFilterKm) return false;
      if (showOnlyAvailableDonors && donor.availability != DonorAvailability.available) {
        return false;
      }
      return true;
    }).toList();
  }

  // --- ACTIONS ---

  void setTabIndex(int index) {
    currentTabIndex = index;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

  void setFilterBloodGroup(BloodGroupType? group) {
    selectedFilterGroup = group;
    notifyListeners();
  }

  void setMaxDistanceFilter(double km) {
    maxDistanceFilterKm = km;
    notifyListeners();
  }

  void toggleAvailableOnlyFilter(bool val) {
    showOnlyAvailableDonors = val;
    notifyListeners();
  }

  void createEmergencyRequest({
    required String patientName,
    required BloodGroupType bloodGroup,
    required int unitsNeeded,
    required String hospitalName,
    required String hospitalAddress,
    required String contactPhone,
    required UrgencyLevel urgency,
    required String medicalReason,
  }) {
    final newReq = BloodRequest(
      id: 'req_${DateTime.now().millisecondsSinceEpoch}',
      patientName: patientName,
      bloodGroup: bloodGroup,
      unitsNeeded: unitsNeeded,
      unitsFulfilled: 0,
      hospitalName: hospitalName,
      hospitalAddress: hospitalAddress,
      distanceKm: 3.5, // Simulated local distance
      contactPhone: contactPhone,
      urgency: urgency,
      createdAt: DateTime.now(),
      medicalReason: medicalReason,
    );

    _repository.addRequest(newReq);
    notifyListeners();
  }

  void respondToDonation(String requestId) {
    _repository.fulfillRequestUnit(requestId);
    notifyListeners();
  }

  void bookAppointment({
    required String centerName,
    required DateTime appointmentDateTime,
    required BloodGroupType bloodGroup,
    required String donationType,
    required HealthScreeningQuiz quiz,
  }) {
    final appointment = DonationAppointment(
      id: 'app_${DateTime.now().millisecondsSinceEpoch}',
      centerName: centerName,
      appointmentDateTime: appointmentDateTime,
      bloodGroup: bloodGroup,
      donationType: donationType,
      quiz: quiz,
      bookingConfirmationCode:
          'LP-APP-${(10000 + DateTime.now().millisecond % 90000)}',
    );

    _repository.bookAppointment(appointment);
    notifyListeners();
  }

  // InheritedWidget wrapper helper for convenience
  static AppProvider of(BuildContext context) {
    return _AppProviderScope.of(context);
  }
}

/// Simple lightweight state inherited scope for Flutter without external dependency overhead
class _AppProviderScope extends InheritedWidget {
  final AppProvider provider;

  const _AppProviderScope({
    required this.provider,
    required super.child,
  });

  static AppProvider of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AppProviderScope>();
    assert(scope != null, 'No _AppProviderScope found in context');
    return scope!.provider;
  }

  @override
  bool updateShouldNotify(covariant _AppProviderScope oldWidget) => true;
}

class AppProviderWidget extends StatefulWidget {
  final Widget child;
  const AppProviderWidget({super.key, required this.child});

  @override
  State<AppProviderWidget> createState() => _AppProviderWidgetState();
}

class _AppProviderWidgetState extends State<AppProviderWidget> {
  late final AppProvider provider;

  @override
  void initState() {
    super.initState();
    provider = AppProvider();
    provider.addListener(_onStateChange);
  }

  void _onStateChange() {
    setState(() {});
  }

  @override
  void dispose() {
    provider.removeListener(_onStateChange);
    provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _AppProviderScope(
      provider: provider,
      child: widget.child,
    );
  }
}
