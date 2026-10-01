import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// Grumble himself: a small grey pencil sketch in the margin, arms crossed.
/// Drawn, never voiced (PLAN.md §5). He gets a face so she meets a
/// character, not just a note that turned up from nowhere.
class GrumbleSketch extends StatelessWidget {
  const GrumbleSketch({super.key, required this.name, this.size = 104});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
        image: true,
        label: 'A grey pencil drawing of $name, arms crossed, frowning',
        child: CustomPaint(size: Size(size, size * 1.15), painter: _GrumblePainter()),
      );
}

class _GrumblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 115);

    final body = Path();
    // A lumpy round body: an ellipse nudged by a fixed wobble, so he looks
    // hand-drawn and looks the same every time.
    const steps = 28;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps * 2 * math.pi;
      final wobble = 1 + .05 * math.sin(t * 5) + .03 * math.cos(t * 3);
      final p = Offset(50 + 33 * wobble * math.cos(t), 62 + 37 * wobble * math.sin(t));
      i == 0 ? body.moveTo(p.dx, p.dy) : body.lineTo(p.dx, p.dy);
    }

    final face = Path()
      // Brows pulled down towards the middle.
      ..moveTo(30, 43)
      ..lineTo(44, 48)
      ..moveTo(70, 43)
      ..lineTo(56, 48)
      // A frown.
      ..moveTo(39, 75)
      ..quadraticBezierTo(50, 66, 61, 75)
      // Arms crossed over his middle.
      ..moveTo(22, 78)
      ..lineTo(68, 91)
      ..moveTo(78, 78)
      ..lineTo(32, 91)
      // Legs and feet.
      ..moveTo(41, 98)
      ..lineTo(38, 110)
      ..lineTo(31, 111)
      ..moveTo(59, 98)
      ..lineTo(62, 110)
      ..lineTo(69, 111)
      // Scribbled hair.
      ..moveTo(36, 28)
      ..lineTo(41, 18)
      ..lineTo(47, 27)
      ..lineTo(53, 16)
      ..lineTo(59, 27)
      ..lineTo(64, 20);

    // Every line twice, a hair apart, the way a pencil goes back over itself.
    for (final (shift, alpha) in const [(Offset.zero, 1.0), (Offset(.9, .6), .45)]) {
      final pencil = Paint()
        ..color = PrimerTheme.pencil.withValues(alpha: alpha)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.save();
      canvas.translate(shift.dx, shift.dy);
      canvas.drawPath(body, pencil);
      canvas.drawPath(face, pencil);
      canvas.restore();
    }

    final eye = Paint()..color = PrimerTheme.pencil;
    canvas.drawCircle(const Offset(39, 55), 3, eye);
    canvas.drawCircle(const Offset(61, 55), 3, eye);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
