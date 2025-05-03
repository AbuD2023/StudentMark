import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class LevelsManagementScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const LevelsManagementScreen({
    super.key,
    required this.coordinatorService,
  });

  @override
  State<LevelsManagementScreen> createState() => _LevelsManagementScreenState();
}

class _LevelsManagementScreenState extends State<LevelsManagementScreen> {
  List<Level> _levels = [];
  bool _showActiveOnly = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final levels = _showActiveOnly
          ? await widget.coordinatorService.getActiveLevels()
          : await widget.coordinatorService.getAllLevels();
      setState(() {
        _levels = levels;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل بيانات المستويات';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddLevelDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    int? selectedDepartmentId;
    List<Department> departments = [];

    // جلب الأقسام النشطة
    try {
      departments = await widget.coordinatorService.getActiveDepartments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل الأقسام')),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة مستوى جديد'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم المستوى',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم المستوى';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(
                    labelText: 'اختر القسم',
                    border: OutlineInputBorder(),
                  ),
                  value: selectedDepartmentId,
                  items: departments.map((department) {
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
                    selectedDepartmentId = value;
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
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  final level = Level(
                    levelName: nameController.text,
                    isActive: true,
                    departmentId: selectedDepartmentId!,
                  );
                  await widget.coordinatorService.createLevel(level);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة المستوى بنجاح')),
                  );
                  Navigator.pop(context, level.toJson());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('فشل في إضافة المستوى')),
                  );
                }
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (result != null) {
      await _loadLevels();
    }
  }

  Future<void> _showEditLevelDialog(Level level) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditLevelDialog(
        level: level,
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadLevels();
    }
  }

  Future<void> _toggleLevelStatus(int id) async {
    try {
      await widget.coordinatorService.toggleLevelStatus(id);
      await _loadLevels();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير حالة المستوى بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تغيير حالة المستوى')),
      );
    }
  }

  Future<void> _showLevelDetails(Level level) async {
    try {
      final detailedLevel =
          await widget.coordinatorService.getLevelById(level.id!);
      final courses =
          await widget.coordinatorService.getLevelCourses(level.id!);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.class_, color: Colors.blue),
              SizedBox(width: 8),
              Text('تفاصيل المستوى'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                  'اسم المستوى',
                  detailedLevel.levelName,
                  Icons.label,
                ),
                const SizedBox(height: 16),
                const Text(
                  'المواد',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  courses.length,
                  (index) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.book),
                      title: Text(courses[index].courseName),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: courses[index].isActive == true
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          courses[index].isActive == true ? 'نشط' : 'غير نشط',
                          style: TextStyle(
                            color: courses[index].isActive == true
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
        const SnackBar(content: Text('فشل في تحميل تفاصيل المستوى')),
      );
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستويات'),
        actions: [
          IconButton(
            icon:
                Icon(_showActiveOnly ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _loadLevels();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشطين فقط',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _levels.isEmpty
                  ? const Center(child: Text('لا توجد مستويات'))
                  : _buildLevelList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLevelDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildLevelList() {
    return ListView.builder(
      itemCount: _levels.length,
      itemBuilder: (context, index) {
        final level = _levels[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.levelName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            level.department?.departmentName ?? 'لا يوجد',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: level.isActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        level.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color: level.isActive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline),
                      onPressed: () => _showLevelDetails(level),
                      tooltip: 'تفاصيل',
                      color: Colors.blue,
                    ),
                    IconButton(
                      icon: Icon(
                        level.isActive ? Icons.toggle_on : Icons.toggle_off,
                        color: level.isActive ? Colors.green : Colors.red,
                      ),
                      onPressed: () => _toggleLevelStatus(level.id!),
                      tooltip: level.isActive ? 'تعطيل' : 'تفعيل',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditLevelDialog(level),
                      tooltip: 'تعديل',
                      color: Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class EditLevelDialog extends StatefulWidget {
  final Level level;
  final CoordinatorService coordinatorService;

  const EditLevelDialog({
    super.key,
    required this.level,
    required this.coordinatorService,
  });

  @override
  State<EditLevelDialog> createState() => _EditLevelDialogState();
}

class _EditLevelDialogState extends State<EditLevelDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late Level _currentLevel;
  List<Department> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _currentLevel = Level(
      id: widget.level.id,
      levelName: widget.level.levelName,
      isActive: widget.level.isActive,
      departmentId: widget.level.departmentId,
    );
    _nameController = TextEditingController(text: _currentLevel.levelName);
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final departments =
          await widget.coordinatorService.getActiveDepartments();
      setState(() {
        _departments = departments;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحميل الأقسام')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Level getUpdatedLevel() {
    return Level(
      id: _currentLevel.id,
      levelName: _nameController.text,
      isActive: _currentLevel.isActive,
      departmentId: _currentLevel.departmentId,
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
              'تعديل بيانات المستوى',
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
                      labelText: 'اسم المستوى',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المستوى';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'اختر القسم',
                        border: OutlineInputBorder(),
                      ),
                      value: _currentLevel.departmentId,
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
                        setState(() {
                          _currentLevel = Level(
                            id: _currentLevel.id,
                            levelName: _currentLevel.levelName,
                            isActive: _currentLevel.isActive,
                            departmentId: value!,
                          );
                        });
                      },
                    ),
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
                        final updatedLevel = getUpdatedLevel();
                        await widget.coordinatorService
                            .updateLevel(updatedLevel);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تعديل بيانات المستوى بنجاح'),
                          ),
                        );
                        Navigator.pop(context, updatedLevel.toJson());
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('فشل في تعديل بيانات المستوى'),
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
