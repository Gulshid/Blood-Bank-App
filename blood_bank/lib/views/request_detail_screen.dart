import 'package:blood_bank/models/blood_group.dart';
import 'package:flutter/material.dart';
import '../models/blood_request.dart';
import '../providers/app_provider.dart';
import '../services/compatibility_engine.dart';
import '../theme/app_theme.dart';
import '../widgets/blood_group_badge.dart';
import '../widgets/glass_card.dart';

class RequestDetailScreen extends StatelessWidget {
  final BloodRequest request;
  const RequestDetailScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final user = provider.currentUser;

    final isUserCompatible = CompatibilityEngine.isCompatible(
      donor: user.bloodGroup,
      recipient: request.bloodGroup,
    );

    final compatibleGroupTypes = CompatibilityEngine.getCompatibleDonors(request.bloodGroup);
    final matchingDonors = provider.filteredDonors
        .where((donor) => compatibleGroupTypes.contains(donor.bloodGroup))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Call Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            borderColor: request.urgency == UrgencyLevel.critical
                ? AppTheme.statusCritical
                : null,
            child: Row(
              children: [
                BloodGroupBadge(
                  group: request.bloodGroup,
                  size: 64,
                  isSelected: true,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Patient: ${request.patientName}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Required Group: ${request.bloodGroup.fullDescription}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryCrimson,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Priority: ${request.urgency.label}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: request.urgency == UrgencyLevel.critical
                              ? AppTheme.statusCritical
                              : AppTheme.statusUrgent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUserCompatible
                  ? AppTheme.statusOptimal.withValues(alpha: 0.15)
                  : Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUserCompatible
                    ? AppTheme.statusOptimal
                    : Colors.orange,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isUserCompatible ? Icons.check_circle : Icons.info,
                  color: isUserCompatible
                      ? AppTheme.statusOptimal
                      : Colors.orange,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isUserCompatible
                        ? 'Your blood type (${user.bloodGroup.label}) is medically compatible to donate for this patient!'
                        : 'Your blood type (${user.bloodGroup.label}) is not directly compatible with ${request.bloodGroup.label}. However, you can share this request with matching donors.',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.local_hospital, color: AppTheme.medicalTealAccent),
                    SizedBox(width: 8),
                    Text(
                      'Hospital Location',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  request.hospitalName,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  request.hospitalAddress,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.near_me, size: 14, color: AppTheme.medicalTeal),
                    const SizedBox(width: 4),
                    Text(
                      'Distance: ${request.distanceKm.toStringAsFixed(1)} km from your current location',
                      style: const TextStyle(fontSize: 12, color: AppTheme.medicalTealAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.medical_information, color: AppTheme.primaryCrimson),
                    SizedBox(width: 8),
                    Text(
                      'Medical Case Notes',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  request.medicalReason,
                  style: const TextStyle(fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          GlassCard(
            child: Row(
              children: [
                const Icon(Icons.hub_outlined, color: Colors.amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${matchingDonors.length} registered donors found in network compatible with ${request.bloodGroup.label}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Calling hospital desk: ${request.contactPhone}'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone),
                  label: const Text('Call Hospital'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    provider.respondToDonation(request.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            '❤️ Thank you! You have pledged to donate for this patient.'),
                        backgroundColor: AppTheme.statusOptimal,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.volunteer_activism),
                  label: const Text('Pledge Donation'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppTheme.primaryCrimson,
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