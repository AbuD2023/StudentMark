import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/courses/presentation/widgets/add_edit_course_dialog.dart';
import 'package:coordinator_dashpord_for_studentmark/features/courses/presentation/widgets/course_details_dialog.dart';

class CoursesPage extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const CoursesPage({super.key, required this.coordinatorService});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  List<Course> _courses = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final courses = await widget.coordinatorService.getAllCourses();
      setState(() {
        _courses = courses;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddCourseDialog() async {
    final result = await showDialog<Course>(
      context: context,
      builder: (context) => AddEditCourseDialog(
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      _loadCourses();
    }
  }

  Future<void> _showEditCourseDialog(Course course) async {
    final result = await showDialog<Course>(
      context: context,
      builder: (context) => AddEditCourseDialog(
        coordinatorService: widget.coordinatorService,
        course: course,
      ),
    );

    if (result != null) {
      _loadCourses();
    }
  }

  Future<void> _showCourseDetails(Course course) async {
    await showDialog(
      context: context,
      builder: (context) => CourseDetailsDialog(
        coordinatorService: widget.coordinatorService,
        course: course,
      ),
    );
  }

  Future<void> _toggleCourseStatus(Course course) async {
    try {
      await widget.coordinatorService.toggleCourseStatus(course.id);
      _loadCourses();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _deleteCourse(Course course) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف المقرر'),
        content: Text('هل أنت متأكد من حذف المقرر ${course.courseName}؟'),
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
        await widget.coordinatorService.deleteCourse(course.id);
        _loadCourses();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المقررات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddCourseDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _courses.isEmpty
                  ? const Center(child: Text('لا توجد مقررات'))
                  : RefreshIndicator(
                      onRefresh: _loadCourses,
                      child: ListView.builder(
                        itemCount: _courses.length,
                        itemBuilder: (context, index) {
                          final course = _courses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: ListTile(
                              title: Text(course.courseName),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.department?.departmentName ?? '',
                                  ),
                                  Text(
                                    course.description ?? '',
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.info),
                                    onPressed: () => _showCourseDetails(course),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showEditCourseDialog(course),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      course.isActive
                                          ? Icons.toggle_on
                                          : Icons.toggle_off,
                                      color: course.isActive
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    onPressed: () =>
                                        _toggleCourseStatus(course),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _deleteCourse(course),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
