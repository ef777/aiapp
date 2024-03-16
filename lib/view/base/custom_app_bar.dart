import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class CustomToolbarShape extends CustomPainter {
  final circleWidth;
  final showBar;
  CustomToolbarShape({this.circleWidth, this.showBar: false});

  @override
  void paint(Canvas canvas, Size size) {
    //1
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height);

    final colors = [Color(0xfffed000), Color(0xfffec000), Color(0xfffea000)];
    //2
    final stops = [0.0, 0.4, 1.0];
    //3
    final gradient = LinearGradient(colors: colors, stops: stops);

    //1
    final curvedShapeBounds = Rect.fromLTRB(
      shapeBounds.left,
      shapeBounds.top,
      shapeBounds.right,
      shapeBounds.bottom,
    );

    //1
    final paint = Paint()..shader = gradient.createShader(curvedShapeBounds);
    //2

    //3
    canvas.drawRect(shapeBounds, paint);

    //2
    _drawCurvedShape(canvas, curvedShapeBounds);
  }

  void _drawCurvedShape(Canvas canvas, Rect bounds) {
    //1

    final paint = Paint()..color = Color(0xffffa600);

    //2
    final handlePoint = Offset(bounds.left + (bounds.width * 0.25), bounds.top);

    //3
    final curvePath = Path()
      ..moveTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy) //4
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy) //6
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy) //7
      ..quadraticBezierTo(
        handlePoint.dx,
        handlePoint.dy,
        bounds.topLeft.dx,
        bounds.topLeft.dy,
      ) //8
      ..close(); //9

    //10
    canvas.drawPath(curvePath, paint);
  }

  @override
  bool shouldRepaint(CustomToolbarShape oldDelegate) => false;
  @override
  bool shouldRebuildSemantics(CustomToolbarShape oldDelegate) => false;
}
