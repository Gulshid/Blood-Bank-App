import 'package:flutter/material.dart';
import '../models/blood_group.dart';
import '../models/blood_inventory.dart';
import '../theme/app_theme.dart';
import 'animations/press_scale.dart';
import 'glass_card.dart';

class InventoryCard extends StatelessWidget {
  final BloodBankCenter center;
  final VoidCallback? onBookSlot;

  const InventoryCard({super.key, required this.center, this.onBookSlot});

  Color _getStockColor(StockStatus status) {
    switch (status) {
      case StockStatus.critical:
        return AppTheme.statusCritical;
      case StockStatus.low:
        return AppTheme.statusUrgent;
      case StockStatus.moderate:
        return Colors.amber;
      case StockStatus.optimal:
        return AppTheme.statusOptimal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasWarning = center.hasCriticalShortage;

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      borderColor: hasWarning ? AppTheme.statusCritical.withValues(alpha: 0.4) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.medicalTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_hospital,
                  color: AppTheme.medicalTealAccent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${center.address} • ${center.distanceKm.toStringAsFixed(1)} km',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.schedule, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                center.operatingHours,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCrimson.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Stock: ${center.totalUnitsAvailable} Units',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryCrimson,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Live Inventory Status (By Blood Type):',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          // Grid layout of blood group stock indicators
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: center.stocks.map((groupStock) {
              final stockColor = _getStockColor(groupStock.status);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black26
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: stockColor.withValues(alpha: 0.6),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      groupStock.bloodGroup.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: stockColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${groupStock.unitsAvailable}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: PressScale(
              scaleAmount: 0.98,
              onTap: onBookSlot,
              child: OutlinedButton.icon(
                onPressed: onBookSlot,
                icon: const Icon(Icons.calendar_month, size: 16),
                label: const Text('Schedule Donation Slot'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppTheme.medicalTeal),
                  foregroundColor: AppTheme.medicalTealAccent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
