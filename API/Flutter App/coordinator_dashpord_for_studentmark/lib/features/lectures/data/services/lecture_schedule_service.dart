import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/lecture_schedule.dart';
import 'package:dio/dio.dart';
import '../../../../config/constants.dart';

class LectureScheduleService {
  final ApiService _apiService;

  LectureScheduleService(this._apiService);

  Future<List<LectureSchedule>> getAllLectureSchedules() async {
    final Response response =
        await _apiService.get(AppConstants.lectureSchedules);
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<LectureSchedule> getLectureScheduleById(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.lectureSchedules}/$id');
    return LectureSchedule.fromJson(response.data);
  }

  Future<List<LectureSchedule>> getLectureSchedulesBySubject(
      int subjectId) async {
    final Response response = await _apiService
        .get('${AppConstants.lectureSchedules}/subject/$subjectId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getLectureSchedulesByDoctor(
      int doctorId) async {
    final Response response = await _apiService
        .get('${AppConstants.lectureSchedules}/doctor/$doctorId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<List<LectureSchedule>> getLectureSchedulesByDepartment(
      int departmentId) async {
    final Response response = await _apiService
        .get('${AppConstants.lectureSchedules}/department/$departmentId');
    return (response.data as List)
        .map((json) => LectureSchedule.fromJson(json))
        .toList();
  }

  Future<LectureSchedule> createLectureSchedule(
      LectureSchedule schedule) async {
    final Response response = await _apiService.post(
      AppConstants.lectureSchedules,
      data: schedule.toJson(),
    );
    return LectureSchedule.fromJson(response.data);
  }

  Future<LectureSchedule> updateLectureSchedule(
      LectureSchedule schedule) async {
    final Response response = await _apiService.put(
      '${AppConstants.lectureSchedules}/${schedule.id}',
      data: schedule.toJson(),
    );
    return LectureSchedule.fromJson(response.data);
  }

  Future<void> deleteLectureSchedule(int id) async {
    await _apiService.delete('${AppConstants.lectureSchedules}/$id');
  }

  Future<void> toggleLectureScheduleStatus(int id) async {
    await _apiService.put('${AppConstants.lectureSchedules}/$id/toggle-status');
  }
}
