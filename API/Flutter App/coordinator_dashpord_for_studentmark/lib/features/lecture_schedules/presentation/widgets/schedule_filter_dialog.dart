import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

import '../../../departments/domain/models/department_model.dart';

class ScheduleFilterDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;
  final String viewMode;
  final int? selectedDoctorId;
  final int? selectedLevelId;
  final int? selectedDepartmentId;
  final int? selectedCourseSubjectId;
  final int? selectedDayOfWeek;
  final DateTime? startDate;

  const ScheduleFilterDialog({
    super.key,
    required this.coordinatorService,
    required this.viewMode,
    this.selectedDoctorId,
    this.selectedLevelId,
    this.selectedDepartmentId,
    this.selectedCourseSubjectId,
    this.selectedDayOfWeek,
    this.startDate,
  });

  @override
  State<ScheduleFilterDialog> createState() => _ScheduleFilterDialogState();
}

class _ScheduleFilterDialogState extends State<ScheduleFilterDialog> {
  late String _viewMode;
  int? _selectedDoctorId;
  int? _selectedLevelId;
  int? _selectedDepartmentId;
  int? _selectedCourseSubjectId;
  int? _selectedDayOfWeek;
  DateTime? _startDate;
  List<DoctorDepartmentsLevels> _doctors = [];
  List<Level> _levels = [];
  List<Department> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewMode = widget.viewMode;
    _selectedDoctorId = widget.selectedDoctorId;
    _selectedLevelId = widget.selectedLevelId;
    _selectedDepartmentId = widget.selectedDepartmentId;
    _selectedCourseSubjectId = widget.selectedCourseSubjectId;
    _selectedDayOfWeek = widget.selectedDayOfWeek;
    _startDate = widget.startDate;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final doctors = await widget.coordinatorService.getAllDoctorAssignments();
      final levels = await widget.coordinatorService.getAllLevels();
      final departments = await widget.coordinatorService.getAllDepartments();
      if (mounted) {
        setState(() {
          _doctors = doctors;
          _levels = levels;
          _departments = departments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تحميل البيانات: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تصفية الجداول'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: _viewMode,
                    decoration: const InputDecoration(
                      labelText: 'نوع العرض',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('جميع الجداول'),
                      ),
                      DropdownMenuItem(
                        value: 'doctor',
                        child: Text('جداول المحاضر'),
                      ),
                      DropdownMenuItem(
                        value: 'level',
                        child: Text('جداول المستوى'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _viewMode = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_viewMode == 'doctor')
                    DropdownButtonFormField<int>(
                      value: _selectedDoctorId,
                      decoration: const InputDecoration(
                        labelText: 'المحاضر',
                      ),
                      items: _doctors.map((doctor) {
                        return DropdownMenuItem(
                          value: doctor.doctorId,
                          child: Text(doctor.doctor?.fullName ?? 'غير معروف'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedDoctorId = value;
                        });
                      },
                    ),
                  if (_viewMode == 'level')
                    DropdownButtonFormField<int>(
                      value: _selectedLevelId,
                      decoration: const InputDecoration(
                        labelText: 'المستوى',
                      ),
                      items: _levels.map((level) {
                        return DropdownMenuItem(
                          value: level.id,
                          child: Text(level.levelName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedLevelId = value;
                        });
                      },
                    ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedDepartmentId,
                    decoration: const InputDecoration(
                      labelText: 'القسم',
                    ),
                    items: _departments.map((department) {
                      return DropdownMenuItem(
                        value: department.id,
                        child: Text(department.departmentName),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDepartmentId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: _selectedDayOfWeek,
                    decoration: const InputDecoration(
                      labelText: 'اليوم',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 0,
                        child: Text('الأحد'),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text('الإثنين'),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text('الثلاثاء'),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text('الأربعاء'),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Text('الخميس'),
                      ),
                      DropdownMenuItem(
                        value: 5,
                        child: Text('الجمعة'),
                      ),
                      DropdownMenuItem(
                        value: 6,
                        child: Text('السبت'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedDayOfWeek = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('تاريخ البداية'),
                    subtitle: Text(_startDate?.toString() ?? 'غير محدد'),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (date != null) {
                          setState(() {
                            _startDate = date;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, {
              'viewMode': _viewMode,
              'doctorId': _selectedDoctorId,
              'levelId': _selectedLevelId,
              'departmentId': _selectedDepartmentId,
              'courseSubjectId': _selectedCourseSubjectId,
              'dayOfWeek': _selectedDayOfWeek,
              'startDate': _startDate,
            });
          },
          child: const Text('تطبيق'),
        ),
      ],
    );
  }
}
