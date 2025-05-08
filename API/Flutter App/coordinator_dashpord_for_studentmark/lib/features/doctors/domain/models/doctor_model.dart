import 'package:coordinator_dashpord_for_studentmark/core/models/user.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';

import '../../../departments/domain/models/department_model.dart';

class Doctor {
  final int id;
  final int doctorId;
  final int departmentId;
  final int levelId;
  final bool isActive;
  final User? doctor;
  final Department? department;
  final Level? level;

  Doctor({
    required this.id,
    required this.doctorId,
    required this.departmentId,
    required this.levelId,
    required this.isActive,
    this.doctor,
    this.department,
    this.level,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      doctorId: json['doctorId'],
      departmentId: json['departmentId'],
      levelId: json['levelId'],
      isActive: json['isActive'],
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
      'doctor': doctor?.toJson(),
      'department': department?.toJson(),
      'level': level?.toJson(),
    };
  }

  Doctor copyWith({
    int? id,
    int? doctorId,
    int? departmentId,
    int? levelId,
    bool? isActive,
    User? doctor,
    Department? department,
    Level? level,
  }) {
    return Doctor(
      id: id ?? this.id,
      doctorId: doctorId ?? this.doctorId,
      departmentId: departmentId ?? this.departmentId,
      levelId: levelId ?? this.levelId,
      isActive: isActive ?? this.isActive,
      doctor: doctor ?? this.doctor,
      department: department ?? this.department,
      level: level ?? this.level,
    );
  }
}
