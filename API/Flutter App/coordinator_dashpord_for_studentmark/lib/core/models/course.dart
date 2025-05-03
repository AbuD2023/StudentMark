import 'package:coordinator_dashpord_for_studentmark/core/models/course_subject.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';

import '../../features/departments/domain/models/department_model.dart';

class Course {
  final int? id;
  final String courseName;
  final String? description;
  final int departmentId;
  final bool isActive;
  // final DateTime? createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final Department? department;
  final List<CourseSubject>? courseSubjects;
  final List<LectureSchedule>? lectureSchedules;

  Course({
    this.id,
    required this.courseName,
    this.description,
    required this.departmentId,
    required this.isActive,
    // this.createdAt,
    // this.updatedAt,
    this.department,
    this.courseSubjects,
    this.lectureSchedules,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      courseName: json['courseName'] as String,
      description: json['description'] as String?,
      departmentId: json['departmentId'] as int,
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      department: json['department'] != null
          ? Department.fromJson(json['department'])
          : null,
      courseSubjects: json['courseSubjects'] != null
          ? (json['courseSubjects'] as List)
              .map((e) => CourseSubject.fromJson(e))
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
      'courseName': courseName,
      'description': description,
      'departmentId': departmentId,
      'isActive': isActive,
      // 'createdAt': createdAt?.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'department': department?.toJson(),
      'courseSubjects': courseSubjects?.map((e) => e.toJson()).toList(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
    };
  }
}
