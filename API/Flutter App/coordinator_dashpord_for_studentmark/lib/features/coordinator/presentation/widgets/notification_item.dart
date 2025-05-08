import 'package:flutter/material.dart';

import '../../../../core/models/level.dart';
import '../../../../core/models/user.dart';
import '../../../departments/domain/models/department_model.dart';

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String? date;
  final List<String>? dateList;
  final IconData icon;
  final Color color;
  final User? doctor;
  final Department? department;
  final Level? level;
  final String type;
  final String? room;

  const NotificationItem({
    super.key,
    required this.title,
    required this.message,
    this.date,
    this.dateList,
    required this.icon,
    required this.color,
    required this.type,
    this.room,
    this.doctor,
    this.department,
    this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 4),
            if (type == 'room') ...[
              Text(
                // date,
                'وقت المحاظرة: ${_formatDate(DateTime.utc(DateTime.now().year, DateTime.now().month, DateTime.now().day, int.parse("${date![0]}${date![1]}"), int.parse("${date![3]}${date![4]}")), 1)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                // textDirection: TextDirection.ltr,
              ),
              const SizedBox(height: 4),
              Text(
                'المدرس: ${doctor?.fullName ?? 'لا يوجد مدرس'}',
                // _formatDate(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'القسم: ${department?.departmentName ?? 'لا يوجد قسم'}',
                // _formatDate(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'المستوئ: ${level?.levelName ?? 'لا يوجد مستوئ'}',
                // _formatDate(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'القاعة: ${room ?? 'لا يوجد قاعة محددة'}',
                // _formatDate(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (dateList != null) ...[
                    Flexible(
                      child: Text(
                        dateList!.asMap().entries.map((entry) {
                          final isLast = entry.key == dateList!.length - 1;
                          final isEven = entry.key % 2 == 1;
                          return 'وقت المحاظرة: ${_formatDate(DateTime.parse(entry.value), 0)}${isLast ? '.' : (isEven ? '،\n' : '، ')}';
                        }).join(''),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        overflow: TextOverflow.clip,
                        // textAlign: TextAlign.center,
                        // textDirection: TextDirection.rtl,
                      ),
                    )
                  ]
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date, int type) {
    try {
      if (type == 1) {
        return '${date.hour}:${date.minute}';
      }
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
    } catch (e) {
      return '${date.hour}:${date.minute}';
    }
  }
}
