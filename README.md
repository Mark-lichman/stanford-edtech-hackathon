# Lantern

Stanford EdTech Hackathon — 2026-09-12. Sponsor: Epic for Kids.

A storytelling book for kids under 12 that starts from something they already
love, sends them off the screen to do one small real thing, and closes itself.
It widens what it offers only as fast as the child's confidence grows. Every
night ends on purpose; the story doesn't. There is no fixed length: habits form
through the feeling of success, not elapsed time, and the child keeps building
her story and field guide for as long as she wants.

Flutter (web + Android). Built on the habit engine from HabitCrafts, so the
core recipe fields — anchor prompt, tiny behaviour, celebration — port back to
a HabitCrafts branch as a copy.

## Where the design lives

- [PLAN.md](PLAN.md) — decisions, scope, build tracks, risks.
- Concept user journey (visual, shareable):
  https://claude.ai/code/artifact/f1fd0a26-a0f7-4f50-a141-15d64ccbe839

## Run

    flutter pub get
    flutter run -d chrome     # fastest for demo
    flutter test

## Layout

    lib/hack/study_plan.dart   habit engine — anchor / behaviour / celebration,
                               spaced scheduling, streak logic. Becomes
                               lib/primer/quest.dart.
    lib/hack/theme.dart        pre-pivot HabitCrafts palette. Being replaced.
    lib/hack/plan_screen.dart  pre-pivot exam UI. Reference only.
    test/                      engine tests.

## Standing constraints

These are load-bearing, not preferences. Anything that breaks one needs a
decision, not a patch.

- Nothing a child says or selects is stored, transmitted, or shown to anyone.
- Read-aloud audio is scored on-device and discarded in-frame. COPPA's 2025
  amendments make voiceprints personal information; a stored embedding counts.
- No points, XP, badges, leaderboards, streak counters, or reading levels.
- Nothing may create a reason to open the app more often.
- Children never contact other children. No chat, no names, no free text
  crossing between kids.
