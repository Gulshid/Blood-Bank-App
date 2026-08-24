import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';
import 'compatibility_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _dropScale;
  late final Animation<double> _dropOpacity;
  late final Animation<double> _ringScale;
  late final Animation<double> _ringOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _dropScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.4, end: 1.15)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 25),
    ]).animate(_controller);

    _dropOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25, curve: Curves.easeOut),
    );

    _ringScale = Tween<double>(begin: 0.6, end: 1.6).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOut),
      ),
    );

    _ringOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.5), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.5, end: 0.0), weight: 80),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.05, 0.55, curve: Curves.easeOut),
      ),
    );

    _titleOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOut),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
    ));

    _taglineOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 0.85, curve: Curves.easeOut),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, animation, __) => FadeTransition(
            opacity: animation,
            child: const CompatibilityScreen(),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 140.w,
                  height: 140.w,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Expanding pulse ring
                      Opacity(
                        opacity: _ringOpacity.value,
                        child: Transform.scale(
                          scale: _ringScale.value,
                          child: Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppTheme.primaryCrimsonLight,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Blood drop mark
                      Opacity(
                        opacity: _dropOpacity.value,
                        child: Transform.scale(
                          scale: _dropScale.value,
                          child: Container(
                            width: 88.w,
                            height: 88.w,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppTheme.primaryGradient,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x66D32F2F),
                                  blurRadius: 30,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.water_drop_rounded,
                              color: Colors.white,
                              size: 44.w,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 28.h),
                Opacity(
                  opacity: _titleOpacity.value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      _titleSlide.value.dy * 20,
                    ),
                    child: Text(
                      'Blood Compatibility',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Opacity(
                  opacity: _taglineOpacity.value,
                  child: Text(
                    'Know your type. Know the match.',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white54,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
