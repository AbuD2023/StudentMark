import 'package:coordinator_dashpord_for_studentmark/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/widgets/dashboard_card.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/widgets/quick_action_button.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/presentation/widgets/notification_item.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/auth_service.dart';

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
              title: const Text('إدارة الدكاترة'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/doctors');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('إدارة المستخدمين'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/user');
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
              leading: const Icon(Icons.menu_book),
              title: const Text('إدارة المقررات'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/courses');
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
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('تسجيل خروج'),
              onTap: () {
                final authService =
                    Provider.of<AuthService>(context, listen: false);
                authService.logout();
                Navigator.pushReplacementNamed(context, '/login');
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
                          // scrollDirection: Axis.horizontal,
                          crossAxisCount: MediaQuery.of(context).size.width <=
                                  AppConstants.mobileBreakpoint
                              ? 2
                              : 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: MediaQuery.of(context).size.width <=
                                  AppConstants.tabletBreakpoint
                              ? 1.0
                              : 2.5,
                          children: [
                            DashboardCard(
                              title: 'الدكاترة',
                              value: _stats['totalDoctors']?.toString() ?? '0',
                              icon: Icons.people,
                              color: Colors.blue,
                            ),
                            DashboardCard(
                              title: 'الطلاب',
                              value: _stats['totalstudents'].toString(),
                              icon: Icons.people,
                              color: Colors.green,
                            ),
                            DashboardCard(
                              title: 'الأقسام',
                              value: _stats['totalDepartments'].toString(),
                              icon: Icons.school,
                              color: Colors.orange,
                            ),
                            DashboardCard(
                              title: 'المستويات',
                              value: _stats['totalLevels'].toString(),
                              icon: Icons.class_,
                              color: Colors.purple,
                            ),
                            DashboardCard(
                              title: 'المواد',
                              value: _stats['totalSubjects'].toString(),
                              icon: Icons.book,
                              color: Colors.purple,
                            ),
                            DashboardCard(
                              title: 'الحضور اليوم',
                              value: _stats['todayAttendances'].toString(),
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
                          crossAxisCount: MediaQuery.of(context).size.width <=
                                  AppConstants.mobileBreakpoint
                              ? 2
                              : 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: MediaQuery.of(context).size.width <=
                                  AppConstants.tabletBreakpoint
                              ? 1.0
                              : 1.5,
                          children: [
                            QuickActionButton(
                              title: 'إضافة دكتور',
                              icon: Icons.person_add,
                              onPressed: () {
                                Navigator.pushNamed(context, '/doctors');
                              },
                              color: Colors.blue,
                            ),
                            QuickActionButton(
                              title: 'إضافة طالب',
                              icon: Icons.person_add,
                              onPressed: () {
                                Navigator.pushNamed(context, '/students');
                              },
                              color: Colors.green,
                            ),
                            QuickActionButton(
                              title: 'إضافة قسم',
                              icon: Icons.add_business,
                              onPressed: () {
                                Navigator.pushNamed(context, '/departments');
                              },
                              color: Colors.orange,
                            ),
                            QuickActionButton(
                              title: 'إضافة مستوى',
                              icon: Icons.add_circle,
                              onPressed: () {
                                Navigator.pushNamed(context, '/levels');
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
                              date: (notification['date'] is List)
                                  ? null
                                  : (notification['date']),
                              dateList: (notification['date'] is List?)
                                  ? (notification['date'] as List<String>?)
                                  : null,
                              icon: _getNotificationIcon(notification['type']),
                              color:
                                  _getNotificationColor(notification['type']),
                              doctor: notification['doctor'],
                              department: notification['department'],
                              level: notification['level'],
                              type: notification['type'],
                              room: notification['room'],
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
