import 'dart:math' as math;
import 'package:flutter/material.dart';
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
    setState(() => _selected = group);
    _controller.forward(from: 0);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stageSize = math.min(1.sw, 400.w) - 32.w;

    return Scaffold(
      appBar: AppBar(title: const Text('Blood Compatibility')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                        children: [
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
