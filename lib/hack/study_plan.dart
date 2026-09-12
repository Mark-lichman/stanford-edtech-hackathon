import 'dart:math' as math;

/// Exam study plan built out of HabitCrafts-shaped habits.
///
/// Field names mirror the HabitCrafts `habits` Firestore collection
/// (prompt / behavior / celebration / why / complete) so porting this into a
/// HabitCrafts branch is a copy plus a Firestore write, not a rewrite.
/// The shape is BJ Fogg's Tiny Habits recipe: anchor prompt -> tiny behavior ->
/// immediate celebration. The celebration is the positive reinforcement, and
/// it is a required field here, not an optional nicety.
class StudyHabit {
  StudyHabit({
    required this.prompt,
    required this.behavior,
    required this.celebration,
    required this.why,
    required this.day,
    this.isReview = false,
    List<DateTime>? complete,
  }) : complete = complete ?? <DateTime>[];

  /// Anchor — the existing routine this attaches to ("After I ...").
  final String prompt;

  /// The tiny study action. Deliberately small enough to never be skipped.
  final String behavior;

  /// What you do the instant you finish. The reinforcement.
  final String celebration;

  /// Why this exam matters to you. Shown on every session.
  final String why;

  /// Scheduled date, local midnight.
  final DateTime day;

  /// Spaced-repetition recall session rather than first exposure.
  final bool isReview;

  /// Completion timestamps, same as the HabitCrafts `complete` array.
  final List<DateTime> complete;

  bool get done => complete.isNotEmpty;
}

class StudyPlan {
  StudyPlan({
    required this.exam,
    required this.examDate,
    required this.why,
    required this.habits,
  });

  final String exam;
  final DateTime examDate;
  final String why;
  final List<StudyHabit> habits;

  int get doneCount => habits.where((h) => h.done).length;
}

DateTime dateOnly(DateTime t) => DateTime(t.year, t.month, t.day);

/// Calendar arithmetic that survives DST: constructing a DateTime with an
/// overflowing day normalizes, and it stays at local midnight. Adding a
/// Duration would drift by an hour across a transition.
DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

int daysBetween(DateTime from, DateTime to) =>
    DateTime.utc(to.year, to.month, to.day)
        .difference(DateTime.utc(from.year, from.month, from.day))
        .inDays;

/// Everyday routines to hang study sessions on. Fogg's anchors: attach to
/// something that already reliably happens.
const anchors = [
  'After I pour my morning coffee',
  'After I sit down at my desk',
  'After I close my laptop for lunch',
  'After I get back to my room',
  'After I brush my teeth at night',
];

/// Same idea as the HabitCrafts `celebration_suggestions` collection.
const celebrationSuggestions = [
  'Say "I did that!" out loud',
  'Throw both fists in the air',
  'Smile big for two full seconds',
  'Tell yourself "that is who I am now"',
  'Play one song you love, loud',
  'Text a friend the single word "done"',
];

/// Days after first exposure to schedule a recall session.
const reviewOffsets = [1, 3, 7];

/// Builds the plan: every topic gets one first-exposure session spread across
/// the front 60% of the runway, then recall sessions at +1/+3/+7 days, dropping
/// any that would land on or after exam day.
StudyPlan buildStudyPlan({
  required String exam,
  required DateTime examDate,
  required List<String> topics,
  String why = '',
  DateTime? today,
}) {
  final start = dateOnly(today ?? DateTime.now());
  final examDay = dateOnly(examDate);
  final runway = daysBetween(start, examDay);
  if (runway < 1) {
    throw ArgumentError.value(
        examDate, 'examDate', 'must be at least one day after today');
  }

  final clean = topics.map((t) => t.trim()).where((t) => t.isNotEmpty).toList();
  if (clean.isEmpty) {
    throw ArgumentError.value(topics, 'topics', 'need at least one topic');
  }

  final learnWindow = math.max(1, (runway * 0.6).floor());
  final habits = <StudyHabit>[];

  for (var i = 0; i < clean.length; i++) {
    final firstDay = (i * learnWindow / clean.length).floor();
    habits.add(_session(start, firstDay, clean[i], i, why, review: false));
    for (final offset in reviewOffsets) {
      final day = firstDay + offset;
      if (day < runway) {
        habits.add(
            _session(start, day, clean[i], i + offset, why, review: true));
      }
    }
  }

  habits.sort((a, b) => a.day.compareTo(b.day));
  return StudyPlan(
      exam: exam, examDate: examDay, why: why, habits: habits);
}

StudyHabit _session(
  DateTime start,
  int dayOffset,
  String topic,
  int seed,
  String why, {
  required bool review,
}) =>
    StudyHabit(
      prompt: anchors[seed % anchors.length],
      behavior: review
          ? 'Cover your notes and say three things you remember about $topic'
          : 'Read one page on $topic and write one sentence in your own words',
      celebration: celebrationSuggestions[seed % celebrationSuggestions.length],
      why: why,
      day: addDays(start, dayOffset),
      isReview: review,
    );

/// Consecutive days ending today with at least one completed session.
int currentStreak(StudyPlan plan, {DateTime? today}) {
  final done =
      plan.habits.expand((h) => h.complete).map(dateOnly).toSet();
  var day = dateOnly(today ?? DateTime.now());
  var streak = 0;
  while (done.contains(day)) {
    streak++;
    day = addDays(day, -1);
  }
  return streak;
}

int daysUntilExam(StudyPlan plan, {DateTime? today}) =>
    daysBetween(dateOnly(today ?? DateTime.now()), plan.examDate);

List<StudyHabit> habitsOn(StudyPlan plan, DateTime day) {
  final d = dateOnly(day);
  return plan.habits.where((h) => h.day == d).toList();
}
