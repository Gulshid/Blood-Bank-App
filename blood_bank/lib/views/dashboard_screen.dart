import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../utils/page_transitions.dart';
import '../widgets/animations/animated_counter.dart';
import '../widgets/animations/fade_slide_in.dart';
import '../widgets/animations/pulse_dot.dart';
import '../widgets/blood_group_badge.dart';
import '../widgets/emergency_request_card.dart';
import '../widgets/glass_card.dart';
import '../widgets/stat_card.dart';
import 'create_request_screen.dart';
import 'request_detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final user = provider.currentUser;
    final activeRequests = provider.activeRequests;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar Ticker Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryCrimsonDark,
                    AppTheme.darkSurface,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppTheme.primaryCrimson,
                        child: Text(
                          user.name.split(' ').map((e) => e[0]).take(2).join(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome back,',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Text(
                              user.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BloodGroupBadge(
                        group: user.bloodGroup,
                        size: 46,
                        isSelected: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Lives Saved Ticker Banner
                  GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryCrimson,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AnimatedCounter(
                                value: user.livesSavedEstimate,
                                suffix: ' Lives Impacted',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                user.daysUntilNextEligible == 0 ? "You are eligible to donate today!" : "Next eligible donation in ${user.daysUntilNextEligible} days",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: user.daysUntilNextEligible == 0
                                      ? AppTheme.statusOptimal
                                      : Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: provider.toggleTheme,
                          icon: Icon(
                            provider.isDarkMode
                                ? Icons.wb_sunny_outlined
                                : Icons.nightlight_round_outlined,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Quick Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Network Metrics',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      StatCard(
                        title: 'Urgent Calls',
                        count: activeRequests.length,
                        subtitle: 'Active Nearby',
                        icon: Icons.notifications_active,
                        iconColor: AppTheme.statusCritical,
                        onTap: () => provider.setTabIndex(0),
                      ),
                      const SizedBox(width: 10),
                      StatCard(
                        title: 'Active Donors',
                        count: provider.filteredDonors.length,
                        subtitle: 'Available Now',
                        icon: Icons.people_outline,
                        iconColor: AppTheme.medicalTealAccent,
                        onTap: () => provider.setTabIndex(1),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Quick Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            pushSlideFade(context, const CreateRequestScreen());
                          },
                          icon: const Icon(Icons.add_alert_rounded),
                          label: const Text('Post Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCrimson,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => provider.setTabIndex(2),
                          icon: const Icon(Icons.local_hospital_outlined),
                          label: const Text('Stock Levels'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppTheme.medicalTeal),
                            foregroundColor: AppTheme.medicalTealAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Live Feed Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Live Emergency Feed',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.statusCritical.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const PulseDot(color: AppTheme.statusCritical, size: 8),
                            const SizedBox(width: 2),
                            Text(
                              '${activeRequests.length} Live',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.statusCritical,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // List of Emergency Request Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final request = activeRequests[index];
                  return FadeSlideIn(
                    index: index,
                    child: EmergencyRequestCard(
                      request: request,
                      onTap: () {
                        pushSlideFade(context, RequestDetailScreen(request: request));
                      },
                      onRespond: () {
                        provider.respondToDonation(request.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Thank you! Response recorded for ${request.patientName}\'s call.'),
                            backgroundColor: AppTheme.statusOptimal,
                          ),
                        );
                      },
                    ),
                  );
                },
                childCount: activeRequests.length,
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }
}
