import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/animations/animated_counter.dart';
import '../widgets/animations/fade_slide_in.dart';
import '../widgets/blood_group_badge.dart';
import '../widgets/glass_card.dart';

class DonorProfilePassScreen extends StatelessWidget {
  const DonorProfilePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final user = provider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Donor Pass & Impact'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          // Digital Passcard Design
          Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E0E00), Color(0xFF1F1C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCrimson.withValues(alpha: 0.3),
                  blurRadius: 15.r,
                  offset: Offset(0, 8.h),
                ),
              ],
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.health_and_safety, color: Colors.white, size: 24.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'LIFEPULSE DONOR PASS',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    BloodGroupBadge(
                      group: user.bloodGroup,
                      size: 42.r,
                      isSelected: true,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Pass ID: ${user.donorPassCode}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                    letterSpacing: 1.0,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TOTAL DONATIONS',
                          style: TextStyle(fontSize: 10.sp, color: Colors.white60),
                        ),
                        AnimatedCounter(
                          value: user.totalDonationsCount,
                          suffix: ' Times',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIVES IMPACTED',
                          style: TextStyle(fontSize: 10.sp, color: Colors.white60),
                        ),
                        AnimatedCounter(
                          value: user.livesSavedEstimate,
                          suffix: ' Lives',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.statusOptimal,
                          ),
                        ),
                      ],
                    ),
                    // Simulated QR Code Symbol
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        Icons.qr_code_2,
                        size: 36.sp,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Donation Eligibility Countdown
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppTheme.medicalTealAccent),
                    SizedBox(width: 10.w),
                    Flexible(
                      child: Text(
                        'Donation Readiness Status',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: user.daysUntilNextEligible == 0
                            ? AppTheme.statusOptimal.withValues(alpha: 0.15)
                            : Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        user.daysUntilNextEligible == 0
                            ? 'READY NOW'
                            : 'REST PERIOD',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                          color: user.daysUntilNextEligible == 0
                              ? AppTheme.statusOptimal
                              : Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  user.daysUntilNextEligible == 0
                      ? 'You are fully eligible to donate blood or platelets today!'
                      : 'You can donate again in ${user.daysUntilNextEligible} days.',
                  style: TextStyle(fontSize: 13.sp),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Achievements & Hero Badges
          Text(
            'Hero Achievements',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: user.badges.length,
            itemBuilder: (context, index) {
              final badge = user.badges[index];
              return FadeSlideIn(
                index: index,
                offsetY: 14,
                child: GlassCard(
                padding: EdgeInsets.all(10.r),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: badge.isUnlocked
                            ? AppTheme.goldBadge.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badge.isUnlocked ? Icons.stars : Icons.lock_outline,
                        color: badge.isUnlocked ? AppTheme.goldBadge : Colors.grey,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badge.title,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: badge.isUnlocked ? null : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            badge.description,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),

          // History log
          Text(
            'Donation History',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          ...user.donationHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final rec = entry.value;
            return FadeSlideIn(
              index: index,
              offsetY: 14,
              child: GlassCard(
              margin: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Icon(Icons.water_drop, color: AppTheme.primaryCrimson, size: 24.sp),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.location,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${rec.donationType} • ${rec.volumeMl} ml',
                          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${rec.date.day}/${rec.date.month}/${rec.date.year}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
