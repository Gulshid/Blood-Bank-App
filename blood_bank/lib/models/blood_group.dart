/// Core blood-group data model.
///
/// This file intentionally contains only *general medical reference facts*
/// about the 8 ABO/Rh blood groups (compatibility rules, rarity, and
/// commonly cited population associations). There is no donor, inventory,
/// or request data here — this app is a pure educational compatibility
/// visualizer, not a donor network.
library;

enum BloodGroup { oNeg, oPos, aNeg, aPos, bNeg, bPos, abNeg, abPos }

extension BloodGroupLabel on BloodGroup {
  String get label {
    switch (this) {
      case BloodGroup.oNeg:
        return 'O-';
      case BloodGroup.oPos:
        return 'O+';
      case BloodGroup.aNeg:
        return 'A-';
      case BloodGroup.aPos:
        return 'A+';
      case BloodGroup.bNeg:
        return 'B-';
      case BloodGroup.bPos:
        return 'B+';
      case BloodGroup.abNeg:
        return 'AB-';
      case BloodGroup.abPos:
        return 'AB+';
    }
  }
}

class BloodGroupInfo {
  final BloodGroup group;

  /// Approx. share of the general population that carries this group.
  final String rarityPercent;

  /// True for the two rarest groups (AB-, B-) — used to badge "Rare".
  final bool isRare;

  /// Groups this blood type can safely donate red cells to.
  final List<BloodGroup> canGiveTo;

  /// Groups this blood type can safely receive red cells from.
  final List<BloodGroup> canReceiveFrom;

  /// Short, general-education facts. Anything about statistical health
  /// associations is explicitly hedged as non-diagnostic.
  final List<String> facts;

  const BloodGroupInfo({
    required this.group,
    required this.rarityPercent,
    required this.isRare,
    required this.canGiveTo,
    required this.canReceiveFrom,
    required this.facts,
  });
}

