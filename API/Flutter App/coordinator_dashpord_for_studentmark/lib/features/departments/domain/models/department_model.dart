import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';

import '../../../../core/models/level.dart';

class Department {
  final int? id;
  final String departmentName;
  final String? description;
  final bool isActive;
  final List<Level>? levels;
  final List<Course>? courses;
  final List<Student>? students;
  final List<DoctorDepartmentsLevels>? doctorDepartmentsLevels;
  final List<LectureSchedule>? lectureSchedules;

  Department({
    this.id,
    required this.departmentName,
    this.description,
    required this.isActive,
    this.levels,
    this.courses,
    this.students,
    this.doctorDepartmentsLevels,
    this.lectureSchedules,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      departmentName: json['departmentName'],
      description: json['description'],
      isActive: json['isActive'],
      levels: json['levels'] != null
          ? (json['levels'] as List)
              .map((level) => Level.fromJson(level))
              .toList()
          : null,
      courses: json['courses'] != null
          ? (json['courses'] as List)
              .map((course) => Course.fromJson(course))
              .toList()
          : null,
      students: json['students'] != null
          ? (json['students'] as List)
              .map((student) => Student.fromJson(student))
              .toList()
          : null,
      doctorDepartmentsLevels: json['doctorDepartmentsLevels'] != null
          ? (json['doctorDepartmentsLevels'] as List)
              .map((ddl) => DoctorDepartmentsLevels.fromJson(ddl))
              .toList()
          : null,
      lectureSchedules: json['lectureSchedules'] != null
          ? (json['lectureSchedules'] as List)
              .map((schedule) => LectureSchedule.fromJson(schedule))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departmentName': departmentName,
      'description': description,
      'isActive': isActive,
      'levels': levels?.map((e) => e.toJson()).toList(),
      'courses': courses?.map((e) => e.toJson()).toList(),
      'students': students?.map((e) => e.toJson()).toList(),
      'doctorDepartmentsLevels':
          doctorDepartmentsLevels?.map((e) => e.toJson()).toList(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
    };
  }
}

// class Level {
//   final int id;
//   final String name;
//   final int departmentId;
//   final DateTime createdAt;
//   final DateTime? updatedAt;

//   Level({
//     required this.id,
//     required this.name,
//     required this.departmentId,
//     required this.createdAt,
//     this.updatedAt,
//   });

//   factory Level.fromJson(Map<String, dynamic> json) {
//     return Level(
//       id: json['id'],
//       name: json['name'],
//       departmentId: json['departmentId'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt:
//           json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'departmentId': departmentId,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }

// class Subject {
//   final int id;
//   final String name;
//   final String code;
//   final int departmentId;
//   final DateTime createdAt;
//   final DateTime? updatedAt;

//   Subject({
//     required this.id,
//     required this.name,
//     required this.code,
//     required this.departmentId,
//     required this.createdAt,
//     this.updatedAt,
//   });

//   factory Subject.fromJson(Map<String, dynamic> json) {
//     return Subject(
//       id: json['id'],
//       name: json['name'],
//       code: json['code'],
//       departmentId: json['departmentId'],
//       createdAt: DateTime.parse(json['createdAt']),
//       updatedAt:
//           json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'code': code,
//       'departmentId': departmentId,
//       'createdAt': createdAt.toIso8601String(),
//       'updatedAt': updatedAt?.toIso8601String(),
//     };
//   }
// }
