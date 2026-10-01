/// The Primer's voice. PLAN.md: read-aloud is canon, not an a11y bolt-on, and
/// every string should be tappable to hear.
///
/// A passage with a storyteller recording (assets/voice, rendered once by
/// tool/render_voice.dart) plays that. Anything else is synthesised on the
/// device: the browser's speech engine on web, the system voice on Android.
/// Either way it only ever speaks our own authored copy, and nothing leaves the
/// device while she is using it.
library;

import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ReadAloud extends ChangeNotifier {
  /// Made on first use, not up front, so a screen that never speaks never
  /// touches the plugin, and widget tests run without one.
  FlutterTts? _tts;
  AudioPlayer? _player;

  /// Exact text to recording, from assets/voice/manifest.json. A passage whose
  /// copy has been edited since it was rendered no longer matches, and falls
  /// back to the device voice instead of reading the old words.
  Map<String, String>? _recordings;

  /// The text being read right now, or null when quiet. Lets a page show
  /// "reading" on the passage that is actually being read.
  String? _speaking;
  String? get speaking => _speaking;

  /// The word being spoken right now, as character offsets into [speaking].
  /// Null when the voice gives no word timing (a recording, or a device voice
  /// without boundary events), and the page then marks the whole passage.
  (int, int)? get word => _word;
  (int, int)? _word;

  /// Called once when [speaking] finishes on its own, never when it is stopped
  /// or replaced. This is how a chapter reads on paragraph by paragraph.
  VoidCallback? _onDone;

  /// Tap to hear it, tap again to stop. Tapping a different passage switches
  /// to it rather than stopping.
  Future<void> toggle(String text) => _speaking == text ? stop() : speak(text);

  Future<void> speak(String text, {VoidCallback? onDone}) async {
    _onDone = null;
    await _quiet();
    _onDone = onDone;
    _word = null;
    _set(text);
    final recording = (_recordings ??= await _loadRecordings())[text];
    if (recording != null && await _play(recording, text)) return;
    try {
      final tts = _tts ??= await _create();
      await tts.speak(text);
    } catch (_) {
      // No voice on this device is a quiet page, never a crash on stage.
      _set(null);
    }
  }

  Future<void> stop() async {
    _onDone = null;
    _set(null);
    await _quiet();
  }

  Future<void> _quiet() async {
    try {
      await _player?.stop();
    } catch (_) {}
    try {
      await _tts?.stop();
    } catch (_) {}
  }

  Future<Map<String, String>> _loadRecordings() async {
    try {
      final manifest = jsonDecode(await rootBundle.loadString('assets/voice/manifest.json')) as Map;
      return {for (final e in manifest.entries) '${e.value}': 'voice/${e.key}'};
    } catch (_) {
      return const {};
    }
  }

  /// False when the recording couldn't play and she is still waiting for this
  /// passage, so the caller reads it with the device voice instead. If she has
  /// tapped away meanwhile there is nothing to fall back for.
  Future<bool> _play(String asset, String text) async {
    try {
      final player = _player ??= AudioPlayer()..onPlayerComplete.listen((_) => _finished());
      await player.play(AssetSource(asset));
      return true;
    } catch (_) {
      return _speaking != text;
    }
  }

  Future<FlutterTts> _create() async {
    final tts = FlutterTts();
    await tts.setLanguage('en-US');
    // Unhurried, for a child following along. The scales differ: on web 1.0
    // is normal speed, on Android 0.5 is.
    await tts.setSpeechRate(kIsWeb ? 0.85 : 0.42);
    await tts.setPitch(1.0);
    await _pickVoice(tts);
    tts.setCompletionHandler(_finished);
    tts.setProgressHandler((text, start, end, word) {
      if (_speaking == null) return;
      _word = (start, end);
      notifyListeners();
    });
    // Stopping is ours, and [stop] already clears. Cancelling one passage to
    // start the next fires these late, after the next has begun, and must not
    // flip that one's page back to quiet.
    tts.setErrorHandler((message) {
      if (!'$message'.contains('interrupt') && !'$message'.contains('cancel')) _set(null);
    });
    return tts;
  }

  /// The default voice is often the oldest one on the machine (Microsoft David
  /// on Windows Chrome), which reads a bedtime story like a train announcement.
  /// Take the first of these the device has, in order; otherwise keep the
  /// default.
  ///
  /// Installed voices only. Chrome's network voices ("Google US English", and
  /// Edge's "Online (Natural)") can accept a passage and then never start, and
  /// a stuck one jams the queue so nothing after it plays either. Seen in the
  /// window `flutter run` opens: `speaking` true, no sound, no error. The
  /// storyteller sound comes from the recordings; this is the fallback, and a
  /// fallback has to start every time.
  static const _preferred = ['zira', 'aria', 'jenny', 'samantha', 'karen', 'microsoft'];

  static bool _isNetwork(Map v) {
    final name = '${v['name']}'.toLowerCase();
    return name.startsWith('google') || name.contains('online') || name.contains('natural');
  }

  Future<void> _pickVoice(FlutterTts tts) async {
    try {
      Future<List<Map>> english() async => [
            for (final v in (await tts.getVoices as List? ?? const []))
              if (v is Map && '${v['locale']}'.toLowerCase().startsWith('en') && !_isNetwork(v)) v,
          ];
      var voices = await english();
      // Chrome fills its voice list a moment after the page loads, so the
      // first ask can come back empty.
      if (voices.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 400));
        voices = await english();
      }
      for (final want in _preferred) {
        for (final v in voices) {
          if ('${v['name']}'.toLowerCase().contains(want)) {
            await tts.setVoice({'name': '${v['name']}', 'locale': '${v['locale']}'});
            return;
          }
        }
      }
    } catch (_) {}
  }

  void _finished() {
    final next = _onDone;
    _onDone = null;
    _word = null;
    _set(null);
    next?.call();
  }

  void _set(String? text) {
    if (_speaking == text) return;
    _speaking = text;
    notifyListeners();
  }

  @override
  void dispose() {
    _tts?.stop();
    _player?.dispose();
    super.dispose();
  }
}
