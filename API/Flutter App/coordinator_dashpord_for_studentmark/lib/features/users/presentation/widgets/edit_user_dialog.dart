import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';
import 'package:coordinator_dashpord_for_studentmark/features/coordinator/data/services/coordinator_service.dart';

class EditUserDialog extends StatefulWidget {
  final User user;
  final CoordinatorService coordinatorService;

  const EditUserDialog({
    Key? key,
    required this.user,
    required this.coordinatorService,
  }) : super(key: key);

  @override
  State<EditUserDialog> createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late User _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentUser = User(
      id: widget.user.id,
      fullName: widget.user.fullName,
      email: widget.user.email,
      username: widget.user.username,
      password: widget.user.password,
      passwordHash: widget.user.passwordHash,
      roleId: widget.user.roleId,
      isActive: widget.user.isActive,
      createdAt: widget.user.createdAt,
    );
    _fullNameController = TextEditingController(text: _currentUser.fullName);
    _emailController = TextEditingController(text: _currentUser.email);
    _usernameController = TextEditingController(text: _currentUser.username);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedUser = User(
        id: _currentUser.id,
        fullName: _fullNameController.text,
        email: _emailController.text,
        username: _usernameController.text,
        password: _currentUser.password,
        passwordHash: _currentUser.passwordHash,
        roleId: _currentUser.roleId,
        isActive: _currentUser.isActive,
        createdAt: _currentUser.createdAt,
      );

      await widget.coordinatorService.updateUser(updatedUser);
      if (!mounted) return;
      Navigator.pop(context, updatedUser);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في تحديث بيانات المستخدم')),
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
              'تعديل بيانات المستخدم',
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
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'الاسم الكامل',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال الاسم الكامل';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!value.contains('@')) {
                        return 'الرجاء إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'اسم المستخدم',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المستخدم';
                      }
                      return null;
                    },
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
                  onPressed: _isLoading ? null : _updateUser,
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
