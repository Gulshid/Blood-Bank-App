import 'package:flutter/material.dart';
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
        padding: const EdgeInsets.all(16),
        children: [
          // Digital Passcard Design
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8E0E00), Color(0xFF1F1C1C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryCrimson.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
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
                    const Row(
                      children: [
                        Icon(Icons.health_and_safety, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          'LIFEPULSE DONOR PASS',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    BloodGroupBadge(
                      group: user.bloodGroup,
                      size: 42,
                      isSelected: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pass ID: ${user.donorPassCode}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL DONATIONS',
                          style: TextStyle(fontSize: 10, color: Colors.white60),
                        ),
                        AnimatedCounter(
                          value: user.totalDonationsCount,
                          suffix: ' Times',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LIVES IMPACTED',
                          style: TextStyle(fontSize: 10, color: Colors.white60),
                        ),
                        AnimatedCounter(
                          value: user.livesSavedEstimate,
                          suffix: ' Lives',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.statusOptimal,
                          ),
                        ),
                      ],
                    ),
                    // Simulated QR Code Symbol
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.qr_code_2,
                        size: 36,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Donation Eligibility Countdown
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: AppTheme.medicalTealAccent),
                    const SizedBox(width: 10),
                    const Text(
                      'Donation Readiness Status',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: user.daysUntilNextEligible == 0
                            ? AppTheme.statusOptimal.withValues(alpha: 0.15)
                            : Colors.amber.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        user.daysUntilNextEligible == 0
                            ? 'READY NOW'
                            : 'REST PERIOD',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: user.daysUntilNextEligible == 0
                              ? AppTheme.statusOptimal
                              : Colors.amber,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  user.daysUntilNextEligible == 0
                      ? 'You are fully eligible to donate blood or platelets today!'
                      : 'You can donate again in ${user.daysUntilNextEligible} days.',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Achievements & Hero Badges
          const Text(
            'Hero Achievements',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

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
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: badge.isUnlocked
                            ? AppTheme.goldBadge.withValues(alpha: 0.2)
                            : Colors.grey.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        badge.isUnlocked ? Icons.stars : Icons.lock_outline,
                        color: badge.isUnlocked ? AppTheme.goldBadge : Colors.grey,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            badge.title,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: badge.isUnlocked ? null : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            badge.description,
                            style: const TextStyle(
                              fontSize: 10,
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
          const SizedBox(height: 24),

          // History log
          const Text(
            'Donation History',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...user.donationHistory.asMap().entries.map((entry) {
            final index = entry.key;
            final rec = entry.value;
            return FadeSlideIn(
              index: index,
              offsetY: 14,
              child: GlassCard(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const Icon(Icons.water_drop, color: AppTheme.primaryCrimson, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rec.location,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${rec.donationType} • ${rec.volumeMl} ml',
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${rec.date.day}/${rec.date.month}/${rec.date.year}',
                    style: const TextStyle(
                      fontSize: 12,
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
