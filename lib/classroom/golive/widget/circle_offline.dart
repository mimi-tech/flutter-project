/*
import 'package:flutter/material.dart';
import 'package:sparks/colors/colors.dart';

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    // set the color property of the paint
    paint.color = kOfflineColor;
    // center of the canvas is (x,y) => (width/2, height/2)
    var center = Offset(size.width / 2, size.height / 2);

    // draw the circle on centre of canvas having radius 75.0
    canvas.drawCircle(Offset(0.0, 0.0), 6.0, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}*/


import 'package:flutter/material.dart';
import 'package:sparks/app_entry_and_home/colors/colour.dart';

class OffLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,

        color: kOfflineColor,
      ),
      height:6,
      width: 6,


    );
  }
}
