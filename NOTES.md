# Stanford EdTech Hackathon — 2026-09-12

## Idea
TBD.

## Constraint that shapes code layout
This may become a branch of HabitCrafts (Mark-lichman/HabitCrafts, FlutterFlow-generated).
So: keep everything we write under `lib/` in plain Flutter widgets with no deps on this
project's scaffolding. Port path = copy `lib/hack/` into HabitCrafts `lib/`, wire one route.
Don't touch `main.dart` beyond the route that launches our screen.

## Run
    flutter run -d chrome      # fastest for demo
    flutter run -d <device>    # android

## Log
- Project created, counter demo left in place as the toolchain smoke test.
