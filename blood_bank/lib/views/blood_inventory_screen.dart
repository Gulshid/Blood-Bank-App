import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/app_provider.dart';
import '../utils/page_transitions.dart';
import '../widgets/animations/fade_slide_in.dart';
import '../widgets/inventory_card.dart';
import 'appointment_screen.dart';

class BloodInventoryScreen extends StatelessWidget {
  const BloodInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final centers = provider.bloodCenters;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Bank Stock Monitor'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          // Banner summary
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Icon(Icons.inventory_2_outlined, color: Colors.white, size: 32.sp),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Regional Blood Stock Network',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Tracking ${centers.length} regional blood banks & emergency reserves in real-time.',
                        style: TextStyle(fontSize: 11.sp, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            'Nearby Hospital Blood Banks:',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12.h),

          ...centers.asMap().entries.map((entry) {
            final index = entry.key;
            final center = entry.value;
            return FadeSlideIn(
              index: index,
              child: InventoryCard(
                center: center,
                onBookSlot: () {
                  pushSlideFade(
                    context,
                    AppointmentScreen(preSelectedCenter: center.name),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
