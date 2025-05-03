import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/attendance.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;

  const AttendanceCard({
    super.key,
    required this.attendance,
  });

  @override
  Widget build(BuildContext context) {
    final lectureSchedule = attendance.lectureSchedule;
    final courseSubject = lectureSchedule!.courseSubject;
    final course = courseSubject!.course;
    final subject = courseSubject.subject;
    final qrCode = attendance.qrCode;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status indicator
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: attendance.status ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    attendance.status ? 'حاضر' : 'غائب',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  _formatDate(attendance.attendanceDate.toString()),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Course and Subject Information
            _buildInfoRow(
              'المادة',
              '${subject!.subjectName} (${course!.courseName})',
              Icons.book,
            ),
            const SizedBox(height: 8.0),

            // Schedule Information
            _buildInfoRow(
              'الجدول',
              '${_getDayName(lectureSchedule.dayOfWeek)} ${lectureSchedule.startTime} - ${lectureSchedule.endTime}',
              Icons.schedule,
            ),
            const SizedBox(height: 8.0),

            // Room Information
            _buildInfoRow(
              'القاعة',
              lectureSchedule.room,
              Icons.room,
            ),
            const SizedBox(height: 16.0),

            // Notes Section
            if (attendance.studentNote != null || attendance.doctorNote != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ملاحظات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  if (attendance.studentNote != null)
                    _buildNoteItem(
                      'ملاحظة الطالب',
                      attendance.studentNote!,
                      Icons.person,
                    ),
                  if (attendance.doctorNote != null)
                    _buildNoteItem(
                      'ملاحظة الدكتور',
                      attendance.doctorNote!,
                      Icons.school,
                    ),
                ],
              ),

            // QR Code Information
            const SizedBox(height: 16.0),
            _buildInfoRow(
              'رمز QR',
              qrCode!.qrCodeValue,
              Icons.qr_code,
            ),
            const SizedBox(height: 8.0),
            _buildInfoRow(
              'تاريخ الانتهاء',
              _formatDate(qrCode.expiresAt.toString()),
              Icons.timer,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.0, color: Colors.blue),
        const SizedBox(width: 8.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteItem(String label, String note, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.0, color: Colors.blue),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return DateFormat('yyyy/MM/dd hh:mm a').format(date);
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case 1:
        return 'الأحد';
      case 2:
        return 'الاثنين';
      case 3:
        return 'الثلاثاء';
      case 4:
        return 'الأربعاء';
      case 5:
        return 'الخميس';
      case 6:
        return 'الجمعة';
      case 7:
        return 'السبت';
      default:
        return 'غير معروف';
    }
  }
}
