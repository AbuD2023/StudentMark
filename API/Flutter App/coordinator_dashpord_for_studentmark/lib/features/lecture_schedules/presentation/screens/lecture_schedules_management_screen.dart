import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/widgets/add_lecture_schedule_dialog.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/widgets/edit_lecture_schedule_dialog.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/widgets/schedule_filter_dialog.dart';
import 'package:coordinator_dashpord_for_studentmark/features/lecture_schedules/presentation/screens/weekly_schedule_table_screen.dart';

import '../../../../core/models/level.dart';

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
  String _viewMode = 'all'; // 'all', 'doctor', 'level'
  int? _selectedDoctorId;
  int? _selectedLevelId;
  int? _selectedDepartmentId;
  int? _selectedCourseSubjectId;
  int? _selectedDayOfWeek;
  DateTime? _startDate;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  bool get _hasFilters =>
      _selectedDayOfWeek != null ||
      _selectedDepartmentId != null ||
      _selectedCourseSubjectId != null;

  bool get _hasDateFilter => _startDate != null;

  Future<void> _loadSchedules() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      List<LectureSchedule> schedules = [];

      if (_hasFilters) {
        // تصفية متقدمة
        if (_selectedDoctorId != null) {
          schedules =
              await widget.coordinatorService.getFilteredSchedulesByDoctor(
            _selectedDoctorId!,
            departmentId: _selectedDepartmentId,
            levelId: _selectedLevelId,
            courseSubjectId: _selectedCourseSubjectId,
            dayOfWeek: _selectedDayOfWeek,
          );
        } else if (_selectedLevelId != null) {
          schedules =
              await widget.coordinatorService.getFilteredSchedulesByLevel(
            _selectedLevelId!,
            departmentId: _selectedDepartmentId,
            courseSubjectId: _selectedCourseSubjectId,
            dayOfWeek: _selectedDayOfWeek,
          );
        } else {
          // تصفية عامة
          schedules = _showActiveOnly
              ? await widget.coordinatorService.getActiveSchedules()
              : await widget.coordinatorService.getAllSchedules();

          // تطبيق التصفية محلياً
          if (_selectedDepartmentId != null) {
            schedules = schedules
                .where((s) => s.departmentId == _selectedDepartmentId)
                .toList();
          }
          if (_selectedCourseSubjectId != null) {
            schedules = schedules
                .where((s) => s.courseSubjectId == _selectedCourseSubjectId)
                .toList();
          }
          if (_selectedDayOfWeek != null) {
            schedules = schedules
                .where((s) => s.dayOfWeek == _selectedDayOfWeek)
                .toList();
          }
        }
      } else if (_hasDateFilter) {
        // تصفية حسب التاريخ
        if (_selectedDoctorId != null) {
          schedules = await widget.coordinatorService.getWeekSchedulesByDoctor(
            _selectedDoctorId!,
            startDate: _startDate,
          );
        } else if (_selectedLevelId != null) {
          schedules = await widget.coordinatorService.getWeekSchedulesByLevel(
            _selectedLevelId!,
            startDate: _startDate,
          );
        } else {
          schedules = _showActiveOnly
              ? await widget.coordinatorService.getActiveSchedules()
              : await widget.coordinatorService.getAllSchedules();
        }
      } else {
        // تصفية بسيطة حسب المحاضر أو المستوى
        switch (_viewMode) {
          case 'doctor':
            if (_selectedDoctorId != null) {
              schedules = await widget.coordinatorService
                  .getSchedulesByDoctor(_selectedDoctorId!);
            }
            break;
          case 'level':
            if (_selectedLevelId != null) {
              schedules = await widget.coordinatorService
                  .getSchedulesByLevel(_selectedLevelId!);
            }
            break;
          default:
            schedules = _showActiveOnly
                ? await widget.coordinatorService.getActiveSchedules()
                : await widget.coordinatorService.getAllSchedules();
        }
      }

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

  Future<void> _showFilterDialog() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => ScheduleFilterDialog(
        coordinatorService: widget.coordinatorService,
        viewMode: _viewMode,
        selectedDoctorId: _selectedDoctorId,
        selectedLevelId: _selectedLevelId,
        selectedDepartmentId: _selectedDepartmentId,
        selectedCourseSubjectId: _selectedCourseSubjectId,
        selectedDayOfWeek: _selectedDayOfWeek,
        startDate: _startDate,
      ),
    );

    if (result != null) {
      setState(() {
        _viewMode = result['viewMode'] ?? _viewMode;
        _selectedDoctorId = result['doctorId'];
        _selectedLevelId = result['levelId'];
        _selectedDepartmentId = result['departmentId'];
        _selectedCourseSubjectId = result['courseSubjectId'];
        _selectedDayOfWeek = result['dayOfWeek'];
        _startDate = result['startDate'];
      });
      _loadSchedules();
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

  String _getViewModeTitle() {
    switch (_viewMode) {
      case 'all':
        return 'جميع الجداول';
      case 'doctor':
        return 'جداول المحاضر';
      case 'level':
        return 'جداول المستوى';
      default:
        return 'إدارة الجداول الدراسية';
    }
  }

  void _showWeeklyTableDialog() async {
    int? levelId = await showDialog<int>(
      context: context,
      builder: (context) =>
          LevelSelectDialog(coordinatorService: widget.coordinatorService),
    );
    if (levelId != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WeeklyScheduleTableScreen(
            coordinatorService: widget.coordinatorService,
            levelId: levelId,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getViewModeTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
            tooltip: 'تصفية الجداول',
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'عرض الجدول الأسبوعي',
            onPressed: _showWeeklyTableDialog,
          ),
          IconButton(
            icon:
                Icon(_showActiveOnly ? Icons.visibility : Icons.visibility_off),
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
                                  '${schedule.courseSubject?.subject?.subjectName ?? 'غير معروف'} - ${schedule.courseSubject?.subject?.description ?? 'غير معروف'}',
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'القسم: ${schedule.department?.departmentName ?? 'غير معروف'}',
                                    ),
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
                                    Text(
                                      'الدكتور: ${schedule.doctor?.fullName ?? 'غير معروف'}',
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

class LevelSelectDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;
  const LevelSelectDialog({super.key, required this.coordinatorService});
  @override
  State<LevelSelectDialog> createState() => _LevelSelectDialogState();
}

class _LevelSelectDialogState extends State<LevelSelectDialog> {
  int? _selectedLevelId;
  List<Level> _levels = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    widget.coordinatorService.getAllLevels().then((levels) {
      setState(() {
        _levels = levels;
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اختر المستوى'),
      content: _loading
          ? const Center(child: CircularProgressIndicator())
          : DropdownButtonFormField<int>(
              value: _selectedLevelId,
              items: _levels
                  .map((level) => DropdownMenuItem(
                        value: level.id,
                        child: Text(level.levelName),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => _selectedLevelId = val),
              decoration: const InputDecoration(labelText: 'المستوى'),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _selectedLevelId == null
              ? null
              : () => Navigator.pop(context, _selectedLevelId),
          child: const Text('عرض الجدول'),
        ),
      ],
    );
  }
}
