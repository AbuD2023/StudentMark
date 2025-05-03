import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/students/presentation/widgets/attendance_card.dart';

import '../../../../core/models/attendance.dart';

class StudentAttendanceScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;
  final int studentId;

  const StudentAttendanceScreen({
    super.key,
    required this.coordinatorService,
    required this.studentId,
  });

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  List<Attendance> _allAttendances = [];
  List<Attendance> _filteredAttendances = [];
  bool _isLoading = true;
  String? _error;
  bool _showActiveOnly = true;

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  Future<void> _loadAttendances() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final attendances = await widget.coordinatorService.getStudentAttendances(
        widget.studentId,
      );

      setState(() {
        _allAttendances = attendances;
        _filterAttendances();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterAttendances() {
    setState(() {
      _filteredAttendances = _showActiveOnly
          ? _allAttendances
              .where((attendance) => attendance.status == true)
              .toList()
          : _allAttendances;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجلات الحضور'),
        actions: [
          IconButton(
            icon: Icon(
              _showActiveOnly ? Icons.filter_list : Icons.filter_list_off,
            ),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _filterAttendances();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشط فقط',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAttendances,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'حدث خطأ: $_error',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAttendances,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : _filteredAttendances.isEmpty
                  ? const Center(
                      child: Text('لا توجد سجلات حضور'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadAttendances,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _filteredAttendances.length,
                        itemBuilder: (context, index) {
                          return AttendanceCard(
                            attendance: _filteredAttendances[index],
                          );
                        },
                      ),
                    ),
    );
  }
}
