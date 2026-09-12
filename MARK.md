# Mark's tracks

My part of PLAN.md §8, cut to what a **two-minute demo** actually needs. Five
tracks, A to E. Each owns files nobody else writes, so they run in parallel.

Already done and pushed: `lib/primer/book.dart` (the Epic shelf, six real Hilda
ids) and `lib/primer/content/doorways.dart` (the authored door). The writing is
finished. What's left is making taps happen in order.

    cd stanford-edtech-hackathon && flutter pub get && flutter test
    flutter run -d chrome

---

## The demo, first — everything below serves this

One continuous run, 1:52, no talking. Three minutes on stage means about a
minute of air to talk over it, which is the right ratio.

    0:00  Cover          the book asks her name, then one thing she likes
    0:12  Grumble        a grey scrawl appears; she wipes it; she names him
    0:28  Three doors    three real Hilda books; tap Hilda and the Troll
    0:38  The way in     eighty words, then the quest, then it closes
    0:55  Handoff        the door opens the real book in Epic
    1:02  The Return     hold to talk, ten seconds, reading a line back
    1:18  Celebration    "I found that" — the artifact goes in the field guide
    1:28  The intercept  cut to night four: she couldn't do it
    1:40  The Dark       ink on black, a countdown, no way in
    1:52  done

**If it isn't in that list, it isn't getting built today.** That includes the
spaced-repetition scheduling, reach widening, and chapter counting — real parts
of the product, none of which appear on screen in two minutes. The
`study_plan.dart` → `quest.dart` port is a roadmap item, not a demo item. I'm
not doing it today and we lose nothing on stage.

---

## Track A — the run

**Owns:** `lib/primer/run.dart`, `lib/main.dart`

One mutable object holding what carries across screens: her name, the name she
gave Grumble, the book she picked, whether the artifact is earned, and which
beat we're on. No state management package, no provider, no routing library —
a `PageView` the presenter taps forward, and `setState` at the top.

Rip `hack/theme.dart` out of `main.dart` and point it at the Cover.

Do this first and alone; it's about forty lines and B can't start without the
shape.

## Track B — the screens

**Owns:** `lib/primer/screens/` — one file each, so this track splits further

Seven files, in the order they're tapped: `cover.dart`, `doors.dart`,
`way_in.dart`, `return.dart`, `celebration.dart`, `intercept.dart`,
`dark.dart`.

Each takes the run and its content as parameters and owns no state. They
compose from Aditya's widgets through the barrel — ugly stubs today, his real
ones whenever they land, and the swap is one export line.

Build `return.dart` first. It is the single point of failure and it wants the
most device time.

The Field Guide gets no screen. The artifact appears inside the celebration,
going into the guide, which is all two minutes has room for and is closer to
"in use, never a grid" anyway. A separate screen is Track F if the day goes
well, and it's the first thing PLAN.md says to cut.

## Track C — read-aloud

**Owns:** the `HoldToTalk` behaviour and the Return beat's audio path

**Build the failure path first.** The visible "I'd rather not talk tonight"
door has to award the artifact and move the story on, with no mic involved at
all. Once that works, the demo cannot die here — and that fallback isn't a
compromise, a book that punishes a child for not performing is the wrong book.

Then add the mic: permission, ten seconds, a gentle level indicator, discard.
**No scoring.** We promised no number and a score is a number; it is also the
thing most likely to misbehave in a loud room.

Test mic permission in `flutter run -d chrome` on the actual demo device early.
That prompt, not the audio, is the realistic failure.

## Track D — the Epic handoff

**Owns:** the door tap, `url_launcher`, and the fallback reader

Tapping the door opens
https://www.getepic.com/book/62843717/hilda-and-the-troll

Two things to find out before the stage, both about what a search engine can't
tell us: what it does on a device with no Epic app, and what it does signed
out. If it bounces to a paywall in front of the sponsor we need to know now.
Fallback is a mocked reader page, and we say out loud which one they're
watching.

## Track E — seed, script, rehearse

**Owns:** the seeded state and the run-through

Seed it lived-in: Grumble already named, a couple of pages already in the field
guide, so the Cover isn't the only thing that's ever happened. Put The Dark
behind a trigger that can be hit on demand mid-pitch.

Then rehearse **twice**, on the demo device, on venue wifi. Last ninety
minutes, all three of us. PLAN.md is right that this is the first thing every
team cuts and the only thing here that can't be fixed afterwards.

---

## Order and dependencies

A alone first (~40 min). Then B, C and D genuinely in parallel — B needs A's
shape, C and D need nothing. E last and it is not optional.

If a track slips, cut in this order: the Field Guide screen, then the
finger-wipe on Grumble (ship static marginalia), then the Cover naming beat
(pre-name him in the seed).

Never cut: **The Dark**, the **intercept**, the **read-aloud fallback**, and
the two rehearsals.

## Known, and fine

No persistence anywhere. In-memory only, and a browser reload loses the run.
That's correct for today — just don't reload on stage.
