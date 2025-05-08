import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/presentation/providers/doctor_provider.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/presentation/widgets/doctor_list_item.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/presentation/widgets/doctor_form_dialog.dart';

class DoctorsManagementScreen extends StatefulWidget {
  const DoctorsManagementScreen({super.key});

  @override
  State<DoctorsManagementScreen> createState() =>
      _DoctorsManagementScreenState();
}

class _DoctorsManagementScreenState extends State<DoctorsManagementScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<DoctorProvider>().getAllDoctorAssignments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الدكاترة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<DoctorProvider>().getAllDoctorAssignments();
            },
          ),
        ],
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error.isNotEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<DoctorProvider>().getAllDoctorAssignments(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'حدث خطأ: ${provider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.getAllDoctorAssignments();
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (provider.doctors.isEmpty) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<DoctorProvider>().getAllDoctorAssignments(),
              child: const Center(
                child: Text('لا يوجد دكاترة مسجلين'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<DoctorProvider>().getAllDoctorAssignments(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.doctors.length,
              itemBuilder: (context, index) {
                final doctor = provider.doctors[index];
                return DoctorListItem(
                  doctor: doctor,
                  onEdit: () => _showDoctorFormDialog(context, doctor),
                  onDelete: () =>
                      _showDeleteConfirmationDialog(context, doctor),
                  onToggleStatus: () {
                    provider.toggleDoctorAssignmentStatus(doctor.id);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDoctorFormDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showDoctorFormDialog(
      BuildContext context, Doctor? doctor) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => DoctorFormDialog(doctor: doctor),
    );

    if (result == true) {
      if (!mounted) return;
      context.read<DoctorProvider>().getAllDoctorAssignments();
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Doctor doctor) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text(
            'هل أنت متأكد من حذف الدكتور ${doctor.doctor?.fullName ?? 'غير معروف'}؟'),
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

    if (confirmed == true && mounted) {
      await context.read<DoctorProvider>().deleteDoctorAssignment(doctor.id);
    }
  }
}
