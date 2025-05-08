import 'package:flutter/material.dart';
import 'package:coordinator_dashpord_for_studentmark/features/doctors/domain/models/doctor_model.dart';

class DoctorListItem extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const DoctorListItem({
    super.key,
    required this.doctor,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: doctor.isActive ? Colors.green : Colors.red,
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(doctor.doctor?.fullName ?? 'غير معروف'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('القسم: ${doctor.department?.departmentName ?? 'غير معروف'}'),
            Text('المستوى: ${doctor.level?.levelName ?? 'غير معروف'}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                doctor.isActive ? Icons.toggle_on : Icons.toggle_off,
                color: doctor.isActive ? Colors.green : Colors.red,
              ),
              onPressed: onToggleStatus,
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
