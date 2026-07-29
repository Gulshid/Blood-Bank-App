import 'package:flutter/material.dart';
import '../models/blood_group.dart';
import '../models/blood_request.dart';
import '../theme/app_theme.dart';
import 'blood_group_badge.dart';
import 'glass_card.dart';

class EmergencyRequestCard extends StatelessWidget {
  final BloodRequest request;
  final VoidCallback? onRespond;
  final VoidCallback? onTap;

  const EmergencyRequestCard({
    super.key,
    required this.request,
    this.onRespond,
    this.onTap,
  });

  Color _getUrgencyColor(UrgencyLevel urgency) {
    switch (urgency) {
      case UrgencyLevel.critical:
        return AppTheme.statusCritical;
      case UrgencyLevel.urgent:
        return AppTheme.statusUrgent;
      case UrgencyLevel.standard:
        return AppTheme.medicalTeal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final urgencyColor = _getUrgencyColor(request.urgency);
    final progress = request.unitsNeeded == 0
        ? 0.0
        : (request.unitsFulfilled / request.unitsNeeded).clamp(0.0, 1.0);

    return GlassCard(
      onTap: onTap,
      margin: const EdgeInsets.only(bottom: 14),
      borderColor: request.urgency == UrgencyLevel.critical
          ? AppTheme.statusCritical.withOpacity(0.4)
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BloodGroupBadge(
                group: request.bloodGroup,
                size: 52,
                isSelected: true,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: urgencyColor.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: urgencyColor, width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                request.urgency == UrgencyLevel.critical
                                    ? Icons.warning_amber_rounded
                                    : Icons.access_time_rounded,
                                size: 12,
                                color: urgencyColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                request.urgency.label.split(' ')[0],
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: urgencyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.near_me_outlined,
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${request.distanceKm.toStringAsFixed(1)} km away',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Patient: ${request.patientName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      request.hospitalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            request.medicalReason,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 14),
          // Unit progress meter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Units Required: ${request.unitsFulfilled}/${request.unitsNeeded} Units',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: urgencyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(urgencyColor),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onRespond,
                  icon: const Icon(Icons.volunteer_activism, size: 16),
                  label: const Text('Donate Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryCrimson,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
