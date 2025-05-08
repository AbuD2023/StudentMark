import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/courses/presentation/widgets/add_subject_to_course_dialog.dart';

import '../../../../core/models/course_subject.dart';

class CourseDetailsDialog extends StatefulWidget {
  final CoordinatorService coordinatorService;
  final Course course;

  const CourseDetailsDialog({
    super.key,
    required this.coordinatorService,
    required this.course,
  });

  @override
  State<CourseDetailsDialog> createState() => _CourseDetailsDialogState();
}

class _CourseDetailsDialogState extends State<CourseDetailsDialog> {
  Course? _course;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourseDetails();
  }

  Future<void> _loadCourseDetails() async {
    try {
      final course = await widget.coordinatorService
          .getCourseWithSubjects(widget.course.id);
      setState(() {
        _course = course;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddSubjectDialog() async {
    final result = await showDialog<CourseSubject>(
      context: context,
      builder: (context) => AddSubjectToCourseDialog(
        coordinatorService: widget.coordinatorService,
        course: _course ?? widget.course,
      ),
    );

    if (result != null) {
      _loadCourseDetails();
    }
  }

  Future<void> _showEditSubjectDialog(CourseSubject subject) async {
    final result = await showDialog<CourseSubject>(
      context: context,
      builder: (context) => AddSubjectToCourseDialog(
        coordinatorService: widget.coordinatorService,
        course: _course ?? widget.course,
        existingSubject: subject,
      ),
    );

    if (result != null) {
      _loadCourseDetails();
    }
  }

  Future<void> _showDeleteSubjectDialog(CourseSubject subject) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المادة'),
        content:
            Text('هل أنت متأكد من حذف المادة ${subject.subject?.subjectName}؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await widget.coordinatorService.deleteCourseSubject(subject.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم حذف المادة بنجاح')),
          );
          _loadCourseDetails();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = _course ?? widget.course;

    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('تفاصيل المقرر'),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddSubjectDialog,
            tooltip: 'إضافة مادة',
          ),
        ],
      ),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoRow('اسم المقرر', course.courseName),
                      if (course.description != null)
                        _buildInfoRow('الوصف', course.description!),
                      _buildInfoRow(
                          'القسم', course.department?.departmentName ?? ''),
                      // _buildInfoRow(
                      //     'المستوى', course.courseSubjects?.level?.levelName ?? ''),
                      _buildInfoRow(
                          'الحالة', course.isActive ? 'نشط' : 'غير نشط'),
                      const SizedBox(height: 16),
                      const Text(
                        'المواد الدراسية',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (course.courseSubjects?.isEmpty ?? true)
                        const Text('لا توجد مواد دراسية')
                      else
                        ...course.courseSubjects!.map((subject) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.book, size: 16),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(subject.subject?.subjectName ??
                                      'غير معرف'),
                                ),
                                Text(
                                  ' - ${subject.level?.levelName}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 16),
                                  onPressed: () =>
                                      _showEditSubjectDialog(subject),
                                  tooltip: 'تعديل',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, size: 16),
                                  onPressed: () =>
                                      _showDeleteSubjectDialog(subject),
                                  tooltip: 'حذف',
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Text(': '),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
