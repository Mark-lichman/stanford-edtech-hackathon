/// The lantern, lighting and going out.
///
/// Ported straight from the two standalone elements in `animations/` —
/// `lantern-glow-on.html` and `lantern-fade-off.html` — same paths, same
/// palette, same keyframe stops. It comes up slow because a book that means to
/// stay has to arrive gently, and it goes out fast because the ending is a
/// decision, not a decay.
library;

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

enum LanternPhase { lit, out }

class Lantern extends StatelessWidget {
  const Lantern({
    super.key,
    required this.phase,
    this.height = 76,
    this.onDark = false,
    this.onEnd,
  });

  final LanternPhase phase;
  final double height;

  /// On a night panel the ink frame — handle, lid, outline, base — is the same
  /// dark brown as the background and vanishes. This draws it in a pale warm
  /// line instead, so the whole lantern still reads.
  final bool onDark;

  /// Called once the animation has finished, so a screen can hold its content
  /// back until the lantern is lit.
  final VoidCallback? onEnd;

  @override
  Widget build(BuildContext context) {
    final lit = phase == LanternPhase.lit;

    // The CSS honours prefers-reduced-motion by holding the end state. Same
    // here: no travel, just the result.
    final still = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: lit ? 'A small lantern, lit.' : 'The same lantern, going out.',
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: still
            ? Duration.zero
            : Duration(milliseconds: lit ? 4200 : 820),
        curve: lit ? const Cubic(.33, .8, .4, 1) : Curves.easeIn,
        onEnd: still ? null : onEnd,
        builder: (context, t, child) => CustomPaint(
          painter: _LanternPainter(lit: lit, t: t, onDark: onDark),
          size: Size(height * 66 / 82, height),
        ),
      ),
    );
  }
}

class _LanternPainter extends CustomPainter {
  _LanternPainter({required this.lit, required this.t, required this.onDark});

  final bool lit;
  final double t;
  final bool onDark;

  static const _ink = Color(0xFF3A2E1F);
  static const _inkSoft = Color(0xFF7A6748);
  static const _parch = Color(0xFFF5E9CF);
  static const _marigold = Color(0xFFE09612);
  static const _nightLine = Color(0xFFD9C295);

  /// A three-stop keyframe: a → b by [split], then b → c. The CSS uses one of
  /// these for every animated property, so one helper covers all of them.
  static double _stops(double t, double a, double b, double c, double split) =>
      t < split
          ? lerpDouble(a, b, t / split)!
          : lerpDouble(b, c, (t - split) / (1 - split))!;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 66, size.height / 82); // the SVG viewBox

    final frame = onDark ? _nightLine : _ink;

    final stroke = Paint()
      ..color = frame
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(26, 8), const Offset(40, 8), stroke);
    canvas.drawLine(const Offset(33, 8), const Offset(33, 17), stroke);

    final solid = Paint()..color = frame;
    canvas.drawRRect(
      RRect.fromLTRBR(14, 17, 52, 26, const Radius.circular(3)),
      solid,
    );

    final body = Path()
      ..moveTo(17, 26)
      ..lineTo(49, 26)
      ..lineTo(53, 66)
      ..arcToPoint(const Offset(49, 70), radius: const Radius.circular(4))
      ..lineTo(17, 70)
      ..arcToPoint(const Offset(13, 66), radius: const Radius.circular(4))
      ..close();
    canvas.drawPath(body, Paint()..color = _parch);
    canvas.drawPath(body, stroke);

    // Two animations of different lengths in the CSS; one timeline here, with
    // the shorter of the pair finishing early. The ratios are the CSS's even
    // though the whole thing runs slower.
    final flameT = (lit ? t * 3200 / 2800 : t).clamp(0.0, 1.0);
    final glowT = (lit ? t : t * 520 / 460).clamp(0.0, 1.0);

    final glowOpacity = lit
        ? lerpDouble(0, .4, glowT)!
        : _stops(glowT, .4, .62, 0, .22);
    final glowScale =
        lit ? lerpDouble(.4, 1, glowT)! : _stops(glowT, 1, 1.15, .3, .22);

    if (glowOpacity > 0.001) {
      canvas.save();
      canvas.translate(33, 63); // transform-origin: 50% 100% of the circle
      canvas.scale(glowScale);
      canvas.translate(-33, -63);
      canvas.drawCircle(
        const Offset(33, 48),
        15,
        Paint()
          ..color = _marigold.withValues(alpha: glowOpacity)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      canvas.restore();
    }

    final flameOpacity = lit
        ? _stops(flameT, 0, 1, 1, .70)
        : _stops(flameT, 1, 1, 0, .22);
    final flameScaleY = lit
        ? _stops(flameT, .35, 1.06, 1, .70)
        : _stops(flameT, 1, 1.18, .25, .22);
    final flameColor = lit
        ? Color.lerp(_inkSoft, _marigold, flameT)!
        : Color.lerp(_marigold, _inkSoft, flameT)!;

    if (flameOpacity > 0.001) {
      canvas.save();
      canvas.translate(33, 62); // the flame's own bottom centre
      canvas.scale(1, flameScaleY);
      canvas.translate(-33, -62);
      canvas.drawPath(
        Path()
          ..moveTo(33, 36)
          ..relativeCubicTo(7, 8, 9, 12, 9, 17)
          ..arcToPoint(const Offset(24, 53), radius: const Radius.circular(9))
          ..relativeCubicTo(0, -5, 2, -9, 9, -17)
          ..close(),
        Paint()..color = flameColor.withValues(alpha: flameOpacity),
      );
      canvas.restore();
    }

    canvas.drawRRect(
      RRect.fromLTRBR(9, 70, 57, 78, const Radius.circular(4)),
      solid,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(_LanternPainter old) =>
      old.t != t || old.lit != lit || old.onDark != onDark;
}
