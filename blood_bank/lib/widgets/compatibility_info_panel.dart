import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_group.dart';
import '../theme/app_theme.dart';
import 'hub_line_painter.dart';

class CompatibilityInfoPanel extends StatelessWidget {
  final BloodGroup? selected;

  const CompatibilityInfoPanel({super.key, this.selected});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppTheme.darkCardSurface : AppTheme.lightSurface;
    final borderColor = isDark ? Colors.white12 : Colors.black12;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
      ),
      child: selected == null
          ? Container(
              key: const ValueKey('empty'),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: borderColor),
              ),
              child: Center(
                child: Text(
                  'Tap any blood group above to see who it can give to\nand receive from.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isDark ? Colors.white38 : Colors.black45,
                    height: 1.5,
                  ),
                ),
              ),
            )
          : _buildInfo(context, selected!, cardColor, borderColor, isDark),
    );
  }

  Widget _buildInfo(BuildContext context, BloodGroup group, Color cardColor,
      Color borderColor, bool isDark) {
    final info = bloodGroupData[group]!;
    final giveList = info.canGiveTo.where((g) => g != group).toList();
    final receiveList = info.canReceiveFrom.where((g) => g != group).toList();

    return Container(
      key: ValueKey(group),
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                group.label,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(width: 10.w),
              if (info.isRare)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppTheme.goldBadge.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppTheme.goldBadge.withValues(alpha: 0.6)),
                  ),
                  child: Text(
                    'RARE',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.goldBadge,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '${info.rarityPercent} of the population',
            style: TextStyle(
              fontSize: 12.sp,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
          SizedBox(height: 14.h),
          _chipRow(
            label: 'Can give to',
            groups: giveList,
            color: HubLineColors.give,
            isDark: isDark,
          ),
          SizedBox(height: 10.h),
          _chipRow(
            label: 'Can receive from',
            groups: receiveList,
            color: HubLineColors.receive,
            isDark: isDark,
          ),
          SizedBox(height: 16.h),
          Divider(color: borderColor, height: 1),
          SizedBox(height: 12.h),
          ...info.facts.map(
            (f) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('•  ', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38)),
                  Expanded(
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 12.5.sp,
                        height: 1.5,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipRow({
    required String label,
    required List<BloodGroup> groups,
    required Color color,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: groups.isEmpty
                ? [
                    Text('None',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: isDark ? Colors.white38 : Colors.black38))
                  ]
                : groups
                    .map(
                      (g) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: color.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          g.label,
                          style: TextStyle(
                            fontSize: 11.5.sp,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}
