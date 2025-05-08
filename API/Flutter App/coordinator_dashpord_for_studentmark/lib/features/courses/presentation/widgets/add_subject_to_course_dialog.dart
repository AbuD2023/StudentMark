import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course_subject.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class AddSubjectToCourseDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;
  final Course course;
  final CourseSubject? existingSubject;

  const AddSubjectToCourseDialog({
    super.key,
    required this.coordinatorService,
    required this.course,
    this.existingSubject,
  });

  @override
  State<AddSubjectToCourseDialog> createState() =>
      _AddSubjectToCourseDialogState();
}

class _AddSubjectToCourseDialogState extends State<AddSubjectToCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  Subject? _selectedSubject;
  Level? _selectedLevel;
  List<Subject> _subjects = [];
  List<Level> _levels = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final subjects = await widget.coordinatorService.getAllSubjects();
      final levels = await widget.coordinatorService.getAllLevels();
      setState(() {
        _subjects = subjects;
        _levels = levels;
        if (widget.existingSubject != null) {
          _selectedSubject = _subjects.firstWhere(
            (s) => s.id == widget.existingSubject!.subjectId,
            orElse: () => widget.existingSubject!.subject!,
          );
          _selectedLevel = _levels.firstWhere(
            (l) => l.id == widget.existingSubject!.levelId,
            orElse: () => widget.existingSubject!.level!,
          );
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSubject == null || _selectedLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار المادة والمستوى')),
      );
      return;
    }

    try {
      if (widget.existingSubject != null) {
        // Update existing subject
        final updatedSubject = widget.existingSubject!.copyWith(
          subjectId: _selectedSubject!.id,
          levelId: _selectedLevel!.id,
          subject: _selectedSubject,
          level: _selectedLevel,
        );
        await widget.coordinatorService.updateCourseSubject(updatedSubject);
        if (mounted) {
          Navigator.pop(context, updatedSubject);
        }
      } else {
        // Create new subject
        final courseSubject = CourseSubject(
          id: 0,
          courseId: widget.course.id,
          subjectId: _selectedSubject!.id,
          levelId: _selectedLevel?.id ?? 0,
          isActive: true,
          course: widget.course,
          subject: _selectedSubject,
          level: _selectedLevel,
        );
        await widget.coordinatorService.createCourseSubject(courseSubject);
        if (mounted) {
          Navigator.pop(context, courseSubject);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.existingSubject != null
          ? 'تعديل المادة'
          : 'إضافة مادة إلى المقرر'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<Subject>(
                          value: _selectedSubject,
                          decoration: const InputDecoration(
                            labelText: 'المادة',
                          ),
                          items: _subjects.map((subject) {
                            return DropdownMenuItem(
                              value: subject,
                              child: Text(
                                  '${subject.subjectName} - ${subject.description!}'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedSubject = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار المادة';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<Level>(
                          value: _selectedLevel,
                          decoration: const InputDecoration(
                            labelText: 'المستوى',
                          ),
                          items: _levels.map((level) {
                            return DropdownMenuItem(
                              value: level,
                              child: Text(level.levelName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedLevel = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار المستوى';
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
          child: Text(widget.existingSubject != null ? 'تحديث' : 'إضافة'),
        ),
      ],
    );
  }
}
