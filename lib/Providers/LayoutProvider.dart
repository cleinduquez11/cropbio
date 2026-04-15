import 'package:flutter/material.dart';

class LayoutProvider extends ChangeNotifier {
  double _width = 0;
  double _height = 0;
  

  /// Breakpoints
  bool get isMobile => _width < 600;
  bool get isTablet => _width >= 600 && _width < 1024;
  bool get isDesktop => _width >= 1024 && _width < 1600;
  bool get isLargeDesktop => _width >= 1600;

  double get screenWidth => _width;
  double get screenHeight => _height;

  /// Dynamic content width
double get contentWidth {
  if (isMobile) return double.infinity;

  if (isTablet) return 720;

  if (isDesktop) return 1100;

  if (isLargeDesktop) return 1280;

  return 1280;
}
  /// Dynamic content height
  double get contentHeight {
    if (isLargeDesktop) return _height * 0.9;
    if (isDesktop) return 1250;
    return double.infinity;
  }

  /// Margins
double get outerMargin {
  if (isMobile) return 8;
  if (isTablet) return 12;
  if (isDesktop) return 14;
  if (isLargeDesktop) return 20;

  return 20;
}
  /// Padding
  double get horizontalPadding {
    if (isMobile) return 12;
    if (isTablet) return 20;
    if (isDesktop) return 22;
    return 20;
  }


  /// ===============================
  /// LOGO SIZING
  /// ===============================

  double get logoWidth {
    if (isMobile) return 140;
    if (isTablet) return 180;
    if (isDesktop) return 220;
    return 260;
  }

  double get logoHeight {
    if (isMobile) return 80;
    if (isTablet) return 100;
    if (isDesktop) return 140;
    return 160;
  }

  /// ===============================
  /// ICON SIZING
  /// ===============================

  double get iconSize {
    if (isMobile) return 20;
    if (isTablet) return 22;
    if (isDesktop) return 24;
    return 26;
  }

  double get buttonIconSize {
    if (isMobile) return 20;
    if (isTablet) return 22;
    if (isDesktop) return 24;
    return 26;
  }

  /// ===============================
  /// FONT SIZING
  /// ===============================

  double get titleFontSize {
    if (isMobile) return 18;
    if (isTablet) return 20;
    if (isDesktop) return 22;
    return 24;
  }

  double get bodyFontSize {
    if (isMobile) return 14;
    if (isTablet) return 15;
    if (isDesktop) return 16;
    return 17;
  }

  double get smallFontSize {
    if (isMobile) return 12;
    if (isTablet) return 13;
    if (isDesktop) return 14;
    return 15;
  }

  /// ===============================
  /// APP BAR HEIGHT
  /// ===============================

  double get appBarHeight {
    if (isMobile) return 60;
    if (isTablet) return 70;
    if (isDesktop) return 90;
    return 100;
  }


  double get verticalPadding {
    if (isMobile) return 12;
    return 50;
  }

  /// Update layout values
  void update(BoxConstraints constraints, BuildContext context) {
    _width = constraints.maxWidth;
    _height = MediaQuery.of(context).size.height;
    notifyListeners();
  }
}
