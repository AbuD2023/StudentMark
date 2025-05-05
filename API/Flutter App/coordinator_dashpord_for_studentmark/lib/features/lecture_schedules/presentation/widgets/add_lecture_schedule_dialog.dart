import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:intl/intl.dart' as intl;

class AddLectureScheduleDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const AddLectureScheduleDialog({
    super.key,
    required this.coordinatorService,
  });

  @override
  State<AddLectureScheduleDialog> createState() =>
      _AddLectureScheduleDialogState();
}

class _AddLectureScheduleDialogState extends State<AddLectureScheduleDialog> {
  final _formKey = GlobalKey<FormState>();
  int? _selectedDayOfWeek;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  int? _selectedDepartmentId;
  int? _selectedLevelId;
  int? _selectedCourseSubjectId;
  int? _selectedDoctorId;
  final _roomController = TextEditingController();

  List<Map<String, dynamic>> _departments = [];
  List<Map<String, dynamic>> _levels = [];
  List<Map<String, dynamic>> _courseSubjects = [];
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>>? _rooms;

  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _roomController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      // Load departments
      final departments = await widget.coordinatorService.getAllDepartments();
      _departments = departments
          .map((d) => {
                'id': d.id,
                'name': d.departmentName,
              })
          .toList();

      // Load doctors
      final doctors = await widget.coordinatorService.getAllDoctorAssignments();
      _doctors = doctors
          .map((d) => {
                'id': d.id,
                'name': d.doctor?.fullName ?? 'غير معروف',
              })
          .toList();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadLevels(int departmentId) async {
    try {
      final levels =
          await widget.coordinatorService.getLevelsByDepartment(departmentId);
      setState(() {
        _levels = levels
            .map((l) => {
                  'id': l.id,
                  'name': l.levelName,
                })
            .toList();
        _selectedLevelId = null;
        _selectedCourseSubjectId = null;
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
        _courseSubjects = []; // Clear previous subjects
      });

      for (var course in courses) {
        if (course.courseSubjects != null) {
          setState(() {
            _courseSubjects = course.courseSubjects!
                .map((c) => {
                      'id': c.id,
                      'name': c.subject?.subjectName,
                    })
                .toList();
            _rooms = course.department?.lectureSchedules!.map((c) {
              log(c.toJson().toString());
              return {
                'id': c.id,
                'name': c.room,
              };
            }).toList();
          });
        }
        // if (course.lectureSchedules != null) {
        //   log('messagemessagemessagemessagemessage');
        //   setState(() {
        //     _rooms = course.lectureSchedules?.map((c) {
        //       log(c.toJson().toString());
        //       return {
        //         'id': c.id,
        //         'name': c.room,
        //       };
        //     }).toList();
        //   });
        // }
      }

      // Ensure the selected course subject is still valid
      if (!_courseSubjects.any((cs) => cs['id'] == _selectedCourseSubjectId)) {
        setState(() {
          _selectedCourseSubjectId =
              _courseSubjects.isNotEmpty ? _courseSubjects.first['id'] : 0;
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
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
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
      initialTime: _selectedEndTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDayOfWeek == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('الرجاء اختيار اليوم ووقت البداية والنهاية')),
      );
      return;
    }

    if (_selectedDepartmentId == null ||
        _selectedLevelId == null ||
        _selectedCourseSubjectId == null ||
        _selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار جميع الحقول المطلوبة')),
      );
      return;
    }

    try {
      final schedule = LectureSchedule(
        id: 0,
        courseSubjectId: _selectedCourseSubjectId!,
        departmentId: _selectedDepartmentId!,
        levelId: _selectedLevelId!,
        doctorId: _selectedDoctorId!,
        dayOfWeek: _selectedDayOfWeek!,
        startTime:
            '${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}:00',
        endTime:
            '${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}:00',
        room: _roomController.text,
        isActive: true,
      );

      await widget.coordinatorService.createSchedule(schedule);
      if (mounted) {
        Navigator.pop(context, schedule);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إنشاء الجدول: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة جدول دراسي جديد'),
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
                              _selectedDayOfWeek = value;
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
                                child: Text(
                                  _selectedStartTime == null
                                      ? 'وقت البداية'
                                      : intl.DateFormat('HH:mm').format(
                                          DateTime(
                                              2025,
                                              1,
                                              1,
                                              _selectedStartTime!.hour,
                                              _selectedStartTime!.minute)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextButton(
                                onPressed: () => _selectEndTime(context),
                                child: Text(
                                  _selectedEndTime == null
                                      ? 'وقت النهاية'
                                      : intl.DateFormat('HH:mm').format(
                                          DateTime(
                                              2025,
                                              1,
                                              1,
                                              _selectedEndTime!.hour,
                                              _selectedEndTime!.minute)),
                                ),
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
                                    value: d['id'] as int,
                                    child: Text(d['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartmentId = value;
                            });
                            if (value != null) {
                              _loadLevels(value);
                            }
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
                                    value: l['id'] as int,
                                    child: Text(l['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLevelId = value;
                            });
                            if (value != null) {
                              _loadCourseSubjects(value);
                            }
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
                                    value: cs['id'] as int,
                                    child: Text(cs['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCourseSubjectId = value;
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
                                    value: d['id'] as int,
                                    child: Text(d['name'] as String),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDoctorId = value;
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
                        // TextFormField(
                        //   controller: _roomController,
                        //   decoration: const InputDecoration(
                        //     labelText: 'القاعة',
                        //   ),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'الرجاء إدخال اسم القاعة';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        DropdownButtonFormField<int>(
                          value: int.parse(_roomController.text.isEmpty
                              ? '0'
                              : _roomController.text),
                          decoration: const InputDecoration(
                            labelText: 'القاعة الدراسية',
                          ),
                          items: _rooms
                              !.map((d) => DropdownMenuItem(
                                    value: (d['id'] as int),
                                    child: Text(d['name'] ?? 'غير معروف'),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _roomController.text = value.toString();
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار اسم القاعة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
          child: const Text('إضافة'),
        ),
      ],
    );
  }
}
