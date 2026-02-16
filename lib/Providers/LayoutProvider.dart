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
    if (isLargeDesktop) return _width * 0.50;
    if (isDesktop) return 1250;
    return double.infinity;
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
    return 8;
  }

  /// Padding
  double get horizontalPadding {
    if (isMobile) return 12;
    if (isTablet) return 20;
    if (isDesktop) return 22;
    return 20;
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
