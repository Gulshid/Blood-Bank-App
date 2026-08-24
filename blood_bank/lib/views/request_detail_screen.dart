import 'package:blood_bank/models/blood_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_request.dart';
import '../providers/app_provider.dart';
import '../services/compatibility_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_group_badge.dart';
import '../widgets/glass_card.dart';

class RequestDetailScreen extends StatelessWidget {
  final BloodRequest request;
  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final user = provider.currentUser;

    final isUserCompatible = CompatibilityEngine.isCompatible(
      donor: user.bloodGroup,
      recipient: request.bloodGroup,
    );

    final compatibleGroupTypes = CompatibilityEngine.getCompatibleDonors(request.bloodGroup);
    final matchingDonors = provider.filteredDonors
        .where((donor) => compatibleGroupTypes.contains(donor.bloodGroup))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Call Details'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          GlassCard(
            borderColor: request.urgency == UrgencyLevel.critical
                ? AppTheme.statusCritical
                : null,
            child: Row(
              children: [
                Hero(
                  tag: 'blood_badge_${request.id}',
                  child: BloodGroupBadge(
                    group: request.bloodGroup,
                    size: 64.r,
                    isSelected: true,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient: ${request.patientName}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Required Group: ${request.bloodGroup.fullDescription}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppTheme.primaryCrimson,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Priority: ${request.urgency.label}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: request.urgency == UrgencyLevel.critical
                              ? AppTheme.statusCritical
                              : AppTheme.statusUrgent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: isUserCompatible
                  ? AppTheme.statusOptimal.withValues(alpha: 0.15)
                  : Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isUserCompatible
                    ? AppTheme.statusOptimal
                    : Colors.orange,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isUserCompatible ? Icons.check_circle : Icons.info,
                  color: isUserCompatible
                      ? AppTheme.statusOptimal
                      : Colors.orange,
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    isUserCompatible
                        ? 'Your blood type (${user.bloodGroup.label}) is medically compatible to donate for this patient!'
                        : 'Your blood type (${user.bloodGroup.label}) is not directly compatible with ${request.bloodGroup.label}. However, you can share this request with matching donors.',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.local_hospital, color: AppTheme.medicalTealAccent),
                    SizedBox(width: 8.w),
                    Text(
                      'Hospital Location',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  request.hospitalName,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2.h),
                Text(
                  request.hospitalAddress,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.near_me, size: 14.sp, color: AppTheme.medicalTeal),
                    SizedBox(width: 4.w),
                    Text(
                      'Distance: ${request.distanceKm.toStringAsFixed(1)} km from your current location',
                      style: TextStyle(fontSize: 12.sp, color: AppTheme.medicalTealAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.medical_information, color: AppTheme.primaryCrimson),
                    SizedBox(width: 8.w),
                    Text(
                      'Medical Case Notes',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  request.medicalReason,
                  style: TextStyle(fontSize: 13.sp, height: 1.4),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),

          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: Colors.amber),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    '${matchingDonors.length} registered donors found in network compatible with ${request.bloodGroup.label}',
                    style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Calling hospital desk: ${request.contactPhone}'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Call Hospital'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.respondToDonation(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            '❤️ Thank you! You have pledged to donate for this patient.'),
                        backgroundColor: AppTheme.statusOptimal,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text('Pledge Donation'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    backgroundColor: AppTheme.primaryCrimson,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}