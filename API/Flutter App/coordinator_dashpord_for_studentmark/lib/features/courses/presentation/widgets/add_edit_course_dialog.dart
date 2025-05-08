import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';

class AddEditCourseDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;
  final Course? course;

  const AddEditCourseDialog({
    super.key,
    required this.coordinatorService,
    this.course,
  });

  @override
  State<AddEditCourseDialog> createState() => _AddEditCourseDialogState();
}

class _AddEditCourseDialogState extends State<AddEditCourseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int? _selectedDepartmentId;
  List<Department> _departments = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.course != null) {
      _courseNameController.text = widget.course!.courseName;
      _descriptionController.text = widget.course!.description ?? '';
      _selectedDepartmentId = widget.course!.departmentId;
    }
    _loadDepartments();
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadDepartments() async {
    try {
      final departments = await widget.coordinatorService.getAllDepartments();
      setState(() {
        _departments = departments;
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

    if (_selectedDepartmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار القسم')),
      );
      return;
    }

    try {
      final course = Course(
        id: widget.course?.id ?? 0,
        courseName: _courseNameController.text,
        description: _descriptionController.text.isEmpty
            ? null
            : _descriptionController.text,
        departmentId: _selectedDepartmentId!,
        isActive: widget.course?.isActive ?? true,
      );

      if (widget.course == null) {
        await widget.coordinatorService.createCourse(course);
      } else {
        await widget.coordinatorService.updateCourse(course);
      }

      if (mounted) {
        Navigator.pop(context, course);
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
      title: Text(widget.course == null ? 'إضافة مقرر' : 'تعديل المقرر'),
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
                        TextFormField(
                          controller: _courseNameController,
                          decoration: const InputDecoration(
                            labelText: 'اسم المقرر',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء إدخال اسم المقرر';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            labelText: 'الوصف',
                          ),
                          maxLines: 3,
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
                          validator: (value) {
                            if (value == null) {
                              return 'الرجاء اختيار القسم';
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
