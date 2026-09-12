# Today — 2026-09-12

Working sheet for the Stanford EdTech hackathon. **Throw this away tonight.**
It is not the plan of record — [PLAN.md](PLAN.md) is, and [MARK.md](MARK.md) is
my track. This is the thing to point at when starting a track cold.

Say **"start A"** (or B, C, D, E) and the whole of that section gets built.
Tracks B, C and D can run at the same time; A has to land first.

    cd stanford-edtech-hackathon && flutter pub get
    flutter test        # 7 green right now
    flutter run -d chrome

Package name is `stanford_edtech`, so imports read
`package:stanford_edtech/primer/...`.

---

## The contracts

Nailed down before anyone starts, so two tracks never write the same line.

**The run** — Track A owns this file, everyone else reads it.

    class Run {
      String childName   = 'Maya';
      String judgeName   = 'Grumble';
      Book?  picked;
      bool   artifactEarned = false;
    }

**Every screen** takes the run and a way forward, and owns nothing else.

    ScreenName({required Run run, required VoidCallback onNext})

**Aditya's widgets** come in through one barrel, never by file:

    import 'package:stanford_edtech/primer/widgets/widgets.dart';
    // BookPage, MarginNote, Door, HoldToTalk, DarkPanel, GreenPanel
    // (BookPage, not Page — Flutter exports its own Page and every screen
    //  imports material.)

Stubs live behind that barrel today. When his real ones land it's a one-line
export swap and no screen changes.

**Content** is already written and needs nothing:
`lib/primer/content/doorways.dart` → `doorways['hilda-troll']`.
Book shelf is `lib/primer/book.dart` → `SeededBookSource().doorsFor(interest:
'creatures', reach: 0)`.

---

## Track A — the run

**Creates:** `lib/primer/run.dart`, `lib/primer/widgets/stubs.dart`,
`lib/primer/widgets/widgets.dart`, rewrites `lib/main.dart`

The `Run` class above, a `PageView` holding the seven beats in order, and a tap
that advances it. No provider, no go_router, no state package — `setState` at
the top and nothing else. Delete the `hack/theme.dart` import from main.

The stub widgets are deliberately ugly: right constructor signatures, plain
Material inside, zero styling effort. Their job is to let B compile at 10am.

**Done when:** `flutter run -d chrome` opens on the Cover and seven taps get to
the end without an exception. Ugly is expected.

**Box:** 40 minutes. Solo. B cannot start until the barrel exists.

## Track B — the screens

**Creates:** `lib/primer/screens/` — `cover.dart`, `doors.dart`, `way_in.dart`,
`return.dart`, `celebration.dart`, `intercept.dart`, `dark.dart`

One file per beat, all independent, so this splits as many ways as there are
hands. Each composes from the barrel and takes `(run, onNext)`.

Start with `return.dart` — highest risk, wants the most device time.

Constraints that aren't negotiable: one thing per screen, tap targets ≥56dp,
story text 20pt+, no counters or progress bars, no loss-framed copy. No Field
Guide screen today; the artifact appears inside `celebration.dart` going into
the guide.

`way_in.dart` renders the anchor (`prompt`) as its own line above the quest —
plain, no label. The script names it out loud at 0:38, so it has to be visibly
a separate thing on the page.

**Done when:** each screen renders its beat from the real content in
`doorways.dart` — no placeholder strings anywhere.

**Box:** most of the day.

## Track C — read-aloud

**Touches:** `return.dart`'s audio path and the `HoldToTalk` behaviour

Build the **failure path first**: a visible "I'd rather not talk tonight" that
awards the artifact and moves the story on, with no microphone involved. Once
that works the demo cannot die here.

Then the mic: permission, ten seconds, a soft level indicator, discarded. **No
score, no number, no transcript, nothing stored or sent.** A score is a number
we promised not to produce and it is also what breaks in a loud room.

**Done when:** the beat completes twice on the actual demo device — once with
mic allowed, once with mic denied — and looks deliberate both times.

**Box:** early, not last. The Chrome permission prompt is the real failure,
not the audio.

## Track D — the Epic handoff

**Creates:** `lib/primer/screens/reader.dart` — a mock reader for *Hilda and
the Troll*. No `url_launcher`, no new dependency.

**Settled:** Epic has no public API, so the reader is ours and we say so on
stage before the tap ([SCRIPT.md](SCRIPT.md), 0:55). The door still opens; it
opens our page. The titles and the catalogue stay real — those are live Epic
ids in `book.dart` and they are the honest part of the claim.

This kills the two questions that used to live here. No device with no Epic
app, no signed-out paywall bounce, no venue wifi in the critical path. The
handoff beat can no longer fail live, which is worth more than the real tap was.

Enough page to read as a book and no more: the cover, the title, the first
page of real text, a page turn. It is on screen for seven seconds.

**Done when:** tapping Hilda opens the mock, it reads as a book rather than a
placeholder, and the 0:55 line is rehearsed with it.

**Box:** 30 minutes. Nothing here is blocked on anyone else now.

## Track E — seed, script, rehearse

The script is [SCRIPT.md](SCRIPT.md) — spoken lines, word budget, fallbacks.

**Touches:** seeded state, and the run-through

Seed it lived-in — Grumble already named, a page or two already in the field
guide — so the Cover isn't the only thing that has ever happened. Put The Dark
behind a trigger hittable on demand mid-pitch.

The trigger is a **long press anywhere** — no visible control on stage.

Then rehearse **twice**, on the demo device, on venue wifi, all three of us.
Decide who presents and who drives before the last ninety minutes, not during.

**Done when:** two clean run-throughs at or under 1:52.

---

## The run we are building to

    0:00  Cover          asks her name, then one thing she likes
    0:12  Grumble        grey scrawl appears; she wipes it; she names him
    0:28  Three doors    three real Hilda books; tap Hilda and the Troll
    0:38  The way in     eighty words, the quest, then it closes
    0:55  Handoff        the door opens the real book in Epic
    1:02  The Return     hold to talk, ten seconds, reading a line back
    1:18  Celebration    "I found that" — artifact into the field guide
    1:28  The intercept  cut to night four: she couldn't do it
    1:40  The Dark       ink on black, a countdown, no way in
    1:52  done

Three minutes on stage, so roughly a minute of air to talk over it.

**Not being built today:** the `study_plan.dart` → `quest.dart` port, spaced
repetition, reach widening, chapter counting, the Field Guide screen,
persistence. All real product, none of it on screen in two minutes.

## If we slip

Cut in this order: the Field Guide screen (already gone), the finger-wipe on
Grumble (ship static marginalia), the Cover naming beat (pre-name him in the
seed).

Never cut: **The Dark**, the **intercept**, the **read-aloud fallback**, the
**two rehearsals**.

## Three things not to say on stage

Ten seconds is proof of work, not a fluency measurement — no score, no number,
shown to nobody. Not "less screen time" but displacement: four screen minutes
buying twenty minutes of reading and fifteen off the screen entirely. And never
"2 sigma."
