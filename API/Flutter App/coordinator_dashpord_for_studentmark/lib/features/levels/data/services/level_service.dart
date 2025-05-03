import 'package:coordinator_dashpord_for_studentmark/core/services/api_service.dart';
import 'package:coordinator_dashpord_for_studentmark/core/models/level.dart';
import 'package:dio/dio.dart';
import '../../../../config/constants.dart';

class LevelService {
  final ApiService _apiService;

  LevelService(this._apiService);

  Future<List<Level>> getAllLevels() async {
    final Response response = await _apiService.get(AppConstants.levels);
    return (response.data as List).map((json) => Level.fromJson(json)).toList();
  }

  Future<Level> getLevelById(int id) async {
    final Response response =
        await _apiService.get('${AppConstants.levels}/$id');
    return Level.fromJson(response.data);
  }

  Future<List<Level>> getLevelsByDepartment(int departmentId) async {
    final Response response = await _apiService
        .get('${AppConstants.levels}/department/$departmentId');
    return (response.data as List).map((json) => Level.fromJson(json)).toList();
  }

  Future<Level> createLevel(Level level) async {
    final Response response = await _apiService.post(
      AppConstants.levels,
      data: level.toJson(),
    );
    return Level.fromJson(response.data);
  }

  Future<Level> updateLevel(Level level) async {
    final Response response = await _apiService.put(
      '${AppConstants.levels}/${level.id}',
      data: level.toJson(),
    );
    return Level.fromJson(response.data);
  }

  Future<void> deleteLevel(int id) async {
    await _apiService.delete('${AppConstants.levels}/$id');
  }

  Future<void> toggleLevelStatus(int id) async {
    await _apiService.put('${AppConstants.levels}/$id/toggle-status');
  }
}
