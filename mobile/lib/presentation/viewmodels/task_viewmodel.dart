import 'package:flutter/material.dart';
import '../../data/repositories/task_repository.dart';
import '../../data/models/task_model.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();
  List<DailyTask> _tasks = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DailyTask> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTasksByGoal(String goalId) async {
    _setLoading(true);
    try {
      _tasks = await _taskRepository.getTasks(goalId, isGoalId: true); 
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadTasks(String planId) async {
    _setLoading(true);
    try {
      _tasks = await _taskRepository.getTasks(planId, isGoalId: false);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTaskCompletion(String taskId, bool currentValue) async {
    // Optimistic Update
    final index = _tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      final oldTask = _tasks[index];
      _tasks[index] = DailyTask(
        id: oldTask.id,
        dayNumber: oldTask.dayNumber,
        estMinutes: oldTask.estMinutes,
        isCompleted: !currentValue,
        topics: oldTask.topics, // Keep topics as is
      );
      notifyListeners();

      try {
        await _taskRepository.updateTaskStatus(taskId, !currentValue);
      } catch (e) {
        // Revert on failure
        _tasks[index] = oldTask;
        notifyListeners();
        // Show error?
      }
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}
