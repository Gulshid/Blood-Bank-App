import '../models/blood_group.dart';
import '../models/blood_request.dart';
import '../models/donor_profile.dart';
import '../models/blood_inventory.dart';
import '../models/appointment.dart';
import 'compatibility_engine.dart';

class BloodBankRepository {
  static final BloodBankRepository _instance = BloodBankRepository._internal();
  factory BloodBankRepository() => _instance;
  BloodBankRepository._internal() {
    _initSeedData();
  }

  late DonorProfile currentUserProfile;
  final List<BloodRequest> _requests = [];
  final List<DonorProfile> _registeredDonors = [];
  final List<BloodBankCenter> _bloodCenters = [];
  final List<DonationAppointment> _userAppointments = [];

  List<BloodRequest> get requests => List.unmodifiable(_requests);
  List<DonorProfile> get registeredDonors => List.unmodifiable(_registeredDonors);
  List<BloodBankCenter> get bloodCenters => List.unmodifiable(_bloodCenters);
  List<DonationAppointment> get userAppointments => List.unmodifiable(_userAppointments);

  void _initSeedData() {
    // Current logged in user profile
    currentUserProfile = DonorProfile(
      id: 'usr_001',
      name: 'Dr. Sarah Jenkins',
      email: 'sarah.jenkins@lifepulse.org',
      phone: '+1 (555) 234-8901',
      bloodGroup: BloodGroupType.oNegative,
      distanceKm: 0.0,
      city: 'Central Medical District',
      donorPassCode: 'LP-DONOR-9082',
      lastDonationDate: DateTime.now().subtract(const Duration(days: 42)),
      totalDonationsCount: 14,
      livesSavedEstimate: 42,
      availability: DonorAvailability.available,
      donationHistory: [
        DonationRecord(
          id: 'don_101',
          date: DateTime.now().subtract(const Duration(days: 42)),
          location: 'St. Jude General Hospital',
          bloodGroup: BloodGroupType.oNegative,
          volumeMl: 450,
          donationType: 'Whole Blood',
        ),
        DonationRecord(
          id: 'don_102',
          date: DateTime.now().subtract(const Duration(days: 120)),
          location: 'Red Cross Central Clinic',
          bloodGroup: BloodGroupType.oNegative,
          volumeMl: 450,
          donationType: 'Whole Blood',
        ),
        DonationRecord(
          id: 'don_103',
          date: DateTime.now().subtract(const Duration(days: 210)),
          location: 'City Trauma Center',
          bloodGroup: BloodGroupType.oNegative,
          volumeMl: 450,
          donationType: 'Platelets',
        ),
      ],
      badges: [
        DonorBadge(
          title: 'Universal Lifesaver',
          description: 'O- Negative donor actively saving lives in emergencies',
          iconName: 'shield',
          isUnlocked: true,
        ),
        DonorBadge(
          title: 'Golden Donor',
          description: 'Completed 10+ successful blood donations',
          iconName: 'star',
          isUnlocked: true,
        ),
        DonorBadge(
          title: 'Emergency Responder',
          description: 'Responded to 3 urgent blood calls within 1 hour',
          iconName: 'bolt',
          isUnlocked: true,
        ),
        DonorBadge(
          title: 'Century Guardian',
          description: 'Save 50 lives through continuous donations',
          iconName: 'award',
          isUnlocked: false,
        ),
      ],
    );

    // Initial Emergency Requests Feed
    _requests.addAll([
      BloodRequest(
        id: 'req_001',
        patientName: 'David Miller',
        bloodGroup: BloodGroupType.oNegative,
        unitsNeeded: 3,
        unitsFulfilled: 1,
        hospitalName: 'Metropolitan General Emergency Center',
        hospitalAddress: '742 Evergreen Terrace, Sector 4',
        distanceKm: 2.4,
        contactPhone: '+1 (555) 911-3049',
        urgency: UrgencyLevel.critical,
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
        medicalReason: 'Emergency surgery following severe multi-vehicular trauma.',
      ),
      BloodRequest(
        id: 'req_002',
        patientName: 'Elena Rostova',
        bloodGroup: BloodGroupType.aPositive,
        unitsNeeded: 4,
        unitsFulfilled: 2,
        hospitalName: 'St. Vincent Children\'s Hospital',
        hospitalAddress: '120 Oxford Boulevard',
        distanceKm: 4.8,
        contactPhone: '+1 (555) 882-1029',
        urgency: UrgencyLevel.urgent,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        medicalReason: 'Platelet transfusion for pediatric oncology treatment.',
      ),
      BloodRequest(
        id: 'req_003',
        patientName: 'Marcus Vance',
        bloodGroup: BloodGroupType.bNegative,
        unitsNeeded: 2,
        unitsFulfilled: 0,
        hospitalName: 'Mercy Heart & Cardiovascular Institute',
        hospitalAddress: '500 Health Science Drive',
        distanceKm: 8.1,
        contactPhone: '+1 (555) 342-9901',
        urgency: UrgencyLevel.critical,
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
        medicalReason: 'Aortic aneurysm bypass operation scheduled.',
      ),
      BloodRequest(
        id: 'req_004',
        patientName: 'Aisha Patel',
        bloodGroup: BloodGroupType.abPositive,
        unitsNeeded: 2,
        unitsFulfilled: 1,
        hospitalName: 'City Memorial Women Hospital',
        hospitalAddress: '88 Rosewood Avenue',
        distanceKm: 12.3,
        contactPhone: '+1 (555) 441-2090',
        urgency: UrgencyLevel.standard,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        medicalReason: 'Post-partum hemorrhage transfusion protocol.',
      ),
    ]);

    // Nearby Registered Donors
    _registeredDonors.addAll([
      DonorProfile(
        id: 'dn_01',
        name: 'Alex Rivera',
        email: 'alex.r@mail.com',
        phone: '+1 (555) 123-4567',
        bloodGroup: BloodGroupType.oNegative,
        distanceKm: 1.5,
        city: 'Downtown North',
        donorPassCode: 'LP-DONOR-1001',
        availability: DonorAvailability.available,
        lastDonationDate: DateTime.now().subtract(const Duration(days: 90)),
        totalDonationsCount: 8,
        livesSavedEstimate: 24,
        donationHistory: [],
        badges: [],
      ),
      DonorProfile(
        id: 'dn_02',
        name: 'Maria Santos',
        email: 'maria.s@mail.com',
        phone: '+1 (555) 987-6543',
        bloodGroup: BloodGroupType.aPositive,
        distanceKm: 3.1,
        city: 'East Side',
        donorPassCode: 'LP-DONOR-1002',
        availability: DonorAvailability.available,
        lastDonationDate: DateTime.now().subtract(const Duration(days: 70)),
        totalDonationsCount: 12,
        livesSavedEstimate: 36,
        donationHistory: [],
        badges: [],
      ),
      DonorProfile(
        id: 'dn_03',
        name: 'James Wilson',
        email: 'james.w@mail.com',
        phone: '+1 (555) 334-5566',
        bloodGroup: BloodGroupType.bPositive,
        distanceKm: 4.5,
        city: 'West Suburbs',
        donorPassCode: 'LP-DONOR-1003',
        availability: DonorAvailability.eligibleSoon,
        lastDonationDate: DateTime.now().subtract(const Duration(days: 45)),
        totalDonationsCount: 5,
        livesSavedEstimate: 15,
        donationHistory: [],
        badges: [],
      ),
      DonorProfile(
        id: 'dn_04',
        name: 'Dr. Robert Chang',
        email: 'rchang@hospital.org',
        phone: '+1 (555) 778-9900',
        bloodGroup: BloodGroupType.abNegative,
        distanceKm: 6.2,
        city: 'Medical Hub',
        donorPassCode: 'LP-DONOR-1004',
        availability: DonorAvailability.available,
        lastDonationDate: DateTime.now().subtract(const Duration(days: 100)),
        totalDonationsCount: 20,
        livesSavedEstimate: 60,
        donationHistory: [],
        badges: [],
      ),
      DonorProfile(
        id: 'dn_05',
        name: 'Sophia Chen',
        email: 'sophia.c@mail.com',
        phone: '+1 (555) 223-1144',
        bloodGroup: BloodGroupType.oPositive,
        distanceKm: 7.0,
        city: 'South Bay',
        donorPassCode: 'LP-DONOR-1005',
        availability: DonorAvailability.available,
        lastDonationDate: DateTime.now().subtract(const Duration(days: 65)),
        totalDonationsCount: 6,
        livesSavedEstimate: 18,
        donationHistory: [],
        badges: [],
      ),
    ]);

    // Blood Banks & Hospital Inventory Stock
    _bloodCenters.addAll([
      BloodBankCenter(
        id: 'bb_01',
        name: 'Central Red Cross Blood Bank & Lab',
        address: '100 Medical Center Parkway, Suite 100',
        contactPhone: '+1 (555) 400-9000',
        distanceKm: 1.8,
        operatingHours: '24/7 Emergency Blood Bank',
        stocks: [
          GroupStock(bloodGroup: BloodGroupType.oNegative, unitsAvailable: 2, unitsReserved: 1), // Critical
          GroupStock(bloodGroup: BloodGroupType.oPositive, unitsAvailable: 15, unitsReserved: 3),
          GroupStock(bloodGroup: BloodGroupType.aPositive, unitsAvailable: 22, unitsReserved: 4),
          GroupStock(bloodGroup: BloodGroupType.aNegative, unitsAvailable: 4, unitsReserved: 1), // Low
          GroupStock(bloodGroup: BloodGroupType.bPositive, unitsAvailable: 12, unitsReserved: 2),
          GroupStock(bloodGroup: BloodGroupType.bNegative, unitsAvailable: 3, unitsReserved: 0), // Low
          GroupStock(bloodGroup: BloodGroupType.abPositive, unitsAvailable: 8, unitsReserved: 1),
          GroupStock(bloodGroup: BloodGroupType.abNegative, unitsAvailable: 1, unitsReserved: 0), // Critical
        ],
      ),
      BloodBankCenter(
        id: 'bb_02',
        name: 'St. Jude Regional Blood Transfusion Center',
        address: '450 University Health Avenue',
        contactPhone: '+1 (555) 400-9111',
        distanceKm: 4.2,
        operatingHours: 'Mon - Sun: 07:00 AM - 10:00 PM',
        stocks: [
          GroupStock(bloodGroup: BloodGroupType.oNegative, unitsAvailable: 5, unitsReserved: 2),
          GroupStock(bloodGroup: BloodGroupType.oPositive, unitsAvailable: 18, unitsReserved: 5),
          GroupStock(bloodGroup: BloodGroupType.aPositive, unitsAvailable: 14, unitsReserved: 2),
          GroupStock(bloodGroup: BloodGroupType.aNegative, unitsAvailable: 6, unitsReserved: 1),
          GroupStock(bloodGroup: BloodGroupType.bPositive, unitsAvailable: 9, unitsReserved: 2),
          GroupStock(bloodGroup: BloodGroupType.bNegative, unitsAvailable: 4, unitsReserved: 1),
          GroupStock(bloodGroup: BloodGroupType.abPositive, unitsAvailable: 10, unitsReserved: 0),
          GroupStock(bloodGroup: BloodGroupType.abNegative, unitsAvailable: 3, unitsReserved: 1),
        ],
      ),
      BloodBankCenter(
        id: 'bb_03',
        name: 'Metropolitan Trauma Hospital Blood Reserve',
        address: '742 Evergreen Terrace, Trauma Wing',
        contactPhone: '+1 (555) 911-3000',
        distanceKm: 2.4,
        operatingHours: '24/7 Trauma Unit',
        stocks: [
          GroupStock(bloodGroup: BloodGroupType.oNegative, unitsAvailable: 1, unitsReserved: 1), // Critical
          GroupStock(bloodGroup: BloodGroupType.oPositive, unitsAvailable: 8, unitsReserved: 2),
          GroupStock(bloodGroup: BloodGroupType.aPositive, unitsAvailable: 11, unitsReserved: 3),
          GroupStock(bloodGroup: BloodGroupType.aNegative, unitsAvailable: 2, unitsReserved: 0),
          GroupStock(bloodGroup: BloodGroupType.bPositive, unitsAvailable: 5, unitsReserved: 1),
          GroupStock(bloodGroup: BloodGroupType.bNegative, unitsAvailable: 1, unitsReserved: 0),
          GroupStock(bloodGroup: BloodGroupType.abPositive, unitsAvailable: 6, unitsReserved: 1),
          GroupStock(bloodGroup: BloodGroupType.abNegative, unitsAvailable: 2, unitsReserved: 0),
        ],
      ),
    ]);

    // Initial confirmed appointments
    _userAppointments.add(
      DonationAppointment(
        id: 'app_01',
        centerName: 'Central Red Cross Blood Bank & Lab',
        appointmentDateTime: DateTime.now().add(const Duration(days: 3, hours: 2)),
        bloodGroup: BloodGroupType.oNegative,
        donationType: 'Whole Blood',
        bookingConfirmationCode: 'LP-APP-88421',
        quiz: HealthScreeningQuiz(
          weightAbove50kg: true,
          noRecentMedication: true,
          noTattooLast6Months: true,
          feelsHealthyToday: true,
        ),
      ),
    );
  }

  // --- ACTIONS ---

  void addRequest(BloodRequest request) {
    _requests.insert(0, request);
  }

  void fulfillRequestUnit(String requestId) {
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      final old = _requests[index];
      final newFulfilled = old.unitsFulfilled + 1;
      final isDone = newFulfilled >= old.unitsNeeded;
      _requests[index] = old.copyWith(
        unitsFulfilled: newFulfilled,
        isCompleted: isDone,
      );
    }
  }

  List<DonorProfile> findMatchingDonorsForGroup({
    required BloodGroupType neededGroup,
    double maxDistanceKm = 50.0,
  }) {
    return _registeredDonors.where((donor) {
      final isComp = CompatibilityEngine.isCompatible(
        donor: donor.bloodGroup,
        recipient: neededGroup,
      );
      final isWithinDist = donor.distanceKm <= maxDistanceKm;
      return isComp && isWithinDist;
    }).toList();
  }

  void bookAppointment(DonationAppointment appointment) {
    _userAppointments.insert(0, appointment);
  }
}
