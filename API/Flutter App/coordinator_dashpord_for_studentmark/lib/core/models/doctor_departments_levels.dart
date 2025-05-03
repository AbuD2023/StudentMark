import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';

import '../../features/departments/domain/models/department_model.dart';

class DoctorDepartmentsLevels {
  final int id;
  final int doctorId;
  final int departmentId;
  final int levelId;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final User? doctor;
  final Department? department;
  final Level? level;

  DoctorDepartmentsLevels({
    required this.id,
    required this.doctorId,
    required this.departmentId,
    required this.levelId,
    required this.isActive,
    // required this.createdAt,
    // required this.updatedAt,
    this.doctor,
    this.department,
    this.level,
  });

  factory DoctorDepartmentsLevels.fromJson(Map<String, dynamic> json) {
    return DoctorDepartmentsLevels(
      id: json['id'] as int,
      doctorId: json['doctorId'] as int,
      departmentId: json['departmentId'] as int,
      levelId: json['levelId'] as int,
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      doctor: json['doctor'] != null ? User.fromJson(json['doctor']) : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctorId': doctorId,
      'departmentId': departmentId,
      'levelId': levelId,
      'isActive': isActive,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'doctor': doctor?.toJson(),
      'department': department?.toJson(),
      'level': level?.toJson(),
    };
  }
}
