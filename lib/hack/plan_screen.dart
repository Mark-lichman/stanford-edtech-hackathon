import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'study_plan.dart';
import 'theme.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  StudyPlan? _plan;

  @override
  Widget build(BuildContext context) {
    final plan = _plan;
    return Scaffold(
      appBar: AppBar(
        title: Text(plan == null ? 'Build your study plan' : plan.exam),
        actions: [
          if (plan != null)
            IconButton(
              tooltip: 'Start over',
              icon: const Icon(Icons.restart_alt),
              onPressed: () => setState(() => _plan = null),
            ),
        ],
      ),
      body: plan == null
          ? _SetupForm(onBuilt: (p) => setState(() => _plan = p))
          : _PlanView(plan: plan, onComplete: _toggle),
    );
  }

  void _toggle(StudyHabit habit) {
    final wasDone = habit.done;
    setState(() {
      if (wasDone) {
        habit.complete.clear();
      } else {
        habit.complete.add(DateTime.now());
      }
    });
    if (wasDone) return;

    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: HC.success,
        duration: const Duration(seconds: 3),
        content: Text(
          'Now: ${habit.celebration}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ));
  }
}

class _SetupForm extends StatefulWidget {
  const _SetupForm({required this.onBuilt});

  final ValueChanged<StudyPlan> onBuilt;

  @override
  State<_SetupForm> createState() => _SetupFormState();
}

class _SetupFormState extends State<_SetupForm> {
  final _exam = TextEditingController(text: 'Organic Chemistry midterm');
  final _topics = TextEditingController(
      text: 'Nomenclature, Stereochemistry, Reaction mechanisms, '
          'Spectroscopy, Acid-base chemistry');
  final _why = TextEditingController(text: 'I want to get into med school');
  DateTime _examDate = addDays(DateTime.now(), 21);

  @override
  void dispose() {
    _exam.dispose();
    _topics.dispose();
    _why.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Every session gets an anchor, a tiny action, and a celebration. '
          'The celebration is the part that makes it stick.',
          style: TextStyle(color: HC.grayDark, height: 1.4),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _exam,
          decoration: const InputDecoration(
              labelText: 'Exam', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        InputDecorator(
          decoration: const InputDecoration(
              labelText: 'Exam date', border: OutlineInputBorder()),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_friendlyDate(_examDate)),
              TextButton(onPressed: _pickDate, child: const Text('Change')),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _topics,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Topics (comma separated)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _why,
          decoration: const InputDecoration(
            labelText: 'Why this exam matters to you',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 28),
        FilledButton(onPressed: _build, child: const Text('Build my plan')),
      ],
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _examDate,
      firstDate: addDays(now, 1),
      lastDate: addDays(now, 365),
    );
    if (picked != null) setState(() => _examDate = picked);
  }

  void _build() {
    try {
      widget.onBuilt(buildStudyPlan(
        exam: _exam.text.trim().isEmpty ? 'My exam' : _exam.text.trim(),
        examDate: _examDate,
        topics: _topics.text.split(','),
        why: _why.text.trim(),
      ));
    } on ArgumentError catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }
}

class _PlanView extends StatelessWidget {
  const _PlanView({required this.plan, required this.onComplete});

  final StudyPlan plan;
  final ValueChanged<StudyHabit> onComplete;

  @override
  Widget build(BuildContext context) {
    final byDay = <DateTime, List<StudyHabit>>{};
    for (final h in plan.habits) {
      byDay.putIfAbsent(h.day, () => []).add(h);
    }
    final days = byDay.keys.toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: days.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, i) {
        if (i == 0) return _Header(plan: plan);
        final day = days[i - 1];
        return _DayCard(
          day: day,
          habits: byDay[day]!,
          onComplete: onComplete,
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.plan});

  final StudyPlan plan;

  @override
  Widget build(BuildContext context) {
    final streak = currentStreak(plan);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${daysUntilExam(plan)} days until ${plan.exam}',
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600)),
            if (plan.why.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('Because: ${plan.why}',
                  style: const TextStyle(color: HC.grayDark)),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                _Stat(
                  label: 'day streak',
                  value: '$streak',
                  color: streak > 0 ? HC.accent1 : HC.grayDark,
                ),
                const SizedBox(width: 12),
                _Stat(
                  label: 'sessions done',
                  value: '${plan.doneCount}/${plan.habits.length}',
                  color: HC.accent2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(
      {required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w700)),
            Text(label,
                style: const TextStyle(fontSize: 12, color: HC.grayDark)),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.habits,
    required this.onComplete,
  });

  final DateTime day;
  final List<StudyHabit> habits;
  final ValueChanged<StudyHabit> onComplete;

  @override
  Widget build(BuildContext context) {
    final isToday = day == dateOnly(DateTime.now());
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isToday
            ? const BorderSide(color: HC.primary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                _friendlyDate(day).toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: isToday ? HC.primary : HC.grayDark,
                ),
              ),
            ),
            for (final h in habits) _HabitTile(habit: h, onTap: onComplete),
          ],
        ),
      ),
    );
  }
}

class _HabitTile extends StatelessWidget {
  const _HabitTile({required this.habit, required this.onTap});

  final StudyHabit habit;
  final ValueChanged<StudyHabit> onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(habit),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: habit.done ? HC.success : Colors.transparent,
                border: Border.all(
                    color: habit.done ? HC.success : HC.grayDark, width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: habit.done
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${habit.prompt}…',
                    style: const TextStyle(
                        fontSize: 12,
                        color: HC.grayDark,
                        fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    habit.behavior,
                    style: TextStyle(
                      height: 1.3,
                      decoration: habit.done
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: habit.done ? HC.grayDark : HC.primaryText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      if (habit.isReview)
                        const _Chip(label: 'recall', color: HC.accent2),
                      Expanded(
                        child: Text(
                          'Then: ${habit.celebration}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: HC.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String _friendlyDate(DateTime day) {
  final delta = daysBetween(DateTime.now(), day);
  if (delta == 0) return 'Today';
  if (delta == 1) return 'Tomorrow';
  return '${_weekdays[day.weekday - 1]} ${day.month}/${day.day}';
}
