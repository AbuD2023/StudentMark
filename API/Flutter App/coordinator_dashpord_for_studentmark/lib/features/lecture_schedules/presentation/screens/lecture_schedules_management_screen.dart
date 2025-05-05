import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/widgets/add_lecture_schedule_dialog.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/widgets/edit_lecture_schedule_dialog.dart';

class LectureSchedulesManagementScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const LectureSchedulesManagementScreen({
    super.key,
    required this.coordinatorService,
  });

  @override
  State<LectureSchedulesManagementScreen> createState() =>
      _LectureSchedulesManagementScreenState();
}

class _LectureSchedulesManagementScreenState
    extends State<LectureSchedulesManagementScreen> {
  List<LectureSchedule> _schedules = [];
  bool _isLoading = true;
  String _error = '';
  bool _showActiveOnly = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final schedules = _showActiveOnly
          ? await widget.coordinatorService.getActiveSchedules()
          : await widget.coordinatorService.getAllSchedules();

      setState(() {
        _schedules = schedules;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _addSchedule() async {
    final result = await showDialog<LectureSchedule>(
      context: context,
      builder: (context) => AddLectureScheduleDialog(
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      _loadSchedules();
    }
  }

  Future<void> _editSchedule(LectureSchedule schedule) async {
    final result = await showDialog<LectureSchedule>(
      context: context,
      builder: (context) => EditLectureScheduleDialog(
        coordinatorService: widget.coordinatorService,
        schedule: schedule,
      ),
    );

    if (result != null) {
      _loadSchedules();
    }
  }

  Future<void> _toggleScheduleStatus(int id) async {
    try {
      await widget.coordinatorService.toggleScheduleStatus(id);
      _loadSchedules();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تغيير حالة الجدول: ${e.toString()}')),
        );
      }
    }
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 0:
        return 'الأحد';
      case 1:
        return 'الإثنين';
      case 2:
        return 'الثلاثاء';
      case 3:
        return 'الأربعاء';
      case 4:
        return 'الخميس';
      case 5:
        return 'الجمعة';
      case 6:
        return 'السبت';
      default:
        return 'غير معروف';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الجداول الدراسية'),
        actions: [
          IconButton(
            icon: Icon(_showActiveOnly ? Icons.filter_list : Icons.filter_alt),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _loadSchedules();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشطة فقط',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSchedules,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text('Error: $_error'))
              : RefreshIndicator(
                  onRefresh: _loadSchedules,
                  child: _schedules.isEmpty
                      ? const Center(
                          child: Text('لا توجد جداول دراسية'),
                        )
                      : ListView.builder(
                          itemCount: _schedules.length,
                          itemBuilder: (context, index) {
                            final schedule = _schedules[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(
                                  '${schedule.courseSubject?.subject?.subjectName ?? 'غير معروف'} - ${schedule.department?.departmentName ?? 'غير معروف'}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'المستوى: ${schedule.level?.levelName ?? 'غير معروف'}',
                                    ),
                                    Text(
                                      'اليوم: ${_getDayName(schedule.dayOfWeek)}',
                                    ),
                                    Text(
                                      'الوقت: ${schedule.startTime} - ${schedule.endTime}',
                                    ),
                                    Text(
                                      'القاعة: ${schedule.room}',
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editSchedule(schedule),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        schedule.isActive
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () =>
                                          _toggleScheduleStatus(schedule.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSchedule,
        child: const Icon(Icons.add),
      ),
    );
  }
}
