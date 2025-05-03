import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

import '../../../../core/models/level.dart';
import '../../../departments/domain/models/department_model.dart';

class StudentsManagementScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const StudentsManagementScreen({
    Key? key,
    required this.coordinatorService,
  }) : super(key: key);

  @override
  State<StudentsManagementScreen> createState() =>
      _StudentsManagementScreenState();
}

class _StudentsManagementScreenState extends State<StudentsManagementScreen> {
  List<Student> _students = [];
  bool _showActiveOnly = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final students = _showActiveOnly
          ? await widget.coordinatorService.getActivestudent()
          : await widget.coordinatorService.getAllstudent();
      setState(() {
        _students = students;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل بيانات الطلاب';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddStudentDialog() async {
    final result = await showDialog<Student>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة طالب جديد'),
        content: const AddStudentForm(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement student creation
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null) {
      await _loadStudents();
    }
  }

  Future<void> _showEditStudentDialog(Student student) async {
    final result = await showDialog<Student>(
      context: context,
      builder: (context) => EditStudentForm(
        student: student,
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadStudents();
    }
  }

  Future<void> _toggleStudentStatus(int id) async {
    try {
      await widget.coordinatorService.togglestudenttatus(id);
      await _loadStudents();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير حالة الطالب بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تغيير حالة الطالب')),
      );
    }
  }

  Future<void> _showStudentDetails(Student student) async {
    try {
      final detailedStudent =
          await widget.coordinatorService.getStudentWithUser(student.id!);
      final attendances =
          await widget.coordinatorService.getStudentAttendances(student.id!);
      final schedules =
          await widget.coordinatorService.getstudentchedules(student.id!);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تفاصيل الطالب'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('الاسم: ${detailedStudent.user?.fullName}'),
                Text('البريد الإلكتروني: ${detailedStudent.user?.email}'),
                Text('القسم: ${detailedStudent.department?.departmentName}'),
                Text('المستوى: ${detailedStudent.level?.levelName}'),
                const SizedBox(height: 16),
                const Text('سجلات الحضور:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...attendances.map((attendance) => ListTile(
                      title: Text(
                          '${attendance.lectureSchedule?.courseSubject?.subject?.subjectName}'),
                      subtitle: Text('${attendance.attendanceDate}'),
                      trailing: Icon(
                        attendance.status == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: attendance.status == true
                            ? Colors.green
                            : Colors.red,
                      ),
                    )),
                const SizedBox(height: 16),
                const Text('جدول المحاضرات:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...schedules.map((schedule) => ListTile(
                      title: Text(
                          '${schedule.courseSubject?.subject?.subjectName}'),
                      subtitle:
                          Text('${schedule.startTime} - ${schedule.endTime}'),
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إغلاق'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل تفاصيل الطالب')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلاب'),
        actions: [
          IconButton(
            icon:
                Icon(_showActiveOnly ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _loadStudents();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشطين فقط',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _students.isEmpty
                  ? const Center(child: Text('لا يوجد طلاب'))
                  : _buildStudentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStudentList() {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        final student = _students[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(student.user?.fullName ?? ''),
            subtitle: Text(
                '${student.level?.levelName} - ${student.department?.departmentName}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/student-attendance',
                      arguments: {'studentId': student.id},
                    );
                  },
                  tooltip: 'عرض سجلات الحضور',
                ),
                IconButton(
                  icon: Icon(
                    student.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: student.isActive ? Colors.green : Colors.red,
                  ),
                  onPressed: () => _toggleStudentStatus(student.id!),
                  tooltip: student.isActive ? 'تعطيل' : 'تفعيل',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditStudentDialog(student),
                  tooltip: 'تعديل',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({Key? key}) : super(key: key);

  @override
  State<AddStudentForm> createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentIdController = TextEditingController();
  final _levelIdController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentIdController.dispose();
    _levelIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'البريد الإلكتروني',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال البريد الإلكتروني';
                }
                return null;
              },
            ),
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
                return null;
              },
            ),
            TextFormField(
              controller: _departmentIdController,
              decoration: const InputDecoration(
                labelText: 'معرف القسم',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال معرف القسم';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _levelIdController,
              decoration: const InputDecoration(
                labelText: 'معرف المستوى',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال معرف المستوى';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditStudentForm extends StatefulWidget {
  final Student student;
  final CoordinatorService coordinatorService;

  const EditStudentForm({
    super.key,
    required this.student,
    required this.coordinatorService,
  });

  @override
  State<EditStudentForm> createState() => _EditStudentFormState();
}

class _EditStudentFormState extends State<EditStudentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _enrollmentYearController;
  late Student _currentStudent;
  List<Department> _departments = [];
  List<Level> _levels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentStudent = Student(
      isActive: widget.student.isActive,
      id: widget.student.id,
      userId: widget.student.userId,
      departmentId: widget.student.departmentId,
      levelId: widget.student.levelId,
      enrollmentYear: widget.student.enrollmentYear,
    );
    _nameController =
        TextEditingController(text: widget.student.user?.fullName ?? '');
    _enrollmentYearController =
        TextEditingController(text: widget.student.enrollmentYear.toString());
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final departments =
          await widget.coordinatorService.getActiveDepartments();
      final levels = await widget.coordinatorService
          .getLevelsByDepartment(_currentStudent.departmentId);
      setState(() {
        _departments = departments;
        _levels = levels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل البيانات')),
      );
    }
  }

  Future<void> _loadLevels(int departmentId) async {
    try {
      final levels =
          await widget.coordinatorService.getLevelsByDepartment(departmentId);
      setState(() {
        _levels = levels;
        _currentStudent = Student(
          id: _currentStudent.id,
          userId: _currentStudent.userId,
          departmentId: departmentId,
          isActive: _currentStudent.isActive,
          levelId: levels.first.id ?? 0, // Reset level when department changes
          enrollmentYear: _currentStudent.enrollmentYear,
        );
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل المستويات')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _enrollmentYearController.dispose();
    super.dispose();
  }

  Student getUpdatedStudent() {
    return Student(
      id: _currentStudent.id,
      userId: _currentStudent.userId,
      departmentId: _currentStudent.departmentId,
      levelId: _currentStudent.levelId,
      enrollmentYear: int.tryParse(_enrollmentYearController.text) ??
          _currentStudent.enrollmentYear,
      isActive: _currentStudent.isActive,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تعديل بيانات الطالب',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم الطالب',
                      border: OutlineInputBorder(),
                    ),
                    enabled:
                        false, // Name is read-only as it comes from user profile
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'اختر القسم',
                        border: OutlineInputBorder(),
                      ),
                      value: _currentStudent.departmentId,
                      items: _departments.map((department) {
                        return DropdownMenuItem<int>(
                          value: department.id,
                          child: Text(department.departmentName ?? ''),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'الرجاء اختيار القسم';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value != null) {
                          _loadLevels(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'اختر المستوى',
                        border: OutlineInputBorder(),
                      ),
                      value: _currentStudent.levelId,
                      items: _levels.map((level) {
                        return DropdownMenuItem<int>(
                          value: level.id,
                          child: Text(level.levelName),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'الرجاء اختيار المستوى';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          _currentStudent = Student(
                            id: _currentStudent.id,
                            userId: _currentStudent.userId,
                            departmentId: _currentStudent.departmentId,
                            levelId: value ?? 0,
                            enrollmentYear: _currentStudent.enrollmentYear,
                            isActive: _currentStudent.isActive,
                          );
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _enrollmentYearController,
                      decoration: const InputDecoration(
                        labelText: 'سنة التسجيل',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'الرجاء إدخال سنة التسجيل';
                        }
                        final year = int.tryParse(value);
                        if (year == null) {
                          return 'الرجاء إدخال رقم صحيح';
                        }
                        if (year < 2000 || year > DateTime.now().year) {
                          return 'الرجاء إدخال سنة صحيحة';
                        }
                        return null;
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final updatedStudent = getUpdatedStudent();
                        await widget.coordinatorService
                            .updateStudent(updatedStudent);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تعديل بيانات الطالب بنجاح'),
                          ),
                        );
                        Navigator.pop(context, updatedStudent);
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('فشل في تعديل بيانات الطالب'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
