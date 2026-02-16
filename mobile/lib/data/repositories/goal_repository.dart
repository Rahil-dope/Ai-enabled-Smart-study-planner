import '../datasources/goal_remote_datasource.dart';
import '../models/goal_model.dart';

class GoalRepository {
  final GoalRemoteDataSource _remoteDataSource = GoalRemoteDataSource();

  Future<List<Goal>> getGoals() async {
    final data = await _remoteDataSource.getGoals();
    return data.map((e) => Goal.fromJson(e)).toList();
  }

  Future<Goal> createGoal(String title, String description, DateTime deadline) async {
    final data = await _remoteDataSource.createGoal(title, description, deadline);
    return Goal.fromJson(data);
  }

  Future<void> generatePlan(String goalId, int hoursPerDay, String knowledge) async {
    await _remoteDataSource.generatePlan(goalId, hoursPerDay, knowledge);
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    return await _remoteDataSource.getDashboardStats();
  }
}
