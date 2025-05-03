import 'package:coordinator_dashpord_for_studentmark/core/models/course_subject.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';

class Subject {
  final int id;
  final String subjectName;
  final String? description;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final List<CourseSubject>? courseSubjects;
  final List<LectureSchedule>? lectureSchedules;

  Subject({
    required this.id,
    required this.subjectName,
    this.description,
    required this.isActive,
    // required this.createdAt,
    // this.updatedAt,
    this.courseSubjects,
    this.lectureSchedules,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['id'] as int,
      subjectName: json['subjectName'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
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
      'subjectName': subjectName,
      'description': description,
      'isActive': isActive,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'courseSubjects': courseSubjects?.map((e) => e.toJson()).toList(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
    };
  }
}
