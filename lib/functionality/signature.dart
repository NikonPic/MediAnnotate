import 'package:flutter/material.dart';

class Signature extends CustomPainter {
  final List<Offset?>? points;
  final Color color;
  final double? strokeWidth;

  Signature({
    this.strokeWidth,
    this.points,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth!;

    for (int i = 0; i < points!.length - 1; i++) {
      if (points![i] != null && points![i + 1] != null) {
        canvas.drawLine(points![i]!, points![i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}
