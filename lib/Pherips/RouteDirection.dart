import 'package:flutter/material.dart';

enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
}

class RouteTransitionHelper {

  static SlideDirection getDirectionFromPosition(
    Offset position,
    Size screenSize,
  ) {

    final dx = position.dx;
    final dy = position.dy;

    final horizontalCenter =
        screenSize.width / 2;

    final verticalCenter =
        screenSize.height / 2;

    final horizontalDistance =
        (dx - horizontalCenter).abs();

    final verticalDistance =
        (dy - verticalCenter).abs();

    /// Decide dominant direction
    if (horizontalDistance >
        verticalDistance) {

      if (dx < horizontalCenter) {
        return SlideDirection.fromLeft;
      } else {
        return SlideDirection.fromRight;
      }

    } else {

      if (dy < verticalCenter) {
        return SlideDirection.fromTop;
      } else {
        return SlideDirection.fromBottom;
      }
    }
  }
}