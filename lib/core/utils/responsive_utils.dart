import 'package:flutter/material.dart';

/// Responsive utility class for handling different screen sizes
///
/// This class provides helper methods to create responsive designs
/// that adapt to different screen sizes (mobile, tablet, desktop).
///
/// Breakpoints:
/// - Mobile: <= 768px
/// - Tablet: 769px - 1024px
/// - Desktop: > 1024px
class ResponsiveUtils {
  ResponsiveUtils._();

  // Breakpoint constants
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;

  /// Get responsive value based on screen size
  ///
  /// Returns different values for mobile, tablet, and desktop screens.
  ///
  /// Example:
  /// ```dart
  /// final fontSize = ResponsiveUtils.getResponsiveValue<double>(
  ///   context,
  ///   mobile: 14.0,
  ///   tablet: 16.0,
  ///   desktop: 18.0,
  /// );
  /// ```
  static T getResponsiveValue<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= mobileBreakpoint) return mobile;
    if (screenWidth <= tabletBreakpoint) return tablet;
    return desktop;
  }

  /// Shorthand alias for getResponsiveValue with named parameters
  ///
  /// Example:
  /// ```dart
  /// final spacing = ResponsiveUtils.value(context, mobile: 10.0, tablet: 15.0, desktop: 20.0);
  /// ```
  static T value<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    return getResponsiveValue<T>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Alternative method with positional parameters for backward compatibility
  ///
  /// Example:
  /// ```dart
  /// final spacing = ResponsiveUtils.getValue(context, 10.0, 15.0, 20.0);
  /// ```
  @Deprecated(
    'Use getResponsiveValue() with named parameters for better clarity',
  )
  static T getValue<T>(BuildContext context, T mobile, T tablet, T desktop) {
    return getResponsiveValue<T>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width <= mobileBreakpoint;

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > mobileBreakpoint && width <= tabletBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width > tabletBreakpoint;

  /// Get screen size category as enum
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width <= mobileBreakpoint) return ScreenSize.mobile;
    if (width <= tabletBreakpoint) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
  }) {
    return getResponsiveValue<EdgeInsets>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive margin
  static EdgeInsets getResponsiveMargin(
    BuildContext context, {
    required EdgeInsets mobile,
    required EdgeInsets tablet,
    required EdgeInsets desktop,
  }) {
    return getResponsiveValue<EdgeInsets>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive text style
  static TextStyle getResponsiveTextStyle(
    BuildContext context, {
    required TextStyle mobile,
    required TextStyle tablet,
    required TextStyle desktop,
  }) {
    return getResponsiveValue<TextStyle>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive font size
  static double getResponsiveFontSize(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    return getResponsiveValue<double>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Get responsive width percentage
  static double getResponsiveWidth(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final percentage = getResponsiveValue<double>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return screenWidth * (percentage / 100);
  }

  /// Get responsive height percentage
  static double getResponsiveHeight(
    BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    final percentage = getResponsiveValue<double>(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    return screenHeight * (percentage / 100);
  }
}

/// Enum for screen size categories
enum ScreenSize { mobile, tablet, desktop }

/// Extension on BuildContext for easy access to responsive utilities
extension ResponsiveContext on BuildContext {
  /// Get responsive value using context extension
  T responsive<T>({required T mobile, required T tablet, required T desktop}) {
    return ResponsiveUtils.getResponsiveValue<T>(
      this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  /// Check if current screen is mobile
  bool get isMobile => ResponsiveUtils.isMobile(this);

  /// Check if current screen is tablet
  bool get isTablet => ResponsiveUtils.isTablet(this);

  /// Check if current screen is desktop
  bool get isDesktop => ResponsiveUtils.isDesktop(this);

  /// Get current screen size category
  ScreenSize get screenSize => ResponsiveUtils.getScreenSize(this);
}
