import 'package:flutter/material.dart';

/// Pushes [page] with a subtle slide-up + fade transition instead of the
/// platform default, giving screen navigation a more polished feel.
Route<T> slideFadeRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 260),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Convenience wrapper: Navigator.push with [slideFadeRoute].
Future<T?> pushSlideFade<T>(BuildContext context, Widget page) {
  return Navigator.push<T>(context, slideFadeRoute<T>(page));
}
