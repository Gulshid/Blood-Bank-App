import 'package:flutter/material.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final currentIndex = provider.currentTabIndex;
    final activeCount = provider.activeRequests.length;

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateRequestScreen()),
          );
        },
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: provider.setTabIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).colorScheme.surface,
          selectedItemColor: AppTheme.primaryCrimson,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: Badge(
                label: Text('$activeCount'),
                isLabelVisible: activeCount > 0,
                backgroundColor: AppTheme.statusCritical,
                child: const Icon(Icons.dashboard_rounded),
              ),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Donors',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_rounded),
              label: 'Stock',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_rounded),
              label: 'Book',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.badge_rounded),
              label: 'My Pass',
            ),
          ],
        ),
      ),
    );
  }
}
