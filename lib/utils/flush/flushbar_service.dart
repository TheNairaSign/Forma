import 'package:flutter/material.dart';
import 'dart:async';
import 'custom_flushbar_widget.dart'; // Import the widget we just defined

enum FlushbarPosition { top, bottom }

class FlushbarService {
  static OverlayEntry? _overlayEntry;
  static Timer? _timer;
  static AnimationController? _animationController;
  static Animation<Offset>? _slideAnimation;

  // Private constructor to prevent instantiation
  FlushbarService._();

  static bool get isVisible => _overlayEntry != null;

  static void show(BuildContext context, {
    required String message,
    IconData? icon,
    Color backgroundColor = const Color(0xff2b2d30),
    Color textColor = Colors.white,
    Duration duration = const Duration(seconds: 3),
    double height = 20, // Make height required for clarity
    FlushbarPosition position = FlushbarPosition.top,
    EdgeInsets margin = EdgeInsets.zero, // Customizable margin
    VoidCallback? onTap, // Action when the flushbar is tapped
  }) {
    // Ensure we have a valid TickerProvider. The OverlayState itself is a TickerProvider.
    final overlayState = Navigator.of(context).overlay;
    if (overlayState == null) {
      debugPrint("FlushbarService Error: OverlayState is null. Ensure context is valid.");
      return;
    }

    if (isVisible) {
      // If a flushbar is already visible, dismiss it first.
      // Consider if you want to queue or stack them in more complex scenarios.
      dismiss(immediately: true);
    }

    _animationController = AnimationController(
      vsync: overlayState, // Use OverlayState as TickerProvider
      duration: const Duration(milliseconds: 350), // Animation duration
    );

    final beginOffset = position == FlushbarPosition.top
        ? const Offset(0.0, -1.0) // Start above the screen
        : const Offset(0.0, 1.0); // Start below the screen

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    ));

    _overlayEntry = OverlayEntry(
      builder: (context) {
        // Calculate the top or bottom position including safe area and margin
        double topPosition = (position == FlushbarPosition.top)
            ? MediaQuery
            .of(context)
            .padding
            .top + margin.top
            : double
            .nan; // double.nan effectively means 'not set' for Positioned
        double bottomPosition = (position == FlushbarPosition.bottom)
            ? MediaQuery
            .of(context)
            .padding
            .bottom + margin.bottom
            : double.nan;

        return Positioned(
          top: topPosition.isNaN ? null : topPosition,
          bottom: bottomPosition.isNaN ? null : bottomPosition,
          left: margin.left,
          right: margin.right,
          child: SlideTransition(
            position: _slideAnimation!,
            child: GestureDetector(
              onTap: onTap, // Allow tapping the flushbar
              child: CustomFlushbarWidget(
                message: message,
                icon: icon,
                backgroundColor: backgroundColor,
                textColor: textColor,
                height: height,
                onDismissed: () => dismiss(), // If you have a close button in CustomFlushbarWidget
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(_overlayEntry!);
    _animationController!.forward();

    _timer?.cancel();
    if (duration > Duration.zero) { // Only set timer if duration is positive
      _timer = Timer(duration, () {
        dismiss();
      });
    }
  }

  static Future<void> dismiss({bool immediately = false}) async {
    if (!isVisible) return;

    _timer?.cancel();
    _timer = null;

    if (immediately || _animationController == null ||
        !_animationController!.isAnimating) {
      if (_animationController?.status == AnimationStatus.forward ||
          _animationController?.status == AnimationStatus.completed) {
        // If it was appearing or fully appeared, animate out if not immediate
        if (!immediately && _animationController != null) {
          await _animationController!.reverse();
        }
      }
      _overlayEntry?.remove();
      _overlayEntry = null;
      _animationController?.dispose();
      _animationController = null;
    } else if (_animationController!.isAnimating) {
      // If animating (e.g., still entering), wait for it to complete then reverse
      _animationController!.forward().then((
          _) async { // Ensure it's fully on screen
        if (!immediately) await _animationController?.reverse(); // Then reverse
        _overlayEntry?.remove();
        _overlayEntry = null;
        _animationController?.dispose();
        _animationController = null;
      });
    }
  }
}