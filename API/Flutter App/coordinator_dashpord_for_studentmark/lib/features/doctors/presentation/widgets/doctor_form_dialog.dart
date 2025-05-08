import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/presentation/providers/doctor_provider.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';

class DoctorFormDialog extends StatefulWidget {
  final Doctor? doctor;

  const DoctorFormDialog({super.key, this.doctor});

  @override
  State<DoctorFormDialog> createState() => _DoctorFormDialogState();
}

class _DoctorFormDialogState extends State<DoctorFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late int _selectedDoctorId;
  late int _selectedDepartmentId;
  late int _selectedLevelId;
  List<User> _doctorUsers = [];
  List<Department> _departments = [];
  List<Level> _levels = [];
  bool _isLoading = true;
  bool _isNewDoctor = false;

  // New doctor form fields
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.doctor != null) {
      _selectedDoctorId = widget.doctor!.doctorId;
      _selectedDepartmentId = widget.doctor!.departmentId;
      _selectedLevelId = widget.doctor!.levelId;
    } else {
      _selectedDoctorId = 0;
      _selectedDepartmentId = 0;
      _selectedLevelId = 0;
    }
  }

  Future<void> _loadData() async {
    try {
      await Future.wait([
        context.read<DoctorProvider>().getAllDoctorUsers(),
        context.read<DoctorProvider>().getAllDepartments(),
      ]);

      setState(() {
        _doctorUsers = context.read<DoctorProvider>().doctorUsers;
        _departments = context.read<DoctorProvider>().departments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل البيانات: $e')),
        );
      }
    }
  }

  Future<void> _loadLevelsByDepartment(int departmentId) async {
    try {
      final levels = await context
          .read<DoctorProvider>()
          .getLevelsByDepartment(departmentId);
      setState(() {
        _levels = levels;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تحميل المستويات: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.doctor == null ? 'إضافة دكتور' : 'تعديل الدكتور'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SwitchListTile(
                      title: const Text('إضافة دكتور جديد'),
                      value: _isNewDoctor,
                      onChanged: (value) {
                        setState(() {
                          _isNewDoctor = value;
                        });
                      },
                    ),
                    if (!_isNewDoctor) ...[
                      DropdownButtonFormField<int>(
                        value:
                            _selectedDoctorId == 0 ? null : _selectedDoctorId,
                        decoration: const InputDecoration(
                          labelText: 'الدكتور',
                        ),
                        items: _doctorUsers
                            .map((user) => DropdownMenuItem(
                                  value: user.id,
                                  child: Text(user.fullName ?? ''),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedDoctorId = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null || value == 0) {
                            return 'الرجاء اختيار الدكتور';
                          }
                          return null;
                        },
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'الاسم الكامل',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الاسم الكامل';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'البريد الإلكتروني',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال البريد الإلكتروني';
                          }
                          if (!value.contains('@')) {
                            return 'الرجاء إدخال بريد إلكتروني صحيح';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: 'اسم المستخدم',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال اسم المستخدم';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'كلمة المرور',
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال كلمة المرور';
                          }
                          if (value.length < 6) {
                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedDepartmentId == 0
                          ? null
                          : _selectedDepartmentId,
                      decoration: const InputDecoration(
                        labelText: 'القسم',
                      ),
                      items: _departments
                          .map((dept) => DropdownMenuItem(
                                value: dept.id,
                                child: Text(dept.departmentName),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedDepartmentId = value;
                            _selectedLevelId = 0;
                            _levels = [];
                          });
                          _loadLevelsByDepartment(value);
                        }
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
                          return 'الرجاء اختيار القسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedLevelId == 0 ? null : _selectedLevelId,
                      decoration: const InputDecoration(
                        labelText: 'المستوى',
                      ),
                      items: _levels
                          .map((level) => DropdownMenuItem(
                                value: level.id,
                                child: Text(level.levelName),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedLevelId = value;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null || value == 0) {
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
          onPressed: () => Navigator.pop(context, false),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_isNewDoctor) {
          // Create new doctor user
          final newDoctor = User(
            // id: 0,
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text,
            fullName: _fullNameController.text,
            roleId: 2, // Doctor role
          );

          final createdDoctor =
              await context.read<DoctorProvider>().createDoctorUser(newDoctor);
          var ff = createdDoctor.split(',');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('نجحت العملية: ${ff[0]}')),
          );
          _selectedDoctorId = int.parse(ff[1].toString());
          // _selectedDoctorId = widget.doctor!.doctorId;
        }

        final doctor = Doctor(
          id: widget.doctor?.id ?? 0,
          doctorId: _selectedDoctorId,
          departmentId: _selectedDepartmentId,
          levelId: _selectedLevelId,
          isActive: widget.doctor?.isActive ?? true,
        );

        if (widget.doctor == null) {
          await context.read<DoctorProvider>().createDoctorAssignment(doctor);
        } else {
          await context.read<DoctorProvider>().updateDoctorAssignment(doctor);
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
