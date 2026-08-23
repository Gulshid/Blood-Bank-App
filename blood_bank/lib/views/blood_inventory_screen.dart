import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
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
        padding: const EdgeInsets.all(16),
        children: [
          // Banner summary
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF004D40), Color(0xFF00897B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: Colors.white, size: 32),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Regional Blood Stock Network',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tracking ${centers.length} regional blood banks & emergency reserves in real-time.',
                        style: const TextStyle(fontSize: 11, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          const Text(
            'Nearby Hospital Blood Banks:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...centers.map((center) {
            return InventoryCard(
              center: center,
              onBookSlot: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentScreen(preSelectedCenter: center.name),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
