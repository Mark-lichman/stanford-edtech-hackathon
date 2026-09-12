import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LanternStory extends StatefulWidget {
  const LanternStory({super.key});
  @override
  State<LanternStory> createState() => _LanternStoryState();
}

class _LanternStoryState extends State<LanternStory> {
  int _step = 0;
  String _interest = 'creatures';
  bool _noteGone = false;
  bool _talking = false;

  void _next() => setState(() => _step = math.min(_step + 1, 7));

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 480),
                switchInCurve: Curves.easeOutCubic,
                child: KeyedSubtree(key: ValueKey(_step), child: _screen()),
              ),
            ),
          ),
        ),
      );

  Widget _screen() {
    switch (_step) {
      case 0: return _welcome();
      case 1: return _marginNote();
      case 2: return _doors();
      case 3: return _storyPage();
      case 4: return _readingLeave();
      case 5: return _holdToTalk();
      case 6: return _earnedPage();
      default: return _close();
    }
  }

  Widget _welcome() => _PageScaffold(step: 1, eyebrow: 'A little book for tonight', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const _LanternMark(), const SizedBox(height: 52),
        Text('Hello, Maya.', style: _display(46)), const SizedBox(height: 12),
        Text('What kind of story is tugging at you tonight?', style: _body(21)), const SizedBox(height: 30),
        Wrap(spacing: 10, runSpacing: 10, children: [for (final choice in ['creatures', 'secret places', 'big feelings']) ChoiceChip(
          label: Text(choice), selected: _interest == choice, onSelected: (_) => setState(() => _interest = choice),
          labelStyle: TextStyle(color: _interest == choice ? const Color(0xFFF7F0E2) : const Color(0xFF325171), fontWeight: FontWeight.w800),
          selectedColor: const Color(0xFF3D6170), backgroundColor: const Color(0xFFE6D8C3), side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        )]), const SizedBox(height: 42),
        _WarmButton(label: 'Open tonight\'s book', icon: Icons.arrow_forward_rounded, onTap: _next), const SizedBox(height: 24),
        Text('You can change your mind at any time.', style: _small()),
      ]));

  Widget _marginNote() => _PageScaffold(step: 2, eyebrow: 'A note in the margin', child: Stack(clipBehavior: Clip.none, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Psst...', style: _display(48)), const SizedBox(height: 14), Text('Someone has scribbled on your page.', style: _body(21)),
          const SizedBox(height: 150), Text('Rub it away to see what comes next.', style: _small()), const SizedBox(height: 42),
          _WarmButton(label: 'Keep the note', icon: Icons.arrow_forward_rounded, onTap: _next),
        ]),
        if (!_noteGone) Positioned(right: -10, top: 128, child: GestureDetector(
          onPanUpdate: (_) => setState(() => _noteGone = true), onTap: () => setState(() => _noteGone = true),
          child: Transform.rotate(angle: -0.045, child: CustomPaint(painter: _PencilNotePainter(), child: const SizedBox(width: 245, height: 125, child: Padding(
            padding: EdgeInsets.fromLTRB(28, 24, 20, 8), child: Text('I wonder what\'s\nbehind the door...', style: TextStyle(fontSize: 20, height: 1.18, color: Color(0xFF7D827F), fontStyle: FontStyle.italic)),
          ))),
        )),
        if (_noteGone) Positioned(right: 4, top: 150, child: Text('smudge', style: _small().copyWith(fontStyle: FontStyle.italic))),
      ]));

  Widget _doors() {
    final books = [('The Night Garden', 'home ground', const Color(0xFFB8CDBD)), ('Hilda and the Troll', 'a small step away', const Color(0xFFE6B28F)), ('The Secret Lake', 'a little farther', const Color(0xFFA9B5D0))];
    return _PageScaffold(step: 3, eyebrow: 'Three doors', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Which one is calling?', style: _display(43)), const SizedBox(height: 10), Text('There is no wrong door. Just one for tonight.', style: _body(20)), const SizedBox(height: 28),
      for (var i = 0; i < books.length; i++) ...[_Door(title: books[i].$1, subtitle: books[i].$2, color: books[i].$3, onTap: _next), if (i != books.length - 1) const SizedBox(height: 13)],
    ]));
  }

  Widget _storyPage() => _PageScaffold(step: 4, eyebrow: 'The book opens', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('The little door in the hill', style: _display(38)), const SizedBox(height: 25),
        Text('At the edge of the mossy wood, where the moon made silver puddles between the roots, a tiny door appeared. It was no taller than a teacup. Behind it, someone was humming a song that sounded almost like her own.', style: _story(21)), const SizedBox(height: 18),
        Text('The door had a brass handle, warm as a pocket stone. Maya put her ear against the wood. Something on the other side took one careful breath.', style: _story(21)), const SizedBox(height: 26),
        Text('What do you think is waiting?', style: _story(22).copyWith(fontWeight: FontWeight.w800)), const SizedBox(height: 34),
        Row(children: [const Icon(Icons.volume_up_rounded, color: Color(0xFF3D6170)), const SizedBox(width: 8), Text('Tap the page to read it to me', style: _small().copyWith(color: const Color(0xFF3D6170), fontWeight: FontWeight.w800))]), const SizedBox(height: 28),
        _WarmButton(label: 'Take the book with you', icon: Icons.menu_book_rounded, onTap: _next),
      ]));

  Widget _readingLeave() => _DarkInterlude(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.nights_stay_rounded, size: 38, color: Color(0xFFECCB87)), const SizedBox(height: 28),
        Text('Now go find out.', style: _display(40, color: const Color(0xFFF7F0E2)), textAlign: TextAlign.center), const SizedBox(height: 14),
        Text('Read the chapter. Try the quest.\nLantern will be here when you come back.', style: _body(20, color: const Color(0xFFD9CDBD)), textAlign: TextAlign.center), const SizedBox(height: 54),
        TextButton(onPressed: _next, child: Text('I\'m back', style: _small().copyWith(color: const Color(0xFFECCB87), fontWeight: FontWeight.w800))),
      ]));

  Widget _holdToTalk() => _PageScaffold(step: 6, eyebrow: 'One line from the real book', child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tell the page what you found.', style: _display(40)), const SizedBox(height: 15), Text('Find one line you liked. Hold the lantern and say it out loud.', style: _body(20)), const SizedBox(height: 46),
        Center(child: GestureDetector(onLongPressStart: (_) { HapticFeedback.lightImpact(); setState(() => _talking = true); }, onLongPressEnd: (_) => setState(() => _talking = false), child: AnimatedContainer(
          duration: const Duration(milliseconds: 220), width: 178, height: 178,
          decoration: BoxDecoration(shape: BoxShape.circle, color: _talking ? const Color(0xFFE78A62) : const Color(0xFFF1B589), border: Border.all(color: const Color(0xFFBB694E), width: 3)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(_talking ? Icons.graphic_eq_rounded : Icons.mic_none_rounded, size: 42, color: const Color(0xFF4B302B)), const SizedBox(height: 8), Text(_talking ? 'Listening...' : 'Hold to talk', style: const TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF4B302B)))]),
        ))), const SizedBox(height: 28), Center(child: const _GentleLevel()), const SizedBox(height: 34),
        Center(child: TextButton(onPressed: _next, child: Text('I\'d rather not talk tonight', style: _small().copyWith(decoration: TextDecoration.underline)))), const SizedBox(height: 8), Center(child: Text('You can still keep going.', style: _small())),
      ]));

  Widget _earnedPage() => _PageScaffold(step: 7, eyebrow: 'A new page, made by you', celebration: true, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [const Text('✦', style: TextStyle(fontSize: 34, color: Color(0xFFB77A1F))), const SizedBox(width: 10), Text('You made it into the story.', style: _small().copyWith(fontWeight: FontWeight.w900, color: const Color(0xFF8B5B1F)))]), const SizedBox(height: 30),
        Text('Maya held the line\nlike a bright pebble.', style: _display(40)), const SizedBox(height: 24), Text('The little door opened. Behind it was a room full of sleeping moths, each one carrying a small piece of the night sky.', style: _story(21)), const SizedBox(height: 24),
        _ArtifactSketch(), const SizedBox(height: 20), Text('There is still more to find tomorrow.', style: _story(21).copyWith(fontStyle: FontStyle.italic)), const SizedBox(height: 32), _WarmButton(label: 'Close the book', icon: Icons.nights_stay_rounded, onTap: _next),
      ]));

  Widget _close() => _DarkInterlude(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('The lantern is dimming.', style: _display(38, color: const Color(0xFFF7F0E2)), textAlign: TextAlign.center), const SizedBox(height: 18), Text('Tomorrow, the door will remember you.', style: _body(20, color: const Color(0xFFD9CDBD)), textAlign: TextAlign.center), const SizedBox(height: 54),
        Text('closing in 09', style: GoogleFonts.spaceMono(fontSize: 14, color: const Color(0xFFECCB87), letterSpacing: 1.5)),
      ]));
}

