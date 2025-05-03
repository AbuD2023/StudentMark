import 'package:coordinator_dashpord_for_studentmark/core/models/attendance.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';

class QRCode {
  final int id;
  final int scheduleId;
  final int doctorId;
  final String qrCodeValue;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final LectureSchedule? lectureSchedule;
  final List<Attendance>? attendances;

  QRCode({
    required this.id,
    required this.scheduleId,
    required this.doctorId,
    required this.qrCodeValue,
    required this.generatedAt,
    required this.expiresAt,
    required this.isActive,
    // required this.createdAt,
    // this.updatedAt,
    this.lectureSchedule,
    this.attendances,
  });

  factory QRCode.fromJson(Map<String, dynamic> json) {
    return QRCode(
      id: json['id'] as int,
      scheduleId: json['scheduleId'] as int,
      doctorId: json['doctorId'] as int,
      qrCodeValue: json['qrCodeValue'] as String,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      lectureSchedule: json['lectureSchedule'] != null
          ? LectureSchedule.fromJson(json['lectureSchedule'])
          : null,
      attendances: json['attendances'] != null
          ? (json['attendances'] as List)
              .map((e) => Attendance.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'doctorId': doctorId,
      'qrCodeValue': qrCodeValue,
      'generatedAt': generatedAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'isActive': isActive,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'lectureSchedule': lectureSchedule?.toJson(),
      'attendances': attendances?.map((e) => e.toJson()).toList(),
    };
  }
}
