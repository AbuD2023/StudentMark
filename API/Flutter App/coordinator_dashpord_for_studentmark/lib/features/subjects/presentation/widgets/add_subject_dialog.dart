import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class AddSubjectDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const AddSubjectDialog({
    Key? key,
    required this.coordinatorService,
  }) : super(key: key);

  @override
  State<AddSubjectDialog> createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _subjectNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _subjectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _createSubject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final subject = Subject(
        id: 0,
        subjectName: _subjectNameController.text,
        description: _descriptionController.text,
        isActive: true,
      );

      await widget.coordinatorService.createSubject(subject);
      if (!mounted) return;
      Navigator.pop(context, subject);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إنشاء المادة الدراسية')),
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
              'إضافة مادة دراسية جديدة',
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
                  onPressed: _isLoading ? null : _createSubject,
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
