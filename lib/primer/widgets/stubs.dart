/// Deliberately ugly stand-ins for Aditya's widgets.
///
/// The only thing that matters here is the constructor signature — screens are
/// written against these today and against his real ones tonight, and the swap
/// is one export line in `widgets.dart`. Nobody should spend a minute styling
/// anything in this file.
library;

import 'package:flutter/material.dart';

/// The book surface everything else sits on. Named `BookPage`, not `Page`:
/// Flutter already exports a `Page` and every screen imports material, so the
/// short name costs a `hide Page` in seven files.
class BookPage extends StatelessWidget {
  const BookPage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFFF4ECD8),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 20, color: Colors.black87),
            child: child,
          ),
        ),
      );
}

/// Grey pencil in the margin. Wipeable: drag across it and it goes.
class MarginNote extends StatelessWidget {
  const MarginNote({super.key, required this.text, this.onWiped});

  final String text;
  final VoidCallback? onWiped;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onPanEnd: onWiped == null ? null : (_) => onWiped!(),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, color: Colors.grey),
        ),
      );
}

/// One of the three doors.
class Door extends StatelessWidget {
  const Door({super.key, required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          height: 56,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: const TextStyle(fontSize: 20)),
        ),
      );
}

/// Ten seconds of reading aloud. [onSkip] is the failure path and is not
/// optional on stage — Track C builds that side first.
class HoldToTalk extends StatelessWidget {
  const HoldToTalk({super.key, required this.onDone, this.onSkip});

  final VoidCallback onDone;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onLongPress: onDone,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              color: Colors.black12,
              child: const Text('Hold to talk'),
            ),
          ),
          if (onSkip != null)
            TextButton(
              onPressed: onSkip,
              child: const Text("I'd rather not talk tonight"),
            ),
        ],
      );
}

/// Ink on black. The Dark.
class DarkPanel extends StatelessWidget {
  const DarkPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 20, color: Colors.white70),
            child: child,
          ),
        ),
      );
}

/// The celebration surface.
class GreenPanel extends StatelessWidget {
  const GreenPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFFDDEBD3),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 20, color: Colors.black87),
            child: child,
          ),
        ),
      );
}
