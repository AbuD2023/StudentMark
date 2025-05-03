import 'package:coordinator_dashpord_for_studentmark/core/models/attendance.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/qr_code.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/role.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';

class User {
  final int id;
  final String fullName;
  final String? refreshToken;
  final String username;
  final String passwordHash;
  final String email;
  final String password;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? refreshTokenExpiryTime;
  final DateTime? lastLoginAt;
  final DateTime? updatedAt;

  // Navigation properties
  final int roleId;
  final Role? role;
  final Student? student;
  final List<LectureSchedule>? lectureSchedules;
  final List<DoctorDepartmentsLevels>? doctorDepartmentsLevels;
  final List<QRCode>? generatedQRCodes;
  final List<Attendance>? attendances;

  User({
    required this.id,
    required this.fullName,
    this.refreshToken,
    required this.username,
    required this.passwordHash,
    required this.email,
    required this.password,
    required this.isActive,
    required this.createdAt,
    this.refreshTokenExpiryTime,
    this.lastLoginAt,
    this.updatedAt,
    required this.roleId,
    this.role,
    this.student,
    this.lectureSchedules,
    this.doctorDepartmentsLevels,
    this.generatedQRCodes,
    this.attendances,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      refreshToken: json['refreshToken'] as String?,
      username: json['username'] as String,
      passwordHash: json['passwordHash'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      refreshTokenExpiryTime: json['refreshTokenExpiryTime'] != null
          ? DateTime.parse(json['refreshTokenExpiryTime'] as String)
          : null,
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      roleId: json['roleId'] as int,
      role: json['role'] != null ? Role.fromJson(json['role']) : null,
      student:
          json['student'] != null ? Student.fromJson(json['student']) : null,
      lectureSchedules: json['lectureSchedules'] != null
          ? (json['lectureSchedules'] as List)
              .map((e) => LectureSchedule.fromJson(e))
              .toList()
          : null,
      doctorDepartmentsLevels: json['doctorDepartmentsLevels'] != null
          ? (json['doctorDepartmentsLevels'] as List)
              .map((e) => DoctorDepartmentsLevels.fromJson(e))
              .toList()
          : null,
      generatedQRCodes: json['generatedQRCodes'] != null
          ? (json['generatedQRCodes'] as List)
              .map((e) => QRCode.fromJson(e))
              .toList()
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
      'fullName': fullName,
      'refreshToken': refreshToken,
      'username': username,
      'passwordHash': passwordHash,
      'email': email,
      'password': password,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'refreshTokenExpiryTime': refreshTokenExpiryTime?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'roleId': roleId,
      'role': role?.toJson(),
      'student': student?.toJson(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
      'doctorDepartmentsLevels':
          doctorDepartmentsLevels?.map((e) => e.toJson()).toList(),
      'generatedQRCodes': generatedQRCodes?.map((e) => e.toJson()).toList(),
      'attendances': attendances?.map((e) => e.toJson()).toList(),
    };
  }
}
