import 'package:coordinator_dashpord_for_studentmark/core/models/attendance.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course_subject.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/qr_code.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

import '../../features/departments/domain/models/department_model.dart';

class LectureSchedule {
  final int id;
  final int courseSubjectId;
  final int doctorId;
  final int departmentId;
  final int levelId;
  final int dayOfWeek; // 0 = Sunday, 1 = Monday, ..., 6 = Saturday
  final String startTime; // Format: "HH:mm:ss"
  final String endTime; // Format: "HH:mm:ss"
  final String room;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final CourseSubject? courseSubject;
  final User? doctor;
  final Department? department;
  final Level? level;
  final List<QRCode>? qrCodes;
  final List<Attendance>? attendances;

  LectureSchedule({
    required this.id,
    required this.courseSubjectId,
    required this.doctorId,
    required this.departmentId,
    required this.levelId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.isActive,
    // required this.createdAt,
    // this.updatedAt,
    this.courseSubject,
    this.doctor,
    this.department,
    this.level,
    this.qrCodes,
    this.attendances,
  });

  factory LectureSchedule.fromJson(Map<String, dynamic> json) {
    return LectureSchedule(
      id: json['id'] as int,
      courseSubjectId: json['courseSubjectId'] as int,
      doctorId: json['doctorId'] as int,
      departmentId: json['departmentId'] as int,
      levelId: json['levelId'] as int,
      dayOfWeek: json['dayOfWeek'] as int,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      room: json['room'] as String,
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      courseSubject: json['courseSubject'] != null
          ? CourseSubject.fromJson(json['courseSubject'])
          : null,
      doctor: json['doctor'] != null ? User.fromJson(json['doctor']) : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
      qrCodes: json['qrCodes'] != null
          ? (json['qrCodes'] as List).map((e) => QRCode.fromJson(e)).toList()
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
      'courseSubjectId': courseSubjectId,
      'doctorId': doctorId,
      'departmentId': departmentId,
      'levelId': levelId,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
      'courseSubject': courseSubject?.toJson(),
      'doctor': doctor?.toJson(),
      'department': department?.toJson(),
      'level': level?.toJson(),
      'qrCodes': qrCodes?.map((e) => e.toJson()).toList(),
      'attendances': attendances?.map((e) => e.toJson()).toList(),
    };
  }

  LectureSchedule copyWith({
    int? id,
    int? courseSubjectId,
    int? doctorId,
    int? departmentId,
    int? levelId,
    int? dayOfWeek,
    String? startTime,
    String? endTime,
    String? room,
    bool? isActive,
    CourseSubject? courseSubject,
    User? doctor,
    Department? department,
    Level? level,
    List<QRCode>? qrCodes,
    List<Attendance>? attendances,
  }) {
    return LectureSchedule(
      id: id ?? this.id,
      courseSubjectId: courseSubjectId ?? this.courseSubjectId,
      doctorId: doctorId ?? this.doctorId,
      departmentId: departmentId ?? this.departmentId,
      levelId: levelId ?? this.levelId,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      room: room ?? this.room,
      isActive: isActive ?? this.isActive,
      courseSubject: courseSubject ?? this.courseSubject,
      doctor: doctor ?? this.doctor,
      department: department ?? this.department,
      level: level ?? this.level,
      qrCodes: qrCodes ?? this.qrCodes,
      attendances: attendances ?? this.attendances,
    );
  }
}
