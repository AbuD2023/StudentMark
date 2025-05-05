import 'dart:developer';

import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course_subject.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class EditLectureScheduleDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;
  final LectureSchedule schedule;

  const EditLectureScheduleDialog({
    super.key,
    required this.coordinatorService,
    required this.schedule,
  });

  @override
  State<EditLectureScheduleDialog> createState() =>
      _EditLectureScheduleDialogState();
}

class _EditLectureScheduleDialogState extends State<EditLectureScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedDayOfWeek;
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late int _selectedDepartmentId;
  late int _selectedLevelId;
  late int _selectedCourseSubjectId;
  late int _selectedDoctorId;
  final _roomController = TextEditingController();

  List<Department> _departments = [];
  List<Level> _levels = [];
  List<CourseSubject> _courseSubjects = [];
  List<Course> _courses = [];
  List<DoctorDepartmentsLevels> _doctors = [];

  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    // try {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    // Initialize form fields with schedule data
    _selectedDayOfWeek = widget.schedule.dayOfWeek;
    final startTimeParts = widget.schedule.startTime.split(':');
    _selectedStartTime = TimeOfDay(
      hour: int.parse(startTimeParts[0]),
      minute: int.parse(startTimeParts[1]),
    );
    final endTimeParts = widget.schedule.endTime.split(':');
    _selectedEndTime = TimeOfDay(
      hour: int.parse(endTimeParts[0]),
      minute: int.parse(endTimeParts[1]),
    );
    _selectedDepartmentId = widget.schedule.departmentId;
    _selectedLevelId = widget.schedule.levelId;
    _selectedCourseSubjectId = widget.schedule.courseSubjectId;
    _selectedDoctorId = widget.schedule.doctorId;
    _roomController.text = widget.schedule.room;

    // Load departments
    final departments = await widget.coordinatorService.getAllDepartments();
    _departments = departments;

    // Load doctors
    final doctors = await widget.coordinatorService.getAllDoctorAssignments();
    _doctors = doctors;
    // _doctors.forEach(
    //   (element) {
    //     log(element.toJson().toString());
    //   },
    // );
    // _doctors.add(doctors.first);

    // Load levels for selected department
    await _loadLevels(_selectedDepartmentId);

    // Load course subjects for selected level
    await _loadCourseSubjects(_selectedLevelId);

    setState(() {
      _isLoading = false;
    });
    // } catch (e) {
    //   setState(() {
    //     _error = e.toString();
    //     _isLoading = false;
    //   });
    // }
  }

  Future<void> _loadLevels(int departmentId) async {
    try {
      final levels =
          await widget.coordinatorService.getLevelsByDepartment(departmentId);
      setState(() {
        _levels = levels;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _loadCourseSubjects(int levelId) async {
    try {
      final courses = await widget.coordinatorService.getLevelCourses(levelId);
      setState(() {
        _courses = courses;
        _courseSubjects = []; // Clear previous subjects
      });

      for (var course in _courses) {
        if (course.courseSubjects != null) {
          setState(() {
            _courseSubjects.addAll(course.courseSubjects!);
          });
        }
      }

      // Ensure the selected course subject is still valid
      if (!_courseSubjects.any((cs) => cs.id == _selectedCourseSubjectId)) {
        setState(() {
          _selectedCourseSubjectId =
              _courseSubjects.isNotEmpty ? _courseSubjects.first.id : 0;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );
    if (picked != null) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedEndTime,
    );
    if (picked != null) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final updatedSchedule = LectureSchedule(
        id: widget.schedule.id,
        courseSubjectId: _selectedCourseSubjectId,
        departmentId: _selectedDepartmentId,
        levelId: _selectedLevelId,
        doctorId: _selectedDoctorId,
        dayOfWeek: _selectedDayOfWeek,
        startTime:
            '${_selectedStartTime.hour.toString().padLeft(2, '0')}:${_selectedStartTime.minute.toString().padLeft(2, '0')}:00',
        endTime:
            '${_selectedEndTime.hour.toString().padLeft(2, '0')}:${_selectedEndTime.minute.toString().padLeft(2, '0')}:00',
        room: _roomController.text,
        isActive: widget.schedule.isActive,
      );

      await widget.coordinatorService.updateSchedule(updatedSchedule);
      if (mounted) {
        Navigator.pop(context, updatedSchedule);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في تحديث الجدول: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تعديل جدول دراسي'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text('Error: $_error'))
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<int>(
                          value: _selectedDayOfWeek,
                          decoration: const InputDecoration(
                            labelText: 'اليوم',
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 6,
                              child: Text('السبت'),
                            ),
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
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedDayOfWeek = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار اليوم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => _selectStartTime(context),
                                child: Text(_selectedStartTime.format(context)),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () => _selectEndTime(context),
                                child: Text(_selectedEndTime.format(context)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: _selectedDepartmentId,
                          decoration: const InputDecoration(
                            labelText: 'القسم',
                          ),
                          items: _departments
                              .map((d) => DropdownMenuItem(
                                    value: d.id as int,
                                    child: Text(d.departmentName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartmentId = value!;
                            });
                            _loadLevels(value!);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار القسم';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: _selectedLevelId,
                          decoration: const InputDecoration(
                            labelText: 'المستوى',
                          ),
                          items: _levels
                              .map((l) => DropdownMenuItem(
                                    value: l.id as int,
                                    child: Text(l.levelName),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLevelId = value!;
                            });
                            _loadCourseSubjects(value!);
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار المستوى';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: _selectedCourseSubjectId,
                          decoration: const InputDecoration(
                            labelText: 'المادة الدراسية',
                          ),
                          items: _courseSubjects
                              .map((cs) => DropdownMenuItem(
                                    value: cs.id,
                                    child: Text(
                                        cs.subject?.subjectName ?? 'غير معروف'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCourseSubjectId = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار المادة الدراسية';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<int>(
                          value: _selectedDoctorId,
                          decoration: const InputDecoration(
                            labelText: 'المحاضر',
                          ),
                          items: _doctors
                              .map((d) => DropdownMenuItem(
                                    value: d.id,
                                    child: Text(d.doctor?.fullName as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDoctorId = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار المحاضر';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _roomController,
                          decoration: const InputDecoration(
                            labelText: 'القاعة',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اسم القاعة';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: _submit,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}
