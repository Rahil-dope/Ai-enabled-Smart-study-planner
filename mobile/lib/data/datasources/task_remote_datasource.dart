import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRemoteDataSource {
  final Dio _dio = Dio();

  TaskRemoteDataSource() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<List<dynamic>> getTasks(String id, {bool isGoalId = false}) async {
    try {
      final token = await _getToken();
      final queryParams = isGoalId ? {'goalId': id} : {'planId': id};
      final response = await _dio.get(
        '/tasks',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Failed to fetch tasks');
    }
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    try {
      final token = await _getToken();
      await _dio.put(
        '/tasks/$taskId',
        data: {'isCompleted': isCompleted},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Failed to update task');
    }
  }
}
