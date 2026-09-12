import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Pencil marginalia meant to be stacked over [PageText]. The parent owns
/// whether it is gone; this widget only reports the wipe gesture.
class MarginNote extends StatelessWidget {
  const MarginNote({
    super.key,
    required this.text,
    this.onWiped,
    this.rotation = -0.045,
    this.label = 'Margin note',
  });

  final String text;
  final VoidCallback? onWiped;
  final double rotation;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
        label: label,
        hint: 'Drag across the note to wipe it away',
        child: GestureDetector(
          onPanUpdate: onWiped == null ? null : (_) => onWiped!(),
          onTap: onWiped,
          child: Transform.rotate(
            angle: rotation,
            child: CustomPaint(
              painter: _MarginScribblePainter(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                child: Text(
                  text,
                  style: GoogleFonts.baloo2(
                    color: PrimerTheme.pencil,
                    fontSize: 18,
                    height: 1.2,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}

class _MarginScribblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = const Color(0xFFB8B4AC)
      ..strokeWidth = 0.8;
    final top = Path()
      ..moveTo(2, 4)
      ..quadraticBezierTo(size.width * .3, 0, size.width * .55, 4)
      ..quadraticBezierTo(size.width * .8, 7, size.width - 2, 3);
    final bottom = Path()
      ..moveTo(4, size.height - 4)
      ..quadraticBezierTo(size.width * .35, size.height - 1, size.width * .6, size.height - 5)
      ..quadraticBezierTo(size.width * .82, size.height - 8, size.width - 2, size.height - 3);
    canvas.drawPath(top, line);
    canvas.drawPath(bottom, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
