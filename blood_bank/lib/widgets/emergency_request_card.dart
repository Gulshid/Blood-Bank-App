import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_request.dart';
import '../theme/app_theme.dart';
import 'animations/press_scale.dart';
import 'blood_group_badge.dart';
import 'glass_card.dart';

class EmergencyRequestCard extends StatelessWidget {
  final BloodRequest request;
  final VoidCallback? onRespond;
  final VoidCallback? onTap;

  const EmergencyRequestCard({
    super.key,
    required this.request,
    this.onRespond,
    this.onTap,
  });

  Color _getUrgencyColor(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.critical:
        return AppTheme.statusCritical;
      case UrgencyLevel.urgent:
        return AppTheme.statusUrgent;
      case UrgencyLevel.standard:
        return AppTheme.medicalTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor(request.urgency);
    final progress = request.unitsNeeded == 0
        ? 0.0
        : (request.unitsFulfilled / request.unitsNeeded).clamp(0.0, 1.0);

    return PressScale(
      onTap: onTap,
      scaleAmount: 0.98,
      child: GlassCard(
      margin: EdgeInsets.only(bottom: 14.h),
      borderColor: request.urgency == UrgencyLevel.critical
          ? AppTheme.statusCritical.withValues(alpha: 0.4)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'blood_badge_${request.id}',
                child: BloodGroupBadge(
                  group: request.bloodGroup,
                  size: 52.r,
                  isSelected: true,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: urgencyColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(color: urgencyColor, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                request.urgency == UrgencyLevel.critical
                                    ? Icons.warning_amber_rounded
                                    : Icons.access_time_rounded,
                                size: 12.sp,
                                color: urgencyColor,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                request.urgency.label.split(' ')[0],
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                  color: urgencyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.near_me_outlined,
                          size: 14.sp,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${request.distanceKm.toStringAsFixed(1)} km away',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Patient: ${request.patientName}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      request.hospitalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            request.medicalReason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.sp, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 14.h),
          // Unit progress meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Units Required: ${request.unitsFulfilled}/${request.unitsNeeded} Units',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: urgencyColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: progress.toDouble()),
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              builder: (context, animatedProgress, child) {
                return LinearProgressIndicator(
                  value: animatedProgress,
                  minHeight: 6.h,
                  backgroundColor: Colors.grey.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(urgencyColor),
                );
              },
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: Icon(Icons.info_outline, size: 16.sp),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRespond,
                  icon: Icon(Icons.volunteer_activism, size: 16.sp),
                  label: const Text('Donate Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCrimson,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
