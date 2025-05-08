import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/widgets/weekly_grid_table.dart';

class WeeklyScheduleTableScreen extends StatelessWidget {
  final CoordinatorService coordinatorService;
  final int levelId;

  const WeeklyScheduleTableScreen({
    super.key,
    required this.coordinatorService,
    required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الجدول الأسبوعي')),
      body: FutureBuilder<List<LectureSchedule>>(
        future: coordinatorService.getSchedulesByLevel(levelId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final schedules = snapshot.data!;
          return WeeklyGridTable(schedules: schedules);
        },
      ),
    );
  }
}
