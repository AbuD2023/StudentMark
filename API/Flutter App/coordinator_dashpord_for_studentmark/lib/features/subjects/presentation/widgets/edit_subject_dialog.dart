import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class EditSubjectDialog extends StatefulWidget {
  final Subject subject;
  final CoordinatorService coordinatorService;

  const EditSubjectDialog({
    Key? key,
    required this.subject,
    required this.coordinatorService,
  }) : super(key: key);

  @override
  State<EditSubjectDialog> createState() => _EditSubjectDialogState();
}

class _EditSubjectDialogState extends State<EditSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _subjectNameController;
  late final TextEditingController _descriptionController;
  late Subject _currentSubject;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentSubject = Subject(
      id: widget.subject.id,
      subjectName: widget.subject.subjectName,
      description: widget.subject.description,
      isActive: widget.subject.isActive,
    );
    _subjectNameController =
        TextEditingController(text: _currentSubject.subjectName);
    _descriptionController =
        TextEditingController(text: _currentSubject.description);
  }

  @override
  void dispose() {
    _subjectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateSubject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedSubject = Subject(
        id: _currentSubject.id,
        subjectName: _subjectNameController.text,
        description: _descriptionController.text,
        isActive: _currentSubject.isActive,
      );

      await widget.coordinatorService.updateSubject(updatedSubject);
      if (!mounted) return;
      Navigator.pop(context, updatedSubject);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحديث بيانات المادة الدراسية')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
              'تعديل بيانات المادة الدراسية',
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
                    controller: _subjectNameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المادة',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المادة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'وصف المادة',
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
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _isLoading ? null : _updateSubject,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Text('حفظ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
