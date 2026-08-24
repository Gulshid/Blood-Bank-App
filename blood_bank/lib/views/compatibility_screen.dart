import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../models/blood_group.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_group_node.dart';
import '../widgets/compatibility_info_panel.dart';
import '../widgets/hub_line_painter.dart';

class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen>
    with SingleTickerProviderStateMixin {
  BloodGroup? _selected;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(BloodGroup group) {
    HapticFeedback.selectionClick();
    if (_selected == group) return;
    setState(() => _selected = group);
    _controller.forward(from: 0);
  }

  void _clearSelection() {
    HapticFeedback.lightImpact();
    setState(() => _selected = null);
    _controller.reset();
  }

  Offset _nodePosition(int index, int count, Size stage) {
    final center = Offset(stage.width / 2, stage.height / 2);
    final radius = math.min(stage.width, stage.height) / 2 - 34.w;
    final angle = (index / count) * 2 * math.pi - math.pi / 2;
    return center + Offset(math.cos(angle), math.sin(angle)) * radius;
  }

  NodeRole _roleFor(BloodGroup group) {
    if (_selected == null) return NodeRole.neutral;
    if (group == _selected) return NodeRole.selected;
    final info = bloodGroupData[_selected]!;
    final canGive = info.canGiveTo.contains(group);
    final canReceive = info.canReceiveFrom.contains(group);
    if (canGive && canReceive) return NodeRole.giveAndReceive;
    if (canGive) return NodeRole.give;
    if (canReceive) return NodeRole.receive;
    return NodeRole.dim;
  }

  void _showAboutSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppTheme.darkSurface : AppTheme.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      color: AppTheme.primaryCrimson, size: 20.w),
                  SizedBox(width: 8.w),
                  Text(
                    'How compatibility works',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              _aboutLine(
                isDark,
                'Blood type is determined by the ABO group (A, B, AB, O) plus the Rh factor (+ or −).',
              ),
              _aboutLine(
                isDark,
                'O- is the universal donor — safe for any patient. AB+ is the universal recipient — can receive from anyone.',
              ),
              _aboutLine(
                isDark,
                'Rh-negative blood can generally go to both Rh-negative and Rh-positive recipients; Rh-positive blood can only go to Rh-positive recipients.',
              ),
              _aboutLine(
                isDark,
                'This screen shows red-cell donation rules for general education — always confirm with a lab crossmatch before any real transfusion.',
              ),
              SizedBox(height: 6.h),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Got it'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _aboutLine(bool isDark, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•  ', style: TextStyle(color: isDark ? Colors.white38 : Colors.black38)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stageSize = math.min(1.sw, 400.w) - 32.w;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 6.h),
        child: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
          child: SafeArea(
            bottom: false,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              titleSpacing: 4.w,
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.water_drop_rounded,
                        color: Colors.white, size: 17.w),
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Blood Compatibility',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '8 groups · ABO & Rh system',
                        style: TextStyle(
                          fontSize: 10.5.sp,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                if (_selected != null)
                  IconButton(
                    tooltip: 'Reset',
                    icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                    onPressed: _clearSelection,
                  ),
                IconButton(
                  tooltip: 'About',
                  icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
                  onPressed: _showAboutSheet,
                ),
                SizedBox(width: 4.w),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tap a blood group to see which groups it can give to and receive from.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  color: isDark ? Colors.white54 : Colors.black54,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 14.h),
              _quickShortcuts(isDark),
              SizedBox(height: 18.h),
              Center(
                child: SizedBox(
                  width: stageSize,
                  height: stageSize,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final stage = Size(constraints.maxWidth, constraints.maxHeight);
                      final positions = <BloodGroup, Offset>{
                        for (var i = 0; i < bloodGroupOrder.length; i++)
                          bloodGroupOrder[i]:
                              _nodePosition(i, bloodGroupOrder.length, stage)
                      };

                      final lines = <HubLine>[];
                      if (_selected != null) {
                        final info = bloodGroupData[_selected]!;
                        final from = positions[_selected]!;
                        for (final g in info.canGiveTo) {
                          if (g == _selected) continue;
                          lines.add(HubLine(
                            start: from,
                            end: positions[g]!,
                            color: HubLineColors.give,
                          ));
                        }
                        for (final g in info.canReceiveFrom) {
                          if (g == _selected) continue;
                          lines.add(HubLine(
                            start: positions[g]!,
                            end: from,
                            color: HubLineColors.receive,
                          ));
                        }
                      }

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Soft ambient glow behind the hub once something is selected.
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: _selected == null ? 0 : 1,
                            child: Container(
                              width: stage.width * 0.75,
                              height: stage.height * 0.75,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppTheme.primaryCrimson.withValues(alpha: 0.16),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, _) {
                              return CustomPaint(
                                size: stage,
                                painter: HubLinePainter(
                                  lines: lines,
                                  progress: _controller.value,
                                ),
                              );
                            },
                          ),
                          for (final group in bloodGroupOrder)
                            Positioned(
                              left: positions[group]!.dx - 29.w,
                              top: positions[group]!.dy - 29.w,
                              child: BloodGroupNode(
                                group: group,
                                role: _roleFor(group),
                                onTap: () => _select(group),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              _legend(isDark),
              SizedBox(height: 18.h),
              CompatibilityInfoPanel(selected: _selected),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickShortcuts(bool isDark) {
    Widget shortcut({
      required String label,
      required String sub,
      required BloodGroup group,
      required IconData icon,
    }) {
      final active = _selected == group;
      return Expanded(
        child: GestureDetector(
          onTap: () => _select(group),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: active
                  ? AppTheme.primaryCrimson.withValues(alpha: 0.12)
                  : (isDark ? AppTheme.darkCardSurface : AppTheme.lightCardSurface),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: active
                    ? AppTheme.primaryCrimson
                    : (isDark ? Colors.white12 : Colors.black12),
                width: active ? 1.4 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 16.w,
                    color: active
                        ? AppTheme.primaryCrimson
                        : (isDark ? Colors.white54 : Colors.black45)),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$label · ${group.label}',
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        sub,
                        style: TextStyle(
                          fontSize: 9.5.sp,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        shortcut(
          label: 'Universal donor',
          sub: 'Gives to everyone',
          group: BloodGroup.oNeg,
          icon: Icons.arrow_upward_rounded,
        ),
        SizedBox(width: 10.w),
        shortcut(
          label: 'Universal recipient',
          sub: 'Receives from everyone',
          group: BloodGroup.abPos,
          icon: Icons.arrow_downward_rounded,
        ),
      ],
    );
  }

  Widget _legend(bool isDark) {
    Widget dot(Color c) => Container(
          width: 9.w,
          height: 9.w,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        );

    TextStyle labelStyle = TextStyle(
      fontSize: 11.5.sp,
      color: isDark ? Colors.white60 : Colors.black54,
    );

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.w,
      runSpacing: 6.h,
      children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          dot(HubLineColors.give),
          SizedBox(width: 6.w),
          Text('Can give to', style: labelStyle),
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [
          dot(HubLineColors.receive),
          SizedBox(width: 6.w),
          Text('Can receive from', style: labelStyle),
        ]),
        Row(mainAxisSize: MainAxisSize.min, children: [
          dot(AppTheme.goldBadge),
          SizedBox(width: 6.w),
          Text('Both', style: labelStyle),
        ]),
      ],
    );
  }
}
