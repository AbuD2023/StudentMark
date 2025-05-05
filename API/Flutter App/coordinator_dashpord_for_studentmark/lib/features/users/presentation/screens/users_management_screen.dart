import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

import '../widgets/add_user_dialog.dart';
import '../widgets/edit_user_dialog.dart';

class UsersManagementScreen extends StatefulWidget {
  final CoordinatorService coordinatorService;

  const UsersManagementScreen({
    Key? key,
    required this.coordinatorService,
  }) : super(key: key);

  @override
  State<UsersManagementScreen> createState() => _UsersManagementScreenState();
}

class _UsersManagementScreenState extends State<UsersManagementScreen> {
  List<User> _users = [];
  bool _showActiveOnly = true;
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedRole = 'all'; // 'all', 'student', 'doctor', 'coordinator'

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final users = _showActiveOnly
          ? await widget.coordinatorService.getActiveUsers()
          : await widget.coordinatorService.getAllUsers();

      setState(() {
        _users = _selectedRole == 'all'
            ? users
            : users
                .where(
                    (user) => user.role?.name?.toLowerCase() == _selectedRole)
                .toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'فشل في تحميل بيانات المستخدمين';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showAddUserDialog() async {
    final result = await showDialog<User>(
      context: context,
      builder: (context) => AddUserDialog(
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadUsers();
    }
  }

  Future<void> _showEditUserDialog(User user) async {
    final result = await showDialog<User>(
      context: context,
      builder: (context) => EditUserDialog(
        user: user,
        coordinatorService: widget.coordinatorService,
      ),
    );

    if (result != null) {
      await _loadUsers();
    }
  }

  Future<void> _toggleUserStatus(int id) async {
    try {
      await widget.coordinatorService.toggleUserStatus(id);
      await _loadUsers();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تغيير حالة المستخدم بنجاح')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تغيير حالة المستخدم')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        actions: [
          // فلتر حسب الدور
          DropdownButton<String>(
            value: _selectedRole,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('الكل')),
              DropdownMenuItem(value: 'student', child: Text('طالب')),
              DropdownMenuItem(value: 'doctor', child: Text('أستاذ')),
              DropdownMenuItem(value: 'coordinator', child: Text('منسق')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedRole = value!;
              });
              _loadUsers();
            },
          ),
          // زر عرض/إخفاء المستخدمين غير النشطين
          IconButton(
            icon:
                Icon(_showActiveOnly ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showActiveOnly = !_showActiveOnly;
              });
              _loadUsers();
            },
            tooltip: _showActiveOnly ? 'عرض الكل' : 'عرض النشطين فقط',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _users.isEmpty
                  ? const Center(child: Text('لا يوجد مستخدمين'))
                  : _buildUsersList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddUserDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUsersList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(user.fullName?[0] ?? ''),
            ),
            title: Text(user.fullName ?? ''),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email ?? ''),
                Text('الدور: ${user.role?.name ?? ''}'),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    user.isActive ? Icons.toggle_on : Icons.toggle_off,
                    color: user.isActive ? Colors.green : Colors.red,
                  ),
                  onPressed: () => _toggleUserStatus(user.id!),
                  tooltip: user.isActive ? 'تعطيل' : 'تفعيل',
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showEditUserDialog(user),
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
