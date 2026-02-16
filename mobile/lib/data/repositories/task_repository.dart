import '../datasources/task_remote_datasource.dart';
import '../models/task_model.dart';

class TaskRepository {
  final TaskRemoteDataSource _remoteDataSource = TaskRemoteDataSource();

  Future<List<DailyTask>> getTasks(String id, {bool isGoalId = false}) async {
    final data = await _remoteDataSource.getTasks(id, isGoalId: isGoalId);
    return data.map((e) => DailyTask.fromJson(e)).toList();
  }

  Future<void> updateTaskStatus(String taskId, bool isCompleted) async {
    await _remoteDataSource.updateTaskStatus(taskId, isCompleted);
  }
}
