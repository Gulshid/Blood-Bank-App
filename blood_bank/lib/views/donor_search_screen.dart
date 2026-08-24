import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            margin: EdgeInsets.all(16.r),
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Blood Type:',
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: BloodGroupType.values.map((group) {
                      final isSelected = selectedGroup == group;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: BloodGroupBadge(
                          group: group,
                          size: 42.r,
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
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Distance Radius: ${provider.maxDistanceFilterKm.toInt()} km',
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Switch(
                      value: provider.showOnlyAvailableDonors,
                      onChanged: provider.toggleAvailableOnlyFilter,
                      activeThumbColor: AppTheme.primaryCrimson,
                    ),
                    Text(
                      'Available Only',
                      style: TextStyle(fontSize: 12.sp),
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
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppTheme.medicalTeal.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppTheme.medicalTeal, width: 1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.science, color: AppTheme.medicalTealAccent, size: 18.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        CompatibilityEngine.getCompatibilityNote(selectedGroup),
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: 10.h),

          // Donor List View
          Expanded(
            child: filteredDonors.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48.sp,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12.h),
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
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
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
