import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme.dart';

/// Pencil marginalia meant to be stacked over [PageText]. The parent owns
/// whether it is gone; this widget only reports the wipe gesture.
class MarginNote extends StatelessWidget {
  const MarginNote({
    super.key,
    required this.text,
    this.underText,
    this.revealed = false,
    this.onWiped,
    this.rotation = -0.045,
    this.label = 'Margin note',
  });

  final String text;
  final String? underText;
  final bool revealed;
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
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.centerLeft,
            children: [
              if (underText != null)
                AnimatedOpacity(
                  opacity: revealed ? 0 : 1,
                  duration: const Duration(milliseconds: 360),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    child: Text(
                      underText!,
                      style: PrimerTheme.story.copyWith(color: PrimerTheme.berry),
                    ),
                  ),
                ),
              IgnorePointer(
                ignoring: revealed,
                child: AnimatedSlide(
                  offset: revealed ? const Offset(.42, -.34) : Offset.zero,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: revealed ? 0 : 1,
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOut,
                    child: Transform.rotate(
                      angle: rotation,
                      child: CustomPaint(
                        painter: _PaperNotePainter(),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
                          child: Text(
                            text,
                            style: GoogleFonts.caveat(
                              color: PrimerTheme.pencil,
                              fontSize: 28,
                              height: .86,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _PaperNotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paper = Paint()..color = const Color(0xFFF1E5C9);
    final edge = Paint()
      ..color = const Color(0xFFC9B990)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    final shape = Path()
      ..moveTo(4, 6)
      ..quadraticBezierTo(size.width * .28, 1, size.width * .54, 5)
      ..quadraticBezierTo(size.width * .8, 1, size.width - 4, 7)
      ..quadraticBezierTo(size.width - 1, size.height * .45, size.width - 5, size.height - 6)
      ..quadraticBezierTo(size.width * .68, size.height + 1, size.width * .38, size.height - 4)
      ..quadraticBezierTo(size.width * .14, size.height + 1, 4, size.height - 7)
      ..quadraticBezierTo(1, size.height * .48, 4, 6)
      ..close();
    canvas.drawPath(shape, paper);
    canvas.drawPath(shape, edge);

    final fold = Path()
      ..moveTo(size.width - 19, 5)
      ..lineTo(size.width - 5, 7)
      ..lineTo(size.width - 7, 20)
      ..close();
    canvas.drawPath(fold, Paint()..color = const Color(0xFFE2D2AD));
    canvas.drawPath(fold, edge);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
