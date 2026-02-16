class Topic {
  final String id;
  final String name;
  final bool isCompleted;

  Topic({required this.id, required this.name, required this.isCompleted});

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['id'],
      name: json['name'],
      isCompleted: json['is_completed'] ?? false,
    );
  }
}

class DailyTask {
  final String id;
  final int dayNumber;
  final int estMinutes;
  final bool isCompleted;
  final List<Topic> topics;

  DailyTask({
    required this.id,
    required this.dayNumber,
    required this.estMinutes,
    required this.isCompleted,
    required this.topics,
  });

  factory DailyTask.fromJson(Map<String, dynamic> json) {
    return DailyTask(
      id: json['id'],
      dayNumber: json['day_number'],
      estMinutes: json['est_minutes'],
      isCompleted: json['is_completed'] ?? false,
      topics: (json['topics'] as List<dynamic>?)
              ?.map((e) => Topic.fromJson(e))
              .toList() ??
          [],
    );
  }
}
