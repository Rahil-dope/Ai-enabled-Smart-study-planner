import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/task_viewmodel.dart';
import '../../core/theme/app_theme.dart';

class PlanDetailScreen extends StatefulWidget {
  final String goalId;
  final String goalTitle;

  const PlanDetailScreen(
      {super.key, required this.goalId, required this.goalTitle});

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskViewModel>(context, listen: false)
          .loadTasksByGoal(widget.goalId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final completedCount =
        taskViewModel.tasks.where((t) => t.isCompleted).length;
    final totalCount = taskViewModel.tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.goalTitle),
      ),
      body: taskViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : taskViewModel.tasks.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Progress header
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.primaryColor, AppTheme.primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Progress',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$completedCount / $totalCount days',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    totalCount > 0
                                        ? '${((completedCount / totalCount) * 100).toInt()}%'
                                        : '0%',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: totalCount > 0
                                  ? completedCount / totalCount
                                  : 0,
                              minHeight: 8,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: const AlwaysStoppedAnimation(
                                  Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Task list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        itemCount: taskViewModel.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskViewModel.tasks[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: task.isCompleted
                                    ? AppTheme.successColor.withOpacity(0.3)
                                    : Colors.grey.shade200,
                              ),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                tilePadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                childrenPadding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                leading: GestureDetector(
                                  onTap: () {
                                    taskViewModel.toggleTaskCompletion(
                                        task.id, task.isCompleted);
                                  },
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: task.isCompleted
                                          ? AppTheme.successColor
                                          : Colors.grey.shade200,
                                    ),
                                    child: task.isCompleted
                                        ? const Icon(Icons.check,
                                            color: Colors.white, size: 18)
                                        : null,
                                  ),
                                ),
                                title: Text(
                                  'Day ${task.dayNumber}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: task.isCompleted
                                        ? AppTheme.textSecondary
                                        : AppTheme.textPrimary,
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Icon(Icons.schedule_rounded,
                                        size: 14,
                                        color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Text('${task.estMinutes} min',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary)),
                                    const SizedBox(width: 12),
                                    Icon(Icons.book_outlined,
                                        size: 14,
                                        color: AppTheme.textSecondary),
                                    const SizedBox(width: 4),
                                    Text('${task.topics.length} topics',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: AppTheme.textSecondary)),
                                  ],
                                ),
                                children: task.topics.map((t) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppTheme.primaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(t.name,
                                              style: const TextStyle(
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.accentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.hourglass_empty_rounded,
                size: 48, color: AppTheme.accentColor),
          ),
          const SizedBox(height: 20),
          const Text('No tasks yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text('The AI plan is being generated.\nPull down to refresh.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}
