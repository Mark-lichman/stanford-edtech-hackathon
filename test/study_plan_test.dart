import 'package:flutter_test/flutter_test.dart';
import 'package:stanford_edtech/hack/study_plan.dart';

void main() {
  final today = DateTime(2026, 9, 12);

  test('every topic gets first exposure plus spaced recall before exam day',
      () {
    final plan = buildStudyPlan(
      exam: 'Midterm',
      examDate: DateTime(2026, 10, 3),
      topics: ['Alpha', 'Beta'],
      today: today,
    );

    expect(plan.habits.every((h) => h.day.isBefore(plan.examDate)), isTrue);
    expect(plan.habits.every((h) => h.celebration.isNotEmpty), isTrue,
        reason: 'celebration is the reinforcement, never optional');
    for (final topic in ['Alpha', 'Beta']) {
      final mine = plan.habits.where((h) => h.behavior.contains(topic));
      expect(mine.where((h) => !h.isReview).length, 1);
      expect(mine.where((h) => h.isReview).length, reviewOffsets.length);
    }
  });

  test('rejects a plan with no runway or no topics', () {
    expect(
      () => buildStudyPlan(
          exam: 'x', examDate: today, topics: ['Alpha'], today: today),
      throwsArgumentError,
    );
    expect(
      () => buildStudyPlan(
          exam: 'x',
          examDate: DateTime(2026, 10, 3),
          topics: ['', '  '],
          today: today),
      throwsArgumentError,
    );
  });

  test('streak counts back only over consecutive completed days', () {
    final plan = buildStudyPlan(
      exam: 'Midterm',
      examDate: DateTime(2026, 10, 3),
      topics: ['Alpha', 'Beta', 'Gamma'],
      today: today,
    );
    expect(currentStreak(plan, today: today), 0);

    // today and yesterday done, three days ago done but not two days ago.
    plan.habits[0].complete.add(today);
    plan.habits[1].complete.add(addDays(today, -1));
    plan.habits[2].complete.add(addDays(today, -3));
    expect(currentStreak(plan, today: today), 2);
  });

  test('day arithmetic survives a DST transition', () {
    // US DST ends 2026-11-01. Local-midnight + Duration(days:) would drift.
    final before = DateTime(2026, 10, 31);
    expect(daysBetween(before, addDays(before, 3)), 3);
    expect(addDays(before, 3).day, 3);
  });
}
