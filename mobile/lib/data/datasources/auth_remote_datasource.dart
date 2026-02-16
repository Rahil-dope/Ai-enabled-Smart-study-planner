import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRemoteDataSource {
  final Dio _dio = Dio();

  AuthRemoteDataSource() {
    _dio.options.baseUrl = AppConstants.baseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return response.data['data'];
    } on DioException catch (e) {
      throw Exception(e.response?.data['error']['message'] ?? 'Registration failed');
    }
  }
}
