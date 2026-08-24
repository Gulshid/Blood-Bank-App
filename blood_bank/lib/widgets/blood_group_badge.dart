import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_group.dart';
import '../theme/app_theme.dart';

class BloodGroupBadge extends StatelessWidget {
  final BloodGroupType group;
  final double size;
  final bool isSelected;
  final VoidCallback? onTap;

  const BloodGroupBadge({
    super.key,
    required this.group,
    this.size = 48.0,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scaledSize = size.r;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: scaledSize,
        height: scaledSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? AppTheme.primaryGradient
              : LinearGradient(
                  colors: [
                    AppTheme.primaryCrimson.withValues(alpha: 0.15),
                    AppTheme.primaryCrimsonDark.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : AppTheme.primaryCrimson.withValues(alpha: 0.4),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryCrimson.withValues(alpha: 0.5),
                    blurRadius: 10.r,
                    spreadRadius: 1.r,
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            group.label,
            style: TextStyle(
              fontSize: scaledSize * 0.36,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.white : AppTheme.primaryCrimson,
            ),
          ),
        ),
      ),
    );
  }
}