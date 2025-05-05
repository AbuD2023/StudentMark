import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/widgets/dashboard_card.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/widgets/quick_action_button.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/widgets/notification_item.dart';

class CoordinatorDashboardScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const CoordinatorDashboardScreen({
    super.key,
    required this.coordinatorService,
  });

  @override
  State<CoordinatorDashboardScreen> createState() =>
      _CoordinatorDashboardScreenState();
}

class _CoordinatorDashboardScreenState
    extends State<CoordinatorDashboardScreen> {
  Map<String, dynamic> _stats = {};
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = '';
      });

      final stats = await widget.coordinatorService.getDashboardStats();

      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Implement settings
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'القائمة الرئيسية',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('لوحة التحكم'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('إدارة الطلاب'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/students');
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('إدارة الأقسام'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/departments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.class_),
              title: const Text('إدارة المستويات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/levels');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('إدارة المواد'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/subjects');
              },
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('إدارة الجداول الدراسية'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/lecture-schedules');
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text('إدارة رموز QR'),
              onTap: () {
                // TODO: Navigate to QR codes management
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment),
              title: const Text('التقارير'),
              onTap: () {
                // TODO: Navigate to reports
              },
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text('Error: $_error'))
              : RefreshIndicator(
                  onRefresh: _loadDashboardData,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistics Section
                        const Text(
                          'الإحصائيات',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            DashboardCard(
                              title: 'الطلاب',
                              value: _stats['totalstudents'].toString(),
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                            DashboardCard(
                              title: 'الأقسام',
                              value: _stats['totalDepartments'].toString(),
                              icon: Icons.school,
                              color: Colors.green,
                            ),
                            DashboardCard(
                              title: 'المستويات',
                              value: _stats['totalLevels'].toString(),
                              icon: Icons.class_,
                              color: Colors.orange,
                            ),
                            DashboardCard(
                              title: 'المواد',
                              value: _stats['totalSubjects'].toString(),
                              icon: Icons.book,
                              color: Colors.purple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Quick Actions Section
                        const Text(
                          'إجراءات سريعة',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            QuickActionButton(
                              title: 'إضافة طالب',
                              icon: Icons.person_add,
                              onPressed: () {
                                Navigator.pushNamed(context, '/students');
                              },
                              color: Colors.blue,
                            ),
                            QuickActionButton(
                              title: 'إضافة قسم',
                              icon: Icons.add_business,
                              onPressed: () {
                                Navigator.pushNamed(context, '/departments');
                              },
                              color: Colors.green,
                            ),
                            QuickActionButton(
                              title: 'إضافة مستوى',
                              icon: Icons.add_circle,
                              onPressed: () {
                                Navigator.pushNamed(context, '/levels');
                              },
                              color: Colors.orange,
                            ),
                            QuickActionButton(
                              title: 'إضافة مادة',
                              icon: Icons.add_box,
                              onPressed: () {
                                Navigator.pushNamed(context, '/subjects');
                              },
                              color: Colors.purple,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Notifications Section
                        const Text(
                          'الإشعارات',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _stats['notifications']?.length ?? 0,
                          itemBuilder: (context, index) {
                            final notification = _stats['notifications'][index];
                            return NotificationItem(
                              title: notification['title'],
                              message: notification['message'],
                              date: (notification['date']).toString(),
                              icon: _getNotificationIcon(notification['type']),
                              color:
                                  _getNotificationColor(notification['type']),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'attendance':
        return Icons.person;
      case 'schedule':
        return Icons.calendar_today;
      case 'report':
        return Icons.assessment;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'attendance':
        return Colors.blue;
      case 'schedule':
        return Colors.green;
      case 'report':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
