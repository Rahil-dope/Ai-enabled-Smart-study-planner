import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/goal_viewmodel.dart';
import '../../core/theme/app_theme.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  int _hoursPerDay = 2;
  String _knowledge = 'Beginner';

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goalViewModel = Provider.of<GoalViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('New Study Goal')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor.withOpacity(0.08),
                      AppTheme.primaryLight.withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('AI-Powered Planning',
                              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          Text('Our AI creates a personalized study schedule',
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Title
              const Text('What do you want to learn?',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Linear Algebra, Flutter, Spanish',
                  prefixIcon: Icon(Icons.school_outlined),
                ),
                validator: (v) => v!.isEmpty ? 'Please enter a topic' : null,
              ),
              const SizedBox(height: 20),

              // Description
              const Text('Description (Optional)',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  hintText: 'Any specific details about what you want to cover...',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 20),

              // Deadline
              const Text('Target Deadline',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: AppTheme.primaryColor, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        _selectedDate.toString().split(' ')[0],
                        style: const TextStyle(fontSize: 15),
                      ),
                      const Spacer(),
                      Text(
                        '${_selectedDate.difference(DateTime.now()).inDays} days',
                        style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Daily Commitment
              const Text('Daily Commitment',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$_hoursPerDay',
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor)),
                        const SizedBox(width: 8),
                        const Text('hours/day',
                            style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                      ],
                    ),
                    Slider(
                      value: _hoursPerDay.toDouble(),
                      min: 1,
                      max: 8,
                      divisions: 7,
                      activeColor: AppTheme.primaryColor,
                      onChanged: (v) =>
                          setState(() => _hoursPerDay = v.toInt()),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Knowledge Level
              const Text('Current Knowledge Level',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _knowledge,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: ['Beginner', 'Intermediate', 'Advanced']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _knowledge = v!),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Generate Button
              SizedBox(
                height: 56,
                child: goalViewModel.isLoading
                    ? Center(
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 8),
                            Text('AI is creating your plan...',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: AppTheme.textSecondary)),
                          ],
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await goalViewModel.createGoal(
                              _titleController.text.trim(),
                              _descController.text.trim(),
                              _selectedDate,
                              _hoursPerDay,
                              _knowledge,
                            );
                            if (success && mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🎉 Study plan created successfully!'),
                                  backgroundColor: AppTheme.successColor,
                                ),
                              );
                              Navigator.pop(context);
                            } else if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      goalViewModel.errorMessage ?? 'Error'),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text('Generate Study Plan'),
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
