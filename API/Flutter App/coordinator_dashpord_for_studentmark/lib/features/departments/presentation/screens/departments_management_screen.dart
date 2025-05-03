import 'package:coordinator_dashpord_for_studentmark/features/departments/domain/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class DepartmentsManagementScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const DepartmentsManagementScreen({
    super.key,
    required this.coordinatorService,
  });

  @override
  State<DepartmentsManagementScreen> createState() =>
      _DepartmentsManagementScreenState();
}

class _DepartmentsManagementScreenState
    extends State<DepartmentsManagementScreen> {
  List<Department> _departments = [];
  bool _showActiveOnly = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final departments = _showActiveOnly
          ? await widget.coordinatorService.getActiveDepartments()
          : await widget.coordinatorService.getAllDepartments();
      setState(() {
        _departments = departments;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل بيانات الأقسام';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddDepartmentDialog() async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة قسم جديد'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'اسم القسم',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء إدخال اسم القسم';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'الوصف',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                  final department = Department(
                    departmentName: nameController.text,
                    description: descriptionController.text,
                    isActive: true,
                  );
                  await widget.coordinatorService.createDepartment(department);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة القسم بنجاح')),
                  );
                  Navigator.pop(context, department.toJson());
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('فشل في إضافة القسم')),
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
      await _loadDepartments();
    }
  }

  Future<void> _showEditDepartmentDialog(Department department) async {
    final result = await showDialog<Department>(
      context: context,
      builder: (context) => EditDepartmentForm(
        department: department,
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadDepartments();
    }
  }

  Future<void> _toggleDepartmentStatus(int id) async {
    try {
      await widget.coordinatorService.toggleDepartmentStatus(id);
      await _loadDepartments();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير حالة القسم بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تغيير حالة القسم')),
      );
    }
  }

  Future<void> _showDepartmentDetails(Department department) async {
    try {
      final detailedDepartment =
          await widget.coordinatorService.getDepartmentById(department.id!);
      final levels = await widget.coordinatorService
          .getDepartmentWithLevels(department.id!);

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.school, color: Colors.blue),
              const SizedBox(width: 8),
              const Text('تفاصيل القسم'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow(
                  'اسم القسم',
                  detailedDepartment.departmentName,
                  Icons.label,
                ),
                if (detailedDepartment.description != null &&
                    detailedDepartment.description!.isNotEmpty)
                  _buildDetailRow(
                    'الوصف',
                    detailedDepartment.description!,
                    Icons.description,
                  ),
                const SizedBox(height: 16),
                const Text(
                  'المستويات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  levels.levels!.length,
                  (index) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.class_),
                      title: Text(levels.levels![index].levelName),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: levels.levels![index].isActive == true
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          levels.levels![index].isActive == true
                              ? 'نشط'
                              : 'غير نشط',
                          style: TextStyle(
                            color: levels.levels![index].isActive == true
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
        const SnackBar(content: Text('فشل في تحميل تفاصيل القسم')),
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
        title: const Text('إدارة الأقسام'),
        actions: [
          IconButton(
            icon:
                Icon(_showActiveOnly ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _loadDepartments();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشطين فقط',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _departments.isEmpty
                  ? const Center(child: Text('لا توجد أقسام'))
                  : _buildDepartmentList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDepartmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDepartmentList() {
    return ListView.builder(
      itemCount: _departments.length,
      itemBuilder: (context, index) {
        final department = _departments[index];
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
                            department.departmentName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (department.description != null &&
                              department.description!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                department.description!,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
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
                        color: department.isActive
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        department.isActive ? 'نشط' : 'غير نشط',
                        style: TextStyle(
                          color:
                              department.isActive ? Colors.green : Colors.red,
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
                      onPressed: () => _showDepartmentDetails(department),
                      tooltip: 'تفاصيل',
                      color: Colors.blue,
                    ),
                    IconButton(
                      icon: Icon(
                        department.isActive
                            ? Icons.toggle_on
                            : Icons.toggle_off,
                        color: department.isActive ? Colors.green : Colors.red,
                      ),
                      onPressed: () => _toggleDepartmentStatus(department.id!),
                      tooltip: department.isActive ? 'تعطيل' : 'تفعيل',
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditDepartmentDialog(department),
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

class AddDepartmentForm extends StatefulWidget {
  const AddDepartmentForm({super.key});

  @override
  State<AddDepartmentForm> createState() => _AddDepartmentFormState();
}

class _AddDepartmentFormState extends State<AddDepartmentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
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
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'اسم القسم',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'الرجاء إدخال اسم القسم';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'الوصف',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class EditDepartmentForm extends StatefulWidget {
  final Department department;
  final CoordinatorService coordinatorService;

  const EditDepartmentForm({
    super.key,
    required this.department,
    required this.coordinatorService,
  });

  @override
  State<EditDepartmentForm> createState() => _EditDepartmentFormState();
}

class _EditDepartmentFormState extends State<EditDepartmentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late Department _currentDepartment;

  @override
  void initState() {
    super.initState();
    _currentDepartment = Department(
      id: widget.department.id,
      departmentName: widget.department.departmentName,
      description: widget.department.description,
      isActive: widget.department.isActive,
    );
    _nameController =
        TextEditingController(text: _currentDepartment.departmentName);
    _descriptionController =
        TextEditingController(text: _currentDepartment.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Department getUpdatedDepartment() {
    return Department(
      id: _currentDepartment.id,
      departmentName: _nameController.text,
      description: _descriptionController.text,
      isActive: _currentDepartment.isActive,
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
              'تعديل بيانات القسم',
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
                      labelText: 'اسم القسم',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم القسم';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'الوصف',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
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
                        final updatedDepartment = getUpdatedDepartment();
                        await widget.coordinatorService
                            .updateDepartment(updatedDepartment);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم تعديل بيانات القسم بنجاح'),
                          ),
                        );
                        Navigator.pop(context, updatedDepartment);
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('فشل في تعديل بيانات القسم'),
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
