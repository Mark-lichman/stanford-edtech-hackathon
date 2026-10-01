// Renders the storyteller recordings the app plays for "read to me".
//
//   ELEVENLABS_API_KEY=... dart run tool/render_voice.dart            render
//   ELEVENLABS_API_KEY=... dart run tool/render_voice.dart --list     voices
//   ... --voice=<voice id>   pick a voice (or ELEVENLABS_VOICE_ID)
//   ... --force              re-render even if the text hasn't changed
//   ... --yes                actually spend; without it, only say what it would
//
// ElevenLabs bills per character, so a run first lists what it would render
// and the total, and stops there unless given --yes. Unchanged passages are
// never re-rendered.
//
// Rendered once and bundled, never called from the app: no key ships in the
// build, nothing fails on conference wifi, every device hears the same voice,
// and no request leaves the device while a child is using it.
//
// Each file is listed in assets/voice/manifest.json with the exact text it
// reads. The app only plays a recording whose text still matches, so editing
// the copy in doorways.dart quietly falls back to the device voice until this
// is run again.
//
// A way-in with an ask is recorded in two parts, the story and then what the
// book asks her to do, joined by ffmpeg with a pause and tool/page-turn.wav (a
// soft two-note chime) between them, so she can hear the story stop and the
// book turn to her. That needs ffmpeg on the PATH; the characters billed are
// the same either way.
import 'dart:convert';
import 'dart:io';

import 'package:stanford_edtech/primer/book.dart';
import 'package:stanford_edtech/primer/content/doorways.dart';

/// The Cover's adventures. Only each series' home door is authored, so those
/// are the passages there are to read.
const adventures = ['meadow', 'animal-talk', 'forest'];

/// "Lily": a warm, velvety British woman from ElevenLabs' premade voices,
/// chosen by ear over seven candidates. Research for this age favours warm and
/// light over deep and authoritative; the first render used "George"
/// (JBFqnCBsd6RMkjVDRZzb), which read as too strong. Premade, so no creator
/// can take it down from the library. Override with --voice.
const defaultVoice = 'pFZP5JQG7iQjIQuC4Bku';

final voiceDir = Directory('assets/voice');
final manifestFile = File('assets/voice/manifest.json');

Future<void> main(List<String> args) async {
  final key = Platform.environment['ELEVENLABS_API_KEY'];
  if (key == null || key.isEmpty) {
    stderr.writeln('Set ELEVENLABS_API_KEY first.');
    exit(64);
  }
  final client = HttpClient();
  try {
    if (args.contains('--list')) return await listVoices(client, key);

    final voice = args
            .where((a) => a.startsWith('--voice='))
            .map((a) => a.substring('--voice='.length))
            .firstOrNull ??
        Platform.environment['ELEVENLABS_VOICE_ID'] ??
        defaultVoice;
    final force = args.contains('--force');

    final manifest = manifestFile.existsSync()
        ? Map<String, String>.from(jsonDecode(manifestFile.readAsStringSync()) as Map)
        : <String, String>{};

    final todo = <(String, String, List<String>)>[]; // (file name, text, parts to record)
    const source = SeededBookSource();
    for (final interest in adventures) {
      final home = (await source.doorsFor(interest: interest, reach: 1)).singleWhere((b) => b.isHomeGround);
      final door = doorways[home.id];
      if (door == null) {
        stderr.writeln('skip ${home.id}: no authored door');
        continue;
      }
      final text = door.spokenWayIn(home.title);
      final name = '${home.id}-way-in.mp3';
      final file = File('${voiceDir.path}/$name');
      if (!force && manifest[name] == text && file.existsSync()) {
        stdout.writeln('same  $name');
        continue;
      }
      final parts = door.wayInAsk.isEmpty ? [text] : ['${home.title}. ${door.wayIn}', door.wayInAsk];
      todo.add((name, text, parts));
    }

    final total = todo.fold<int>(0, (n, t) => n + t.$2.length);
    for (final (name, text, _) in todo) {
      stdout.writeln('${args.contains('--yes') ? 'voice' : 'would'} $name (${text.length} characters)');
    }
    if (todo.isEmpty) return stdout.writeln('Nothing to render.');
    if (!args.contains('--yes')) {
      return stdout.writeln('$total characters. Run again with --yes to spend them.');
    }
    for (final (name, text, parts) in todo) {
      final file = File('${voiceDir.path}/$name');
      if (parts.length == 1) {
        file.writeAsBytesSync(await render(client, key, voice, text));
      } else {
        final tmp = Directory.systemTemp.createTempSync('lantern-voice');
        final story = File('${tmp.path}/story.mp3')..writeAsBytesSync(await render(client, key, voice, parts[0]));
        final ask = File('${tmp.path}/ask.mp3')..writeAsBytesSync(await render(client, key, voice, parts[1]));
        await joinWithChime(story, ask, file);
        tmp.deleteSync(recursive: true);
      }
      manifest[name] = text;
      // Written after every file, so a failure halfway keeps what worked.
      manifestFile.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert(manifest)}\n');
    }
  } finally {
    client.close();
  }
}

