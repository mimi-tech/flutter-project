import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class DrawCircle extends CustomPainter {
  late Paint _paint;

  DrawCircle() {
    _paint = Paint()
      ..color = kOnlineColor
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(0.0, 0.0), 2.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

