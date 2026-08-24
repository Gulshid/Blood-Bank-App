import 'package:blood_bank/theme/app_theme.dart';
import 'package:blood_bank/views/compatibility_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const BloodCompatibilityApp());
}

class BloodCompatibilityApp extends StatelessWidget {
  const BloodCompatibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScreenUtilInit(
          designSize: _getDesignSize(constraints.maxWidth),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, _) {
            return MaterialApp(
              title: 'Blood Compatibility Explorer',
              debugShowCheckedModeBanner: false,
              themeMode: ThemeMode.system,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeAnimationDuration: const Duration(milliseconds: 350),
              themeAnimationCurve: Curves.easeInOut,
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                  child: child!,
                );
              },
              home: const CompatibilityScreen(),
            );
          },
        );
      },
    );
  }
}

/// Picks a base design size for ScreenUtil depending on the device class,
/// so scaling stays sane on phones, tablets, and desktop/web widths alike.
Size _getDesignSize(double width) {
  if (width < 600) return const Size(360, 690);
  if (width < 1200) return const Size(834, 1194);
  return const Size(1440, 1024);
}
