import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoalRemoteDataSource {
  final Dio _dio = Dio();

  GoalRemoteDataSource() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  Future<List<dynamic>> getGoals() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/goals',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Failed to fetch goals');
    }
  }

  Future<Map<String, dynamic>> createGoal(String title, String description, DateTime deadline) async {
    try {
      final token = await _getToken();
      final response = await _dio.post(
        '/goals',
        data: {
          'title': title,
          'description': description,
          'deadline': deadline.toIso8601String(),
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Failed to create goal');
    }
  }

  Future<Map<String, dynamic>> generatePlan(String goalId, int hoursPerDay, String knowledge) async {
     try {
      final token = await _getToken();
      final response = await _dio.post(
        '/ai/generate-plan',
        data: {
          'goalId': goalId,
          'hoursPerDay': hoursPerDay,
          'existingKnowledge': knowledge
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Failed to generate plan');
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final token = await _getToken();
      final response = await _dio.get(
        '/dashboard',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Failed to fetch stats');
    }
  }
}
