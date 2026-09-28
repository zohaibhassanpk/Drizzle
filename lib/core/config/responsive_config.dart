import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Scales values from the reference design to the current screen size.
///
/// Place [ResponsiveProvider] inside MaterialApp's builder before using these
/// methods in widgets. The default mobile reference size is 375 x 812.
class ResponsiveConfig {
  ResponsiveConfig._();

  static late double screenWidth;
  static late double screenHeight;
  static late Orientation orientation;
  static late bool isTablet;

  static late double mobileReferenceWidth;
  static late double mobileReferenceHeight;
  static late double tabletReferenceWidth;
  static late double tabletReferenceHeight;

  static bool _initialized = false;

  static void _init(
    BuildContext context, {
    required Size mobileSize,
    required Size tabletSize,
    required bool isDebugPrint,
    bool Function(Size)? customTabletCheck,
  }) {
    final size = MediaQuery.sizeOf(context);

    screenWidth = size.width;
    screenHeight = size.height;
    orientation = MediaQuery.orientationOf(context);

    mobileReferenceWidth = mobileSize.width;
    mobileReferenceHeight = mobileSize.height;
    tabletReferenceWidth = tabletSize.width;
    tabletReferenceHeight = tabletSize.height;

    isTablet = customTabletCheck?.call(size) ?? _defaultTabletCheck(size);
    _initialized = true;

    if (isDebugPrint) {
      debugPrint('Screen: ${screenWidth}x$screenHeight; tablet: $isTablet');
    }
  }

  static bool _defaultTabletCheck(Size size) =>
      size.shortestSide >= 600 && (size.longestSide / size.shortestSide) < 1.6;

  static double height(double value) {
    _assertInitialized();
    final reference = isTablet ? tabletReferenceHeight : mobileReferenceHeight;
    return value / reference * screenHeight;
  }

  static double width(double value) {
    _assertInitialized();
    final reference = isTablet ? tabletReferenceWidth : mobileReferenceWidth;
    return value / reference * screenWidth;
  }

  /// Uses the smaller axis scale so text does not overflow on short or wide
  /// browser windows.
  static double scale(double value) {
    _assertInitialized();
    final referenceWidth = isTablet
        ? tabletReferenceWidth
        : mobileReferenceWidth;
    final referenceHeight = isTablet
        ? tabletReferenceHeight
        : mobileReferenceHeight;
    final widthScale = screenWidth / referenceWidth;
    final heightScale = screenHeight / referenceHeight;
    return value * math.min(widthScale, heightScale);
  }

  static double radius(double value) => scale(value);

  static void _assertInitialized() {
    if (!_initialized) {
      throw FlutterError(
        'ResponsiveConfig is not initialized. Add ResponsiveProvider '
        'inside MaterialApp.builder before using responsive values.',
      );
    }
  }
}

/// Updates responsive values when the available screen size changes.
class ResponsiveProvider extends StatelessWidget {
  const ResponsiveProvider({
    super.key,
    required this.child,
    this.mobileSize = const Size(375, 812),
    this.tabletSize = const Size(834, 1194),
    this.maxWebContentWidth = 480,
    this.maxWebContentHeight = 1000,
    this.webBackgroundColor = const Color(0xFFF5F8FC),
    this.isDebugPrint = false,
    this.customTabletCheck,
  });

  final Widget child;
  final Size mobileSize;
  final Size tabletSize;
  final double maxWebContentWidth;
  final double maxWebContentHeight;
  final Color webBackgroundColor;
  final bool isDebugPrint;
  final bool Function(Size)? customTabletCheck;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!kIsWeb) {
          ResponsiveConfig._init(
            context,
            mobileSize: mobileSize,
            tabletSize: tabletSize,
            isDebugPrint: isDebugPrint,
            customTabletCheck: customTabletCheck,
          );
          return child;
        }

        final contentSize = Size(
          math.min(constraints.maxWidth, maxWebContentWidth),
          math.min(constraints.maxHeight, maxWebContentHeight),
        );

        return ColoredBox(
          color: webBackgroundColor,
          child: Center(
            child: SizedBox.fromSize(
              size: contentSize,
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(size: contentSize),
                child: Builder(
                  builder: (webContext) {
                    ResponsiveConfig._init(
                      webContext,
                      mobileSize: mobileSize,
                      tabletSize: tabletSize,
                      isDebugPrint: isDebugPrint,
                      customTabletCheck: customTabletCheck,
                    );
                    return child;
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
