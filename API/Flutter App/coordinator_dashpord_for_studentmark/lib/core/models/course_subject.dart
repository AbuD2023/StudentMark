import 'course.dart';
import 'lecture_schedule.dart';
import 'level.dart';
import 'subject.dart';

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
  final Subject? subject;
  final Level? level;
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
      subject:
          json['subject'] != null ? Subject.fromJson(json['subject']) : null,
      level: json['level'] != null ? Level.fromJson(json['level']) : null,
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

  CourseSubject copyWith({
    int? id,
    int? courseId,
    int? subjectId,
    int? levelId,
    bool? isActive,
    Course? course,
    Subject? subject,
    Level? level,
    List<LectureSchedule>? lectureSchedules,
  }) {
    return CourseSubject(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      subjectId: subjectId ?? this.subjectId,
      levelId: levelId ?? this.levelId,
      isActive: isActive ?? this.isActive,
      course: course ?? this.course,
      subject: subject ?? this.subject,
      level: level ?? this.level,
      lectureSchedules: lectureSchedules ?? this.lectureSchedules,
    );
  }
}