TextStyle _display(double size, {Color? color}) => GoogleFonts.baloo2(fontSize: size, height: 1.05, fontWeight: FontWeight.w800, color: color ?? const Color(0xFF23363A));
TextStyle _body(double size, {Color? color}) => GoogleFonts.baloo2(fontSize: size, height: 1.35, fontWeight: FontWeight.w600, color: color ?? const Color(0xFF4D5B59));
TextStyle _story(double size) => GoogleFonts.baloo2(fontSize: size, height: 1.55, fontWeight: FontWeight.w600, color: const Color(0xFF2B3939));
TextStyle _small() => GoogleFonts.baloo2(fontSize: 14, height: 1.35, color: const Color(0xFF7C6D5C));

class _PageScaffold extends StatelessWidget {
  const _PageScaffold({required this.step, required this.eyebrow, required this.child, this.celebration = false});
  final int step; final String eyebrow; final Widget child; final bool celebration;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.fromLTRB(18, 12, 18, 18), child: Column(children: [
    _Topline(step: step), const SizedBox(height: 12), Expanded(child: Center(child: SingleChildScrollView(child: CustomPaint(painter: _PageBorderPainter(), child: Container(width: double.infinity, padding: const EdgeInsets.fromLTRB(30, 30, 30, 34), color: celebration ? const Color(0xFFF8E3A5) : const Color(0xFFF7F0E2), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(eyebrow.toUpperCase(), style: GoogleFonts.baloo2(fontSize: 11, letterSpacing: 1.7, fontWeight: FontWeight.w900, color: const Color(0xFF718080))), const SizedBox(height: 12), child])))))),
  ]));
}

