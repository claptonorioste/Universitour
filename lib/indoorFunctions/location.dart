import 'package:flutter/material.dart';

class DrawLocation extends CustomPainter {
  
  final Offset offset;

  final Color colr;

  
  Paint _paint;

  DrawLocation(this.offset,this.colr) {
    _paint = Paint()
      ..color = colr
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(this.offset, 10.0, _paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}