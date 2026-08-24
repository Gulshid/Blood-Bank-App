import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/donor_profile.dart';
import '../theme/app_theme.dart';
import 'animations/press_scale.dart';
import 'blood_group_badge.dart';
import 'glass_card.dart';

class DonorCard extends StatelessWidget {
  final DonorProfile donor;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const DonorCard({
    super.key,
    required this.donor,
    this.onCall,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = donor.availability == DonorAvailability.available;

    return GlassCard(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          Hero(
            tag: 'donor_badge_${donor.id}',
            child: BloodGroupBadge(group: donor.bloodGroup, size: 54.r, isSelected: true),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        donor.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (donor.isVerifiedMedical) ...[
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.verified,
                        size: 16.sp,
                        color: AppTheme.medicalTealAccent,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13.sp,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${donor.city} • ${donor.distanceKm.toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppTheme.statusOptimal.withValues(alpha: 0.15)
                        : Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    isAvailable ? 'Available to Donate' : 'Eligible Soon',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? AppTheme.statusOptimal
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              PressScale(
                onTap: onCall,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: AppTheme.medicalTeal,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone, size: 16.sp, color: Colors.white),
                ),
              ),
              SizedBox(height: 6.h),
              PressScale(
                onTap: onMessage,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCrimson.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.message,
                    size: 16.sp,
                    color: AppTheme.primaryCrimson,
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