class _Topline extends StatelessWidget {
  const _Topline({required this.step}); final int step;
  @override
  Widget build(BuildContext context) => Row(children: [Text('LANTERN', style: GoogleFonts.baloo2(fontSize: 12, letterSpacing: 2.2, fontWeight: FontWeight.w900, color: const Color(0xFF3D6170))), const Spacer(), Text('$step / 8', style: _small()), const SizedBox(width: 10), SizedBox(width: 80, child: ClipRRect(borderRadius: BorderRadius.circular(10), child: LinearProgressIndicator(value: step / 8, minHeight: 5, backgroundColor: const Color(0xFFD8CCBB), color: const Color(0xFFE78A62))))]);
}

class _WarmButton extends StatelessWidget {
  const _WarmButton({required this.label, required this.icon, required this.onTap}); final String label; final IconData icon; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label), style: FilledButton.styleFrom(backgroundColor: const Color(0xFF3D6170), foregroundColor: const Color(0xFFF7F0E2), minimumSize: const Size.fromHeight(58), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)), textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16))));
}

class _Door extends StatelessWidget {
  const _Door({required this.title, required this.subtitle, required this.color, required this.onTap}); final String title, subtitle; final Color color; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(button: true, label: title, child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(18), child: Container(minHeight: 82, padding: const EdgeInsets.all(12), decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFD5C8B5), width: 1.3)), child: Row(children: [_Cover(color: color), const SizedBox(width: 17), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.w800)), const SizedBox(height: 1), Text(subtitle, style: _small())])), const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Color(0xFF718080))]))));
}

