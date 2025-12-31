// Copyright (C) 2025 Fiber
//
// All rights reserved. This script, including its code and logic, is the
// exclusive property of Fiber. Redistribution, reproduction,
// or modification of any part of this script is strictly prohibited
// without prior written permission from Fiber.
//
// Conditions of use:
// - The code may not be copied, duplicated, or used, in whole or in part,
//   for any purpose without explicit authorization.
// - Redistribution of this code, with or without modification, is not
//   permitted unless expressly agreed upon by Fiber.
// - The name "Fiber" and any associated branding, logos, or
//   trademarks may not be used to endorse or promote derived products
//   or services without prior written approval.
//
// Disclaimer:
// THIS SCRIPT AND ITS CODE ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL
// FIBER BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF USE,
// DATA, PROFITS, OR BUSINESS INTERRUPTION) ARISING OUT OF OR RELATED TO THE USE
// OR INABILITY TO USE THIS SCRIPT, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Unauthorized copying or reproduction of this script, in whole or in part,
// is a violation of applicable intellectual property laws and will result
// in legal action.

import 'dart:async';

import 'package:flutter/material.dart';

typedef ControllerCallback = void Function(AnimationController);

enum DismissType { onTap, onSwipe, none }

extension ExtensionBuildContextAlert on BuildContext {
  bool error(String message) {
    showTopSnackBar(_CustomSnackBar.error(message), context: this);
    return false;
  }

  bool success(String message) {
    showTopSnackBar(_CustomSnackBar.success(message), context: this);
    return true;
  }

  bool info(String message) {
    showTopSnackBar(_CustomSnackBar.info(message), context: this);
    return true;
  }
}

OverlayEntry? _previousEntry;

Future<void> showTopSnackBar(
  Widget child, {
  required BuildContext context,
  Duration animationDuration = const Duration(milliseconds: 150),
  Duration reverseAnimationDuration = const Duration(milliseconds: 550),
  Duration displayDuration = const Duration(milliseconds: 3000),
  VoidCallback? onTap,
  OverlayState? overlayState,
  bool persistent = false,
  ControllerCallback? onAnimationControllerInit,
  EdgeInsets padding = const EdgeInsets.all(0),
  Curve curve = Curves.linear,
  Curve reverseCurve = Curves.linearToEaseOut,
  SafeAreaValuesComponent safeAreaValues = const SafeAreaValuesComponent(),
  DismissType dismissType = DismissType.onTap,
  DismissDirection dismissDirection = DismissDirection.up,
}) async {
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) {
      return _TopSnackBarComponent(
        onDismissed: () {
          if (overlayEntry.mounted && _previousEntry == overlayEntry) {
            overlayEntry.remove();
            _previousEntry = null;
          }
        },
        animationDuration: animationDuration,
        reverseAnimationDuration: reverseAnimationDuration,
        displayDuration: displayDuration,
        onTap: onTap,
        persistent: persistent,
        onAnimationControllerInit: onAnimationControllerInit,
        padding: padding,
        curve: curve,
        reverseCurve: reverseCurve,
        safeAreaValues: safeAreaValues,
        dismissType: dismissType,
        dismissDirection: dismissDirection,
        child: child,
      );
    },
  );

  if (_previousEntry != null && _previousEntry!.mounted) {
    _previousEntry?.remove();
  }

  (overlayState ?? Overlay.of(context)).insert(overlayEntry);
  _previousEntry = overlayEntry;
}

class _TopSnackBarComponent extends StatefulWidget {
  final Widget child;
  final VoidCallback onDismissed;
  final Duration animationDuration;
  final Duration reverseAnimationDuration;
  final Duration displayDuration;
  final VoidCallback? onTap;
  final ControllerCallback? onAnimationControllerInit;
  final bool persistent;
  final EdgeInsets padding;
  final Curve curve;
  final Curve reverseCurve;
  final SafeAreaValuesComponent safeAreaValues;
  final DismissType dismissType;
  final DismissDirection dismissDirection;

  const _TopSnackBarComponent({
    required this.child,
    required this.onDismissed,
    required this.animationDuration,
    required this.reverseAnimationDuration,
    required this.displayDuration,
    this.onTap,
    this.persistent = false,
    this.onAnimationControllerInit,
    required this.padding,
    required this.curve,
    required this.reverseCurve,
    required this.safeAreaValues,
    this.dismissType = DismissType.onTap,
    this.dismissDirection = DismissDirection.up,
  });

  @override
  State<_TopSnackBarComponent> createState() => __TopSnackBarComponentState();
}

class __TopSnackBarComponentState extends State<_TopSnackBarComponent> with SingleTickerProviderStateMixin {
  late Animation offsetAnimation;
  late AnimationController animationController;
  StreamSubscription? _changeStateStream;

