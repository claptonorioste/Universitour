import 'package:flutter/material.dart';

class DrawLocation extends CustomPainter {
  
  final Offset offset;


  
  Paint _paint;

  DrawLocation(this.offset) {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(this.offset, 2.0, _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}