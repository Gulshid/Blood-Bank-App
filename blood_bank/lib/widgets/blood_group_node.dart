import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_group.dart';
import '../theme/app_theme.dart';
import 'hub_line_painter.dart';

enum NodeRole { neutral, selected, give, receive, giveAndReceive, dim }

class BloodGroupNode extends StatelessWidget {
  final BloodGroup group;
  final NodeRole role;
  final VoidCallback onTap;

  const BloodGroupNode({
    super.key,
    required this.group,
    required this.role,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    late final Color bg;
    late final Color border;
    late final Color text;
    double scale = 1.0;
    double opacity = 1.0;

    final neutralBg = isDark ? AppTheme.darkCardSurface : AppTheme.lightCardSurface;
    final neutralBorder = isDark ? Colors.white24 : Colors.black12;
    final neutralText = isDark ? Colors.white70 : Colors.black87;

    switch (role) {
      case NodeRole.selected:
        bg = AppTheme.primaryCrimson;
        border = AppTheme.primaryCrimsonLight;
        text = Colors.white;
        scale = 1.18;
        break;
      case NodeRole.give:
        bg = neutralBg;
        border = HubLineColors.give;
        text = neutralText;
        break;
      case NodeRole.receive:
        bg = neutralBg;
        border = HubLineColors.receive;
        text = neutralText;
        break;
      case NodeRole.giveAndReceive:
        bg = neutralBg;
        border = AppTheme.goldBadge;
        text = neutralText;
        break;
      case NodeRole.dim:
        bg = neutralBg;
        border = neutralBorder;
        text = neutralText;
        opacity = 0.28;
        break;
      case NodeRole.neutral:
        bg = neutralBg;
        border = neutralBorder;
        text = neutralText;
        break;
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: opacity,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: border, width: role == NodeRole.selected ? 3 : 2),
              boxShadow: role == NodeRole.selected
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryCrimson.withValues(alpha: 0.5),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : (role == NodeRole.give || role == NodeRole.receive || role == NodeRole.giveAndReceive)
                      ? [
                          BoxShadow(
                            color: border.withValues(alpha: 0.35),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
            ),
            alignment: Alignment.center,
            child: Text(
              group.label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: text,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
