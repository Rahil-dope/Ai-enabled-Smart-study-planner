import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/goal_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../core/theme/app_theme.dart';
import 'create_goal_screen.dart';
import 'plan_detail_screen.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GoalViewModel>(context, listen: false).loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalViewModel = Provider.of<GoalViewModel>(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Smart Study Planner', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            Text(
              'Welcome back! 👋',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout_rounded, size: 20),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        authViewModel.logout();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text('Logout', style: TextStyle(color: AppTheme.errorColor)),
                    ),
                  ],
                ),
              );
            },
          ),
           const SizedBox(width: 8),
        ],
      ),
      body: goalViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () => goalViewModel.loadGoals(),
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Stats Cards Row
                  if (goalViewModel.stats != null) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Active Goals',
                            '${goalViewModel.stats!['activeGoals'] ?? 0}',
                            Icons.flag_rounded,
                            AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Tasks Done',
                            '${goalViewModel.stats!['tasksCompletedToday'] ?? 0}',
                            Icons.check_circle_rounded,
                            AppTheme.successColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Study Time',
                            '${goalViewModel.stats!['totalStudyMinutes'] ?? 0}m',
                            Icons.timer_rounded,
                            AppTheme.accentColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Streak',
                            '${goalViewModel.stats!['streakDays'] ?? 0} days',
                            Icons.local_fire_department_rounded,
                            const Color(0xFFEF4444),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],

                  // Section header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('My Goals',
                          style: Theme.of(context).textTheme.titleLarge),
                      Text('${goalViewModel.goals.length} total',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Goals list
                  if (goalViewModel.goals.isEmpty) _buildEmptyState(),

                  ...goalViewModel.goals.map((goal) {
                    final daysLeft = goal.deadline.difference(DateTime.now()).inDays;
                    final isUrgent = daysLeft <= 7;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Material(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlanDetailScreen(
                                  goalId: goal.id,
                                  goalTitle: goal.title,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.primaryColor.withOpacity(0.15),
                                        AppTheme.primaryLight.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.auto_stories,
                                      color: AppTheme.primaryColor, size: 24),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(goal.title,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_rounded,
                                              size: 13,
                                              color: isUrgent
                                                  ? AppTheme.errorColor
                                                  : AppTheme.textSecondary),
                                          const SizedBox(width: 4),
                                          Text(
                                            daysLeft > 0
                                                ? '$daysLeft days left'
                                                : 'Past deadline',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isUrgent
                                                  ? AppTheme.errorColor
                                                  : AppTheme.textSecondary,
                                              fontWeight: isUrgent
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    goal.status.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.successColor,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded,
                                    color: AppTheme.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateGoalScreen()),
          );
          if (mounted) {
            Provider.of<GoalViewModel>(context, listen: false).loadGoals();
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('New Goal'),
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.rocket_launch_rounded,
                size: 48, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 20),
          Text(
            'No goals yet!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "New Goal" to create your\nfirst AI-powered study plan',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