class _Cover extends StatelessWidget {
  const _Cover({required this.color}); final Color color;
  @override
  Widget build(BuildContext context) => Container(width: 52, height: 58, decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4), topRight: Radius.circular(12), bottomRight: Radius.circular(5)), border: Border.all(color: const Color(0xFF60716F), width: 1.2)), child: const Center(child: Icon(Icons.auto_awesome, size: 22, color: Color(0xFF3D6170))));
}

class _GentleLevel extends StatelessWidget {
  const _GentleLevel();
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [for (var i = 0; i < 5; i++) Container(width: 5, height: 9 + i * 3.0, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: i < 2 ? const Color(0xFFE78A62) : const Color(0xFFD7C7B6), borderRadius: BorderRadius.circular(4)))]);
}

class _ArtifactSketch extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD1B76D), width: 1.2), borderRadius: BorderRadius.circular(16)), child: Row(children: [CustomPaint(size: const Size(76, 56), painter: _MothPainter()), const SizedBox(width: 16), Expanded(child: Text('your moth\nnow lives here', style: _display(23, color: const Color(0xFF8B5B1F))))]));
}

class _LanternMark extends StatelessWidget {
  const _LanternMark();
  @override
  Widget build(BuildContext context) => Row(children: [Container(width: 34, height: 34, decoration: const BoxDecoration(color: Color(0xFFE78A62), shape: BoxShape.circle), child: const Icon(Icons.light_mode_rounded, size: 20, color: Color(0xFF4B302B))), const SizedBox(width: 10), Text('for curious readers', style: _small().copyWith(fontWeight: FontWeight.w800))]);
}

class _DarkInterlude extends StatelessWidget {
  const _DarkInterlude({required this.child}); final Widget child;
  @override
  Widget build(BuildContext context) => Container(color: const Color(0xFF182629), width: double.infinity, height: double.infinity, padding: const EdgeInsets.all(34), child: child);
}

class _PageBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFBCA991)..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final path = Path()..moveTo(13, 2)..quadraticBezierTo(size.width * .28, 6, size.width * .52, 2)..quadraticBezierTo(size.width * .78, -1, size.width - 12, 4)..quadraticBezierTo(size.width - 6, size.height * .3, size.width - 11, size.height * .55)..quadraticBezierTo(size.width - 6, size.height * .8, size.width - 13, size.height - 3)..quadraticBezierTo(size.width * .7, size.height - 7, size.width * .46, size.height - 2)..quadraticBezierTo(size.width * .2, size.height + 2, 10, size.height - 4)..quadraticBezierTo(5, size.height * .7, 9, size.height * .48)..quadraticBezierTo(4, size.height * .22, 13, 2);
    canvas.drawPath(path, p);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PencilNotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFE2DED3);
    final path = Path()..moveTo(4, 10)..quadraticBezierTo(size.width * .5, 0, size.width - 4, 8)..quadraticBezierTo(size.width, size.height * .5, size.width - 7, size.height - 6)..quadraticBezierTo(size.width * .5, size.height, 8, size.height - 9)..quadraticBezierTo(0, size.height * .5, 4, 10);
    canvas.drawPath(path, p);
    final line = Paint()..color = const Color(0xFFB5B3AC)..strokeWidth = 1;
    for (var y = 18.0; y < size.height - 10; y += 15) canvas.drawLine(Offset(16, y), Offset(size.width - 15, y + 2), line);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MothPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = const Color(0xFFE78A62);
    canvas.drawOval(Rect.fromLTWH(7, 12, 28, 34), p); canvas.drawOval(Rect.fromLTWH(40, 12, 28, 34), p); canvas.drawCircle(38, 29, 7, Paint()..color = const Color(0xFF3D6170));
    final line = Paint()..color = const Color(0xFF3D6170)..strokeWidth = 1.5; canvas.drawLine(const Offset(34, 23), const Offset(25, 12), line); canvas.drawLine(const Offset(42, 23), const Offset(51, 12), line);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
