import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';
import 'qr_code.dart';

class Attendance {
  final int id;
  final int studentId;
  final int scheduleId;
  final int qrCodeId;
  final DateTime attendanceDate;
  final bool status;
  final String? studentNote;
  final String? doctorNote;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final Student? student;
  final LectureSchedule? lectureSchedule;
  final QRCode? qrCode;

  Attendance({
    required this.id,
    required this.studentId,
    required this.scheduleId,
    required this.qrCodeId,
    required this.attendanceDate,
    required this.status,
    this.studentNote,
    this.doctorNote,
    // required this.createdAt,
    // this.updatedAt,
    this.student,
    this.lectureSchedule,
    this.qrCode,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
      id: json['id'] as int,
      studentId: json['studentId'] as int,
      scheduleId: json['scheduleId'] as int,
      qrCodeId: json['qrCodeId'] as int,
      attendanceDate: DateTime.parse(json['attendanceDate'] as String),
      status: json['status'] as bool,
      studentNote: json['studentNote'] as String?,
      doctorNote: json['doctorNote'] as String?,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      lectureSchedule: json['lectureSchedule'] != null
          ? LectureSchedule.fromJson(json['lectureSchedule'])
          : null,
      qrCode: json['qrCode'] != null ? QRCode.fromJson(json['qrCode']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'scheduleId': scheduleId,
      'qrCodeId': qrCodeId,
      'attendanceDate': attendanceDate.toIso8601String(),
      'status': status,
      'studentNote': studentNote,
      'doctorNote': doctorNote,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'student': student?.toJson(),
      'lectureSchedule': lectureSchedule?.toJson(),
      'qrCode': qrCode?.toJson(),
    };
  }
}
