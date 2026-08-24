import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      margin: EdgeInsets.only(bottom: 14.h),
      borderColor: hasWarning ? AppTheme.statusCritical.withValues(alpha: 0.4) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppTheme.medicalTeal.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: AppTheme.medicalTealAccent,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      center.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
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
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.schedule, size: 14.sp, color: Colors.grey.shade400),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  center.operatingHours,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCrimson.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  'Stock: ${center.totalUnitsAvailable} Units',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryCrimson,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            'Live Inventory Status (By Blood Type):',
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          // Grid layout of blood group stock indicators
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: center.stocks.map((groupStock) {
              final stockColor = _getStockColor(groupStock.status);
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black26
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8.r),
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
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: stockColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '${groupStock.unitsAvailable}',
                        style: TextStyle(
                          fontSize: 11.sp,
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
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: PressScale(
              scaleAmount: 0.98,
              onTap: onBookSlot,
              child: OutlinedButton.icon(
                onPressed: onBookSlot,
                icon: Icon(Icons.calendar_month, size: 16.sp),
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
