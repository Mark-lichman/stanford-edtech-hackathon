import 'package:flutter/material.dart';

import '../theme.dart';

/// The deliberate stopping place. It has no controls by design.
class DarkPanel extends StatelessWidget {
  const DarkPanel({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: PrimerTheme.night,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(PrimerTheme.space7),
            child: DefaultTextStyle(
              style: PrimerTheme.story.copyWith(color: PrimerTheme.nightInk),
              child: child,
            ),
          ),
        ),
      );
}

/// A short, warm full-bleed transition before the new story page.
class CelebrationPanel extends StatelessWidget {
  const CelebrationPanel({super.key, required this.child, this.onDone});
  final Widget child;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: PrimerTheme.lampPale,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(PrimerTheme.space7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Center(child: child)),
                if (onDone != null)
                  SizedBox(
                    height: 56,
                    child: TextButton(
                      onPressed: onDone,
                      child: Text('Turn the page', style: PrimerTheme.affordance),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
}

/// Compatibility name used by the first screen scaffold.
class GreenPanel extends CelebrationPanel {
  const GreenPanel({super.key, required super.child});
}
