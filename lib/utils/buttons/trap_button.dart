import 'package:flutter/material.dart';

class TrapeziumBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => const EdgeInsets.all(0.0);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..moveTo(rect.width * 0.25, 0) // Top left (25% from left)
      ..lineTo(rect.width * 0.75, 0) // Top right (25% from right)
      ..lineTo(rect.width, rect.height) // Bottom right
      ..lineTo(0, rect.height) // Bottom left
      ..close();
  }

  @override
  ShapeBorder scale(double t) => this;

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder copyWith({BorderSide? side}) {
    return this; // Corrected to return the current instance of ShapeBorder
  }

  @override
  Path getClipPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getInnerPath(rect, textDirection: textDirection);
  }
}
