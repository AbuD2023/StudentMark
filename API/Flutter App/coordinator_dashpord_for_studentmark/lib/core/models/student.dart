import 'package:coordinator_dashpord_for_studentmark/core/models/attendance.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

import '../../features/departments/domain/models/department_model.dart';

class Student {
  int? id;
  int? userId;
  int? departmentId;
  int? levelId;
  int? enrollmentYear;
  bool? isActive;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final User? user;
  final Department? department;
  final Level? level;
  final List<Attendance>? attendances;

  Student({
    this.id,
    this.userId,
    this.departmentId,
    this.levelId,
    this.enrollmentYear,
    this.isActive,
    // required this.createdAt,
    // this.updatedAt,
    this.user,
    this.department,
    this.level,
    this.attendances,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] as int,
      userId: json['userId'] as int,
      departmentId: json['departmentId'] as int,
      levelId: json['levelId'] as int,
      enrollmentYear: json['enrollmentYear'] as int,
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
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
      'userId': userId,
      'departmentId': departmentId,
      'levelId': levelId,
      'enrollmentYear': enrollmentYear,
      'isActive': isActive,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
      'department': department?.toJson(),
      'level': level?.toJson(),
      'attendances': attendances?.map((e) => e.toJson()).toList(),
    };
  }
}
