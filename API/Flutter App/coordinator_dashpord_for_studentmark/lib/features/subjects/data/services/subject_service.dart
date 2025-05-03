import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/subject.dart';
import 'package:dio/dio.dart';
import '../../../../config/constants.dart';

class SubjectService {
  final ApiService _apiService;

  SubjectService(this._apiService);

  Future<List<Subject>> getAllSubjects() async {
    final Response response = await _apiService.get(AppConstants.subjects);
    return (response.data as List)
        .map((json) => Subject.fromJson(json))
        .toList();
  }

  Future<Subject> getSubjectById(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.subjects}/$id');
    return Subject.fromJson(response.data);
  }

  Future<List<Subject>> getSubjectsByDepartment(int departmentId) async {
    final Response response = await _apiService
        .get('${AppConstants.subjects}/department/$departmentId');
    return (response.data as List)
        .map((json) => Subject.fromJson(json))
        .toList();
  }

  Future<List<Subject>> getSubjectsByLevel(int levelId) async {
    final Response response =
        await _apiService.get('${AppConstants.subjects}/level/$levelId');
    return (response.data as List)
        .map((json) => Subject.fromJson(json))
        .toList();
  }

  Future<List<Subject>> getSubjectsByCourse(int courseId) async {
    final Response response =
        await _apiService.get('${AppConstants.subjects}/course/$courseId');
    return (response.data as List)
        .map((json) => Subject.fromJson(json))
        .toList();
  }

  Future<Subject> createSubject(Subject subject) async {
    final Response response = await _apiService.post(
      AppConstants.subjects,
      data: subject.toJson(),
    );
    return Subject.fromJson(response.data);
  }

  Future<Subject> updateSubject(Subject subject) async {
    final Response response = await _apiService.put(
      '${AppConstants.subjects}/${subject.id}',
      data: subject.toJson(),
    );
    return Subject.fromJson(response.data);
  }

  Future<void> deleteSubject(int id) async {
    await _apiService.delete('${AppConstants.subjects}/$id');
  }

  Future<void> toggleSubjectStatus(int id) async {
    await _apiService.put('${AppConstants.subjects}/$id/toggle-status');
  }
}
