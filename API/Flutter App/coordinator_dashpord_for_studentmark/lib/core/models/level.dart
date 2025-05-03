import 'package:coordinator_dashpord_for_studentmark/core/models/course_subject.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/doctor_departments_levels.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/student.dart';

import '../../features/departments/domain/models/department_model.dart';

class Level {
  final int? id;
  final String levelName;
  // final String? description;
  final bool isActive;
  final int departmentId;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final Department? department;
  final List<Student>? students;
  final List<CourseSubject>? courseSubjects;
  final List<DoctorDepartmentsLevels>? doctorDepartmentsLevels;
  final List<LectureSchedule>? lectureSchedules;

  Level({
    this.id,
    required this.levelName,
    // this.description,
    required this.isActive,
    required this.departmentId,
    // required this.createdAt,
    // required this.updatedAt,
    this.department,
    this.students,
    this.courseSubjects,
    this.doctorDepartmentsLevels,
    this.lectureSchedules,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      levelName: json['levelName'],
      // description: json['description'],
      isActive: json['isActive'] ?? true,
      departmentId: json['departmentId'],
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      students: json['students'] != null
          ? (json['students'] as List).map((e) => Student.fromJson(e)).toList()
          : null,
      courseSubjects: json['courseSubjects'] != null
          ? (json['courseSubjects'] as List)
              .map((e) => CourseSubject.fromJson(e))
              .toList()
          : null,
      doctorDepartmentsLevels: json['doctorDepartmentsLevels'] != null
          ? (json['doctorDepartmentsLevels'] as List)
              .map((e) => DoctorDepartmentsLevels.fromJson(e))
              .toList()
          : null,
      lectureSchedules: json['lectureSchedules'] != null
          ? (json['lectureSchedules'] as List)
              .map((e) => LectureSchedule.fromJson(e))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'levelName': levelName,
      // 'description': description,
      'isActive': isActive,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'departmentId': departmentId,
      'department': department?.toJson(),
      'students': students?.map((e) => e.toJson()).toList(),
      'courseSubjects': courseSubjects?.map((e) => e.toJson()).toList(),
      'doctorDepartmentsLevels':
          doctorDepartmentsLevels?.map((e) => e.toJson()).toList(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
    };
  }
}
