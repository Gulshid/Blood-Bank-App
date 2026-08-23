import 'package:blood_bank/providers/app_provider.dart';
import 'package:blood_bank/theme/app_theme.dart';
import 'package:blood_bank/views/main_navigation_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LifePulseApp());
}

class LifePulseApp extends StatelessWidget {
  const LifePulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviderWidget(
      child: Builder(
        builder: (context) {
          final provider = AppProvider.of(context);
          return MaterialApp(
            title: 'LifePulse - Blood Bank & Donor Network',
            debugShowCheckedModeBanner: false,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeAnimationDuration: const Duration(milliseconds: 350),
            themeAnimationCurve: Curves.easeInOut,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}
