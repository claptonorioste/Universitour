import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DrawLine extends CustomPainter {
  

  final List<Offset> points;
  

  final pointMode = ui.PointMode.polygon;
  
  Paint _paint;

  DrawLine(this.points) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
     canvas.drawPoints(pointMode,points, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}