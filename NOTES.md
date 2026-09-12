# Stanford EdTech Hackathon — 2026-09-12

Plan lives in [PLAN.md](PLAN.md). This file is scratch.

## Constraint that shapes code layout
This may become a branch of HabitCrafts (Mark-lichman/HabitCrafts, FlutterFlow-generated).
Keep everything under `lib/` in plain Flutter widgets with no deps on this project's
scaffolding, and keep the HabitCrafts `habits` field names (prompt / behavior /
celebration / why / complete[]). Port path = copy the folder into HabitCrafts `lib/`,
wire one route.

## Current state
- `lib/hack/study_plan.dart` — the habit engine. Written for the pre-pivot exam
  use case; the anchor → behavior → celebration recipe, spaced scheduling, and
  streak logic all survive the pivot. Becomes `lib/primer/quest.dart`.
- `lib/hack/theme.dart` — HabitCrafts palette + Poppins. **Being deleted**; wrong
  audience per PLAN.md §4.
- `lib/hack/plan_screen.dart` — exam UI. Reference only, gets replaced.
- `test/study_plan_test.dart` — 4 tests, green.

No persistence anywhere. In-memory state only; a browser reload loses the plan.
Fine for demo day, and noted so nobody rediscovers it on stage.

## Run
    flutter run -d chrome      # fastest for demo
    flutter test
