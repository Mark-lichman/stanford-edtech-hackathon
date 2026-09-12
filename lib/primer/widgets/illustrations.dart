import 'package:flutter/material.dart';

/// Four reusable crops from the shared Lantern illustration sheet.
enum LanternArtworkPart { lantern, door, moth, books }

class LanternArtwork extends StatelessWidget {
  const LanternArtwork({super.key, required this.part, this.width = 72, this.height = 60});

  final LanternArtworkPart part;
  final double width;
  final double height;

  Alignment get _alignment => switch (part) {
        LanternArtworkPart.lantern => Alignment.topLeft,
        LanternArtworkPart.door => Alignment.topRight,
        LanternArtworkPart.moth => Alignment.bottomLeft,
        LanternArtworkPart.books => Alignment.bottomRight,
      };

  @override
  Widget build(BuildContext context) => ClipRect(
        child: SizedBox(
          width: width,
          height: height,
          child: FractionallySizedBox(
            widthFactor: 2,
            heightFactor: 2,
            alignment: _alignment,
            child: Image.asset(
              'assets/lantern/visual-sheet.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