/// Story, half a second of quiet, the chime, a little more quiet, then the
/// ask: the same shape the first recordings were cut to by hand.
Future<void> joinWithChime(File story, File ask, File out) async {
  final result = await Process.run('ffmpeg', [
    '-y', '-v', 'error', '-i', story.path, '-i', 'tool/page-turn.wav', '-i', ask.path,
    '-filter_complex',
    'anullsrc=r=44100:cl=mono,atrim=0:0.5[s1];anullsrc=r=44100:cl=mono,atrim=0:0.45[s2];'
        '[0]aresample=44100[a];[1]aresample=44100[c];[2]aresample=44100[b];'
        '[a][s1][c][s2][b]concat=n=5:v=0:a=1[out]',
    '-map', '[out]', '-ac', '1', '-b:a', '128k', out.path,
  ]);
  if (result.exitCode != 0) throw ProcessException('ffmpeg', const [], '${result.stderr}', result.exitCode);
}

Future<List<int>> render(HttpClient client, String key, String voice, String text) async {
  final req = await client.postUrl(Uri.parse(
      'https://api.elevenlabs.io/v1/text-to-speech/$voice?output_format=mp3_44100_128'));
  req.headers
    ..set('xi-api-key', key)
    ..contentType = ContentType.json;
  req.write(jsonEncode({
    'text': text,
    'model_id': 'eleven_multilingual_v2',
    // Steady, plain and unhurried. The first render (low stability, style
    // 0.35) came out too strong: research for this age points to warm and
    // understated over performed, and ~120-135 wpm with real pauses so a weak
    // reader can follow the words. Style above 0 exaggerates the speaker.
    'voice_settings': {
      'stability': 0.65,
      'similarity_boost': 0.75,
      'style': 0.0,
      'use_speaker_boost': true,
      'speed': 0.88,
    },
  }));
  final res = await req.close();
  final bytes = await res.fold<List<int>>([], (all, chunk) => all..addAll(chunk));
  if (res.statusCode != 200) {
    throw HttpException('ElevenLabs ${res.statusCode}: ${utf8.decode(bytes, allowMalformed: true)}');
  }
  return bytes;
}

Future<void> listVoices(HttpClient client, String key) async {
  final req = await client.getUrl(Uri.parse('https://api.elevenlabs.io/v1/voices'));
  req.headers.set('xi-api-key', key);
  final res = await req.close();
  final body = jsonDecode(await res.transform(utf8.decoder).join()) as Map;
  for (final v in (body['voices'] as List? ?? const [])) {
    final labels = (v['labels'] as Map? ?? const {}).values.join(', ');
    stdout.writeln('${v['voice_id']}  ${v['name']}  ($labels)');
  }
}
