import 'package:flutter/material.dart';
import 'dart:math';

class WavyDivider extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final double wavelength;

  const WavyDivider({super.key,
    this.width = 1.0,
    this.height = 20.0,
    this.color = Colors.black,
    this.wavelength = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _WavyLinePainter(width, color, wavelength),
      ),
    );
  }
}

class _WavyLinePainter extends CustomPainter {
  final double width;
  final Color color;
  final double wavelength;

  _WavyLinePainter(this.width, this.color, this.wavelength);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    final path = Path();
    final amplitude = size.height / 2;

    path.moveTo(-1, size.height/2);
    path.lineTo(0, size.height/2);
    for (double x = 1; x < size.width; x++) {
      path.lineTo(x, amplitude * sin(2 * pi * x / wavelength) + (size.height/2));
    }
    path.lineTo(size.width+1, size.height/2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}