  @override
  void initState() {
    super.initState();
    _setupAndStartAnimation();
  }

  @override
  void dispose() {
    _changeStateStream?.cancel();
    animationController.dispose();
    super.dispose();
  }

  void _setupAndStartAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      reverseDuration: widget.reverseAnimationDuration,
    );

    widget.onAnimationControllerInit?.call(animationController);

    Tween<Offset> offsetTween = Tween<Offset>(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0));

    offsetAnimation =
        offsetTween.animate(
          CurvedAnimation(parent: animationController, curve: widget.curve, reverseCurve: widget.reverseCurve),
        )..addStatusListener((status) async {
          if (status == AnimationStatus.completed) {
            await Future.delayed(widget.displayDuration);
            _dismiss();
          }

          if (status == AnimationStatus.dismissed) {
            if (mounted) {
              widget.onDismissed.call();
            }
          }
        });

    if (mounted) {
      animationController.forward();
    }
  }

  void _dismiss() {
    if (!widget.persistent && mounted) {
      animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.padding.top,
      left: widget.padding.left,
      right: widget.padding.right,
      child: SlideTransition(position: offsetAnimation as Animation<Offset>, child: _buildDismissibleChild()),
    );
  }

  Widget _buildDismissibleChild() {
    switch (widget.dismissType) {
      case DismissType.onTap:
        return _TapBounceContainerComponent(
          onTap: () {
            if (mounted) {
              widget.onTap?.call();
              _dismiss();
            }
          },
          child: widget.child,
        );
      case DismissType.onSwipe:
        return Dismissible(
          direction: widget.dismissDirection,
          key: UniqueKey(),
          onDismissed: (direction) => _dismiss(),
          child: widget.child,
        );
      case DismissType.none:
        return widget.child;
    }
  }
}

class _CustomSnackBar extends StatelessWidget {
  final String message;
  final Color backgroundColor;

  const _CustomSnackBar({required this.message, required this.backgroundColor});

  factory _CustomSnackBar.success(String message) {
    return _CustomSnackBar(backgroundColor: Colors.green, message: message);
  }

  factory _CustomSnackBar.error(String message) {
    return _CustomSnackBar(backgroundColor: Colors.red, message: message);
  }

  factory _CustomSnackBar.info(String message) {
    return _CustomSnackBar(backgroundColor: Colors.blue, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(color: backgroundColor, borderRadius: const BorderRadius.all(Radius.circular(0))),
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5, bottom: 5, left: 20, right: 20),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class _TapBounceContainerComponent extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TapBounceContainerComponent({required this.child, this.onTap});

  @override
  State<_TapBounceContainerComponent> createState() => __TapBounceContainerComponentState();
}

class __TapBounceContainerComponentState extends State<_TapBounceContainerComponent>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  final Duration animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: animationDuration, lowerBound: 0.0, upperBound: 0.04)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onPanEnd: _onPanEnd,
      child: Transform.scale(scale: _scale, child: widget.child),
    );
  }

  void _onTapDown(TapDownDetails details) {
    if (mounted) {
      _controller.forward();
    }
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    await _closeSnackBar();
  }

  Future<void> _onPanEnd(DragEndDetails details) async {
    await _closeSnackBar();
  }

  Future<void> _closeSnackBar() async {
    if (mounted) {
      _controller.reverse();
      await Future.delayed(animationDuration);
      widget.onTap?.call();
    }
  }
}

class _SlideFadeTransitionComponent extends StatefulWidget {
  final Widget child;

  const _SlideFadeTransitionComponent({required this.child});

  @override
  State<_SlideFadeTransitionComponent> createState() => __SlideFadeTransitionComponentState();
}

class __SlideFadeTransitionComponentState extends State<_SlideFadeTransitionComponent>
    with SingleTickerProviderStateMixin {
  Animation<Offset>? _animationSlide;
  AnimationController? _animationController;
  Animation<double>? _animationFade;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1000));

    _animationSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(curve: Curves.easeIn, parent: _animationController!));

    _animationFade = Tween<double>(
      begin: -1.0,
      end: 1.0,
    ).animate(CurvedAnimation(curve: Curves.easeIn, parent: _animationController!));

    Timer(Duration.zero, () {
      _animationController!.forward();
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade!,
      child: SlideTransition(position: _animationSlide!, child: widget.child),
    );
  }
}

class SafeAreaValuesComponent {
  final bool left;
  final bool top;
  final bool right;
  final bool bottom;
  final EdgeInsets minimum;
  final bool maintainBottomViewPadding;

  const SafeAreaValuesComponent({
    this.left = true,
    this.top = true,
    this.right = true,
    this.bottom = true,
    this.minimum = EdgeInsets.zero,
    this.maintainBottomViewPadding = false,
  });
}
