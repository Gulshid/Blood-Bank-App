import 'package:flutter/material.dart';
import '../models/donor_profile.dart';
import '../theme/app_theme.dart';
import 'animations/press_scale.dart';
import 'blood_group_badge.dart';
import 'glass_card.dart';

class DonorCard extends StatelessWidget {
  final DonorProfile donor;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;

  const DonorCard({
    super.key,
    required this.donor,
    this.onCall,
    this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = donor.availability == DonorAvailability.available;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Hero(
            tag: 'donor_badge_${donor.id}',
            child: BloodGroupBadge(group: donor.bloodGroup, size: 54, isSelected: true),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        donor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (donor.isVerifiedMedical) ...[
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: AppTheme.medicalTealAccent,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${donor.city} • ${donor.distanceKm.toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isAvailable
                        ? AppTheme.statusOptimal.withValues(alpha: 0.15)
                        : Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isAvailable ? 'Available to Donate' : 'Eligible Soon',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? AppTheme.statusOptimal
                          : Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              PressScale(
                onTap: onCall,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppTheme.medicalTeal,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.phone, size: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 6),
              PressScale(
                onTap: onMessage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryCrimson.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.message,
                    size: 16,
                    color: AppTheme.primaryCrimson,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
