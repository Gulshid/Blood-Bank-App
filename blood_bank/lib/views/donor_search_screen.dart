import 'package:flutter/material.dart';
import '../models/blood_group.dart';
import '../providers/app_provider.dart';
import '../services/compatibility_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/animations/fade_slide_in.dart';
import '../widgets/blood_group_badge.dart';
import '../widgets/donor_card.dart';
import '../widgets/glass_card.dart';

class DonorSearchScreen extends StatelessWidget {
  const DonorSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final filteredDonors = provider.filteredDonors;
    final selectedGroup = provider.selectedFilterGroup;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Compatible Donors'),
        actions: [
          if (selectedGroup != null)
            TextButton(
              onPressed: () => provider.setFilterBloodGroup(null),
              child: const Text(
                'Reset Filter',
                style: TextStyle(color: AppTheme.primaryCrimson),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section Header
          GlassCard(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Blood Type:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: BloodGroupType.values.map((group) {
                      final isSelected = selectedGroup == group;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: BloodGroupBadge(
                          group: group,
                          size: 42,
                          isSelected: isSelected,
                          onTap: () {
                            if (isSelected) {
                              provider.setFilterBloodGroup(null);
                            } else {
                              provider.setFilterBloodGroup(group);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Distance Radius: ${provider.maxDistanceFilterKm.toInt()} km',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Switch(
                      value: provider.showOnlyAvailableDonors,
                      onChanged: provider.toggleAvailableOnlyFilter,
                      activeThumbColor: AppTheme.primaryCrimson,
                    ),
                    const Text(
                      'Available Only',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Slider(
                  value: provider.maxDistanceFilterKm,
                  min: 5.0,
                  max: 50.0,
                  divisions: 9,
                  activeColor: AppTheme.primaryCrimson,
                  label: '${provider.maxDistanceFilterKm.toInt()} km',
                  onChanged: provider.setMaxDistanceFilter,
                ),
              ],
            ),
          ),

          // Medical compatibility note
          if (selectedGroup != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.medicalTeal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.medicalTeal, width: 1),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.science, color: AppTheme.medicalTealAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        CompatibilityEngine.getCompatibilityNote(selectedGroup),
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 10),

          // Donor List View
          Expanded(
            child: filteredDonors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No registered donors match your current filter.',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            provider.setFilterBloodGroup(null);
                            provider.setMaxDistanceFilter(50.0);
                          },
                          child: const Text('Clear All Filters'),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredDonors.length,
                    itemBuilder: (context, index) {
                      final donor = filteredDonors[index];
                      return FadeSlideIn(
                        index: index,
                        child: DonorCard(
                          donor: donor,
                          onCall: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Calling ${donor.name} (${donor.phone})...'),
                              ),
                            );
                          },
                          onMessage: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening chat with ${donor.name}...'),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
