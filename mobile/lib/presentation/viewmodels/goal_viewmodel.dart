import 'package:flutter/material.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/models/goal_model.dart';

class GoalViewModel extends ChangeNotifier {
  final GoalRepository _goalRepository = GoalRepository();
  List<Goal> _goals = [];
  Map<String, dynamic>? _stats; // Add stats
  bool _isLoading = false;
  String? _errorMessage;

  List<Goal> get goals => _goals;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadGoals() async {
    _setLoading(true);
    try {
      _goals = await _goalRepository.getGoals();
      _stats = await _goalRepository.getDashboardStats(); // Fetch stats
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createGoal(String title, String description, DateTime deadline, int hours, String knowledge) async {
    _setLoading(true);
    try {
      // 1. Create Goal
      final goal = await _goalRepository.createGoal(title, description, deadline);
      
      // 2. Trigger AI Planning
      await _goalRepository.generatePlan(goal.id, hours, knowledge);

      // 3. Refresh List
      await loadGoals();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false); // Ensure loading is false on error
      return false;
    } 
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _errorMessage = null;
    notifyListeners();
  }
}
