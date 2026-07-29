import 'blood_group.dart';

enum StockStatus { optimal, moderate, low, critical }

class GroupStock {
  final BloodGroupType bloodGroup;
  final int unitsAvailable;
  final int unitsReserved;

  GroupStock({
    required this.bloodGroup,
    required this.unitsAvailable,
    this.unitsReserved = 0,
  });

  StockStatus get status {
    if (unitsAvailable <= 2) return StockStatus.critical;
    if (unitsAvailable <= 5) return StockStatus.low;
    if (unitsAvailable <= 10) return StockStatus.moderate;
    return StockStatus.optimal;
  }
}

class BloodBankCenter {
  final String id;
  final String name;
  final String address;
  final String contactPhone;
  final double distanceKm;
  final String operatingHours;
  final List<GroupStock> stocks;

  BloodBankCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.contactPhone,
    required this.distanceKm,
    required this.operatingHours,
    required this.stocks,
  });

  int get totalUnitsAvailable {
    return stocks.fold(0, (sum, item) => sum + item.unitsAvailable);
  }

  bool get hasCriticalShortage {
    return stocks.any((element) => element.status == StockStatus.critical);
  }
}
