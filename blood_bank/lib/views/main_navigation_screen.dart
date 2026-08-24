import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import 'appointment_screen.dart';
import 'blood_inventory_screen.dart';
import 'create_request_screen.dart';
import 'dashboard_screen.dart';
import 'donor_profile_pass_screen.dart';
import 'donor_search_screen.dart';

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  static const List<Widget> _screens = [
    DashboardScreen(),
    DonorSearchScreen(),
    BloodInventoryScreen(),
    AppointmentScreen(),
    DonorProfilePassScreen(),
  ];

  static const List<IconData> _icons = [
    Icons.dashboard_rounded,
    Icons.search,
    Icons.local_hospital_rounded,
    Icons.calendar_month_rounded,
    Icons.badge_rounded,
  ];

  static const List<String> _labels = [
    'Dashboard',
    'Donors',
    'Stock',
    'Book',
    'My Pass',
  ];

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final currentIndex = provider.currentTabIndex;
    final activeCount = provider.activeRequests.length;

    return Scaffold(
      body: _FadeOnIndexChange(
        index: currentIndex,
        child: IndexedStack(
          index: currentIndex,
          children: _screens,
        ),
      ),
      floatingActionButton: _AnimatedFab(
        onPressed: () => pushSlideFade(context, const CreateRequestScreen()),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10.r,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          height: 64.h,
          child: Row(
            children: List.generate(_icons.length, (index) {
              final isSelected = index == currentIndex;
              return Expanded(
                child: _NavBarItem(
                  icon: _icons[index],
                  label: _labels[index],
                  isSelected: isSelected,
                  badgeCount: index == 0 ? activeCount : 0,
                  onTap: () => provider.setTabIndex(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

/// Fades the (persistent) [child] in whenever [index] changes, without
/// ever recreating [child]'s subtree — so per-tab state (e.g. an in-progress
/// appointment form) survives switching tabs and back.
class _FadeOnIndexChange extends StatefulWidget {
  final int index;
  final Widget child;
  const _FadeOnIndexChange({required this.index, required this.child});

  @override
  State<_FadeOnIndexChange> createState() => _FadeOnIndexChangeState();
}

class _FadeOnIndexChangeState extends State<_FadeOnIndexChange>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
  }

  @override
  void didUpdateWidget(covariant _FadeOnIndexChange oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      child: widget.child,
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppTheme.primaryCrimson : Colors.grey;

    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Badge(
              label: Text('$badgeCount'),
              isLabelVisible: badgeCount > 0,
              backgroundColor: AppTheme.statusCritical,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutBack,
                builder: (context, t, child) {
                  return Transform.scale(
                    scale: 1.0 + (t * 0.18),
                    child: Icon(icon, color: color, size: 24.sp),
                  );
                },
              ),
            ),
            SizedBox(height: 3.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: isSelected ? 11.sp : 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedFab extends StatefulWidget {
  final VoidCallback onPressed;
  const _AnimatedFab({required this.onPressed});

  @override
  State<_AnimatedFab> createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<_AnimatedFab> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.92),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: FloatingActionButton.extended(
          onPressed: widget.onPressed,
          backgroundColor: AppTheme.primaryCrimson,
          icon: const Icon(Icons.add_alert_rounded, color: Colors.white),
          label: const Text(
            'Post Call',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
