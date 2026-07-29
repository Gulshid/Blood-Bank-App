import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: isSelected
              ? AppTheme.primaryGradient
              : LinearGradient(
                  colors: [
                    AppTheme.primaryCrimson.withOpacity(0.15),
                    AppTheme.primaryCrimsonDark.withOpacity(0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          border: Border.all(
            color: isSelected
                ? Colors.white
                : AppTheme.primaryCrimson.withOpacity(0.4),
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryCrimson.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : [],
        ),
        child: Center(
          child: Text(
            group.label,
            style: TextStyle(
              fontSize: size * 0.36,
              fontWeight: FontWeight.w900,
              color: isSelected ? Colors.white : AppTheme.primaryCrimson,
            ),
          ),
        ),
      ),
    );
  }
}