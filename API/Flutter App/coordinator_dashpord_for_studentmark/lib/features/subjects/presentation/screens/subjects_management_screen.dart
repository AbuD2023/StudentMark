import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

import '../widgets/add_subject_dialog.dart';
import '../widgets/edit_subject_dialog.dart';

class SubjectsManagementScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const SubjectsManagementScreen({
    Key? key,
    required this.coordinatorService,
  }) : super(key: key);

  @override
  State<SubjectsManagementScreen> createState() =>
      _SubjectsManagementScreenState();
}

class _SubjectsManagementScreenState extends State<SubjectsManagementScreen> {
  List<Subject> _subjects = [];
  bool _showActiveOnly = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final subjects = _showActiveOnly
          ? await widget.coordinatorService.getActiveSubjects()
          : await widget.coordinatorService.getAllSubjects();

      setState(() {
        _subjects = subjects;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل بيانات المواد الدراسية';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddSubjectDialog() async {
    final result = await showDialog<Subject>(
      context: context,
      builder: (context) => AddSubjectDialog(
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadSubjects();
    }
  }

  Future<void> _showEditSubjectDialog(Subject subject) async {
    final result = await showDialog<Subject>(
      context: context,
      builder: (context) => EditSubjectDialog(
        subject: subject,
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadSubjects();
    }
  }

  Future<void> _toggleSubjectStatus(int id) async {
    try {
      await widget.coordinatorService.toggleSubjectStatus(id);
      await _loadSubjects();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير حالة المادة الدراسية بنجاح')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تغيير حالة المادة الدراسية')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المواد الدراسية'),
        actions: [
          // زر عرض/إخفاء المواد غير النشطة
          IconButton(
            icon:
                Icon(_showActiveOnly ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _loadSubjects();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشطة فقط',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _subjects.isEmpty
                  ? const Center(child: Text('لا توجد مواد دراسية'))
                  : _buildSubjectsList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSubjectsList() {
    return ListView.builder(
      itemCount: _subjects.length,
      itemBuilder: (context, index) {
        final subject = _subjects[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(subject.subjectName[0]),
            ),
            title: Text(subject.subjectName),
            subtitle: Text(subject.description ?? ''),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    subject.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: subject.isActive ? Colors.green : Colors.red,
                  ),
                  onPressed: () => _toggleSubjectStatus(subject.id),
                  tooltip: subject.isActive ? 'تعطيل' : 'تفعيل',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditSubjectDialog(subject),
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
