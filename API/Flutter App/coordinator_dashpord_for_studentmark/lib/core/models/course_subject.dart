import 'lecture_schedule.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/course.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart'
    as core;
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart'
    as core;

class CourseSubject {
  final int id;
  final int courseId;
  final int subjectId;
  final int levelId;
  final bool isActive;
  // final DateTime createdAt;
  // final DateTime? updatedAt;

  // Navigation properties
  final Course? course;
  final core.Subject? subject;
  final core.Level? level;
  final List<LectureSchedule>? lectureSchedules;

  CourseSubject({
    required this.id,
    required this.courseId,
    required this.subjectId,
    required this.levelId,
    required this.isActive,
    // required this.createdAt,
    // this.updatedAt,
    this.course,
    this.subject,
    this.level,
    this.lectureSchedules,
  });

  factory CourseSubject.fromJson(Map<String, dynamic> json) {
    return CourseSubject(
      id: json['id'] as int,
      courseId: json['courseId'] as int,
      subjectId: json['subjectId'] as int,
      levelId: json['levelId'] as int,
      isActive: json['isActive'] as bool,
      // createdAt: DateTime.parse(json['createdAt'] as String),
      // updatedAt: json['updatedAt'] != null
      //     ? DateTime.parse(json['updatedAt'] as String)
      //     : null,
      course: json['course'] != null ? Course.fromJson(json['course']) : null,
      subject: json['subject'] != null
          ? core.Subject.fromJson(json['subject'])
          : null,
      level: json['level'] != null ? core.Level.fromJson(json['level']) : null,
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
      'courseId': courseId,
      'subjectId': subjectId,
      'levelId': levelId,
      'isActive': isActive,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
      'course': course?.toJson(),
      'subject': subject?.toJson(),
      'level': level?.toJson(),
      'lectureSchedules': lectureSchedules?.map((e) => e.toJson()).toList(),
    };
  }
}