const Map<BloodGroup, BloodGroupInfo> bloodGroupData = {
  BloodGroup.oNeg: BloodGroupInfo(
    group: BloodGroup.oNeg,
    rarityPercent: '6.6%',
    isRare: false,
    canGiveTo: [
      BloodGroup.oNeg,
      BloodGroup.oPos,
      BloodGroup.aNeg,
      BloodGroup.aPos,
      BloodGroup.bNeg,
      BloodGroup.bPos,
      BloodGroup.abNeg,
      BloodGroup.abPos,
    ],
    canReceiveFrom: [BloodGroup.oNeg],
    facts: [
      'Universal donor — safe for almost any patient in an emergency, including newborns.',
      'Because it fits every recipient, hospitals draw on O- stock fastest, so it is chronically in short supply.',
      'Can only receive O- blood itself, which limits its own transfusion options.',
    ],
  ),
  BloodGroup.oPos: BloodGroupInfo(
    group: BloodGroup.oPos,
    rarityPercent: '37.4%',
    isRare: false,
    canGiveTo: [BloodGroup.oPos, BloodGroup.aPos, BloodGroup.bPos, BloodGroup.abPos],
    canReceiveFrom: [BloodGroup.oPos, BloodGroup.oNeg],
    facts: [
      'The most common blood type worldwide, making up over a third of most populations.',
      'Most frequently transfused type in trauma and emergency medicine simply due to its abundance.',
      'High turnover means regular O+ donors are always in demand despite the type being common.',
    ],
  ),
  BloodGroup.aNeg: BloodGroupInfo(
    group: BloodGroup.aNeg,
    rarityPercent: '6.3%',
    isRare: false,
    canGiveTo: [BloodGroup.aNeg, BloodGroup.aPos, BloodGroup.abNeg, BloodGroup.abPos],
    canReceiveFrom: [BloodGroup.aNeg, BloodGroup.oNeg],
    facts: [
      'Can donate to both A and AB recipients regardless of their Rh factor.',
      'Rh-negative overall, so it matters especially for Rh-negative pregnancies and transfusions.',
      'Some population studies note statistical links between type A and clotting-factor levels — this is an observed trend, not a diagnosis.',
    ],
  ),
  BloodGroup.aPos: BloodGroupInfo(
    group: BloodGroup.aPos,
    rarityPercent: '35.7%',
    isRare: false,
    canGiveTo: [BloodGroup.aPos, BloodGroup.abPos],
    canReceiveFrom: [BloodGroup.aPos, BloodGroup.aNeg, BloodGroup.oPos, BloodGroup.oNeg],
    facts: [
      'The second most common blood type in most populations.',
      'Wide receiving pool (A and O donors) makes it relatively easy to supply for this group.',
      'Some cohort studies have noted associations between type A and certain gut-microbiome and cardiovascular patterns — correlational, not causal or diagnostic.',
    ],
  ),
  BloodGroup.bNeg: BloodGroupInfo(
    group: BloodGroup.bNeg,
    rarityPercent: '1.5%',
    isRare: true,
    canGiveTo: [BloodGroup.bNeg, BloodGroup.bPos, BloodGroup.abNeg, BloodGroup.abPos],
    canReceiveFrom: [BloodGroup.bNeg, BloodGroup.oNeg],
    facts: [
      'One of the rarest blood types overall — under 2% of most populations.',
      'More common among people of South Asian and East Asian descent than in the general global average.',
      'Donation centers frequently list B- as a priority-need type due to chronic shortages.',
    ],
  ),
  BloodGroup.bPos: BloodGroupInfo(
    group: BloodGroup.bPos,
    rarityPercent: '8.5%',
    isRare: false,
    canGiveTo: [BloodGroup.bPos, BloodGroup.abPos],
    canReceiveFrom: [BloodGroup.bPos, BloodGroup.bNeg, BloodGroup.oPos, BloodGroup.oNeg],
    facts: [
      'Found more frequently in people of African and Asian descent than the global average.',
      'Compatible with two receiving groups (B and O), giving it decent donor flexibility.',
      'No confirmed unique disease risk; population-level correlations exist in research but aren\'t used clinically as predictors.',
    ],
  ),
  BloodGroup.abNeg: BloodGroupInfo(
    group: BloodGroup.abNeg,
    rarityPercent: '0.6%',
    isRare: true,
    canGiveTo: [BloodGroup.abNeg, BloodGroup.abPos],
    canReceiveFrom: [BloodGroup.abNeg, BloodGroup.aNeg, BloodGroup.bNeg, BloodGroup.oNeg],
    facts: [
      'The rarest of all 8 blood groups, found in well under 1% of most populations.',
      'Can receive from any Rh-negative donor group, giving it more flexibility than other rare types.',
      'AB plasma (from AB- and AB+ donors) is a universal plasma donor, valuable in trauma care.',
    ],
  ),
  BloodGroup.abPos: BloodGroupInfo(
    group: BloodGroup.abPos,
    rarityPercent: '3.4%',
    isRare: false,
    canGiveTo: [BloodGroup.abPos],
    canReceiveFrom: [
      BloodGroup.oNeg,
      BloodGroup.oPos,
      BloodGroup.aNeg,
      BloodGroup.aPos,
      BloodGroup.bNeg,
      BloodGroup.bPos,
      BloodGroup.abNeg,
      BloodGroup.abPos,
    ],
    facts: [
      'Universal recipient — can safely receive red cells from any of the 8 blood groups.',
      'Can only give red cells to other AB+ patients, which limits its usefulness as a donor.',
      'AB+ donors are especially prized for plasma donation, since AB plasma suits any recipient.',
    ],
  ),
};

const List<BloodGroup> bloodGroupOrder = [
  BloodGroup.oNeg,
  BloodGroup.oPos,
  BloodGroup.aNeg,
  BloodGroup.aPos,
  BloodGroup.bNeg,
  BloodGroup.bPos,
  BloodGroup.abNeg,
  BloodGroup.abPos,
];
