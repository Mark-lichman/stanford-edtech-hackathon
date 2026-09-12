import 'package:flutter/material.dart';

import 'hack/plan_screen.dart';
import 'hack/theme.dart';

void main() => runApp(const StudyPlanApp());

class StudyPlanApp extends StatelessWidget {
  const StudyPlanApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'HabitCrafts · Exam Plan',
        theme: habitCraftsTheme(),
        home: const PlanScreen(),
      );
}
