class TodoTask {
  TodoTask({
    required this.id,
    required this.title,
    this.dueAt,
    this.reminder = false,
    this.completed = false,
  });

  final String id;
  final String title;
  final DateTime? dueAt;
  final bool reminder;
  final bool completed;

  String get displayTime {
    final value = dueAt;
    if (value == null) {
      return '未设置时间';
    }

    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$month-$day $hour:$minute';
  }

  TodoTask copyWith({
    String? id,
    String? title,
    DateTime? dueAt,
    bool? reminder,
    bool? completed,
  }) {
    return TodoTask(
      id: id ?? this.id,
      title: title ?? this.title,
      dueAt: dueAt ?? this.dueAt,
      reminder: reminder ?? this.reminder,
      completed: completed ?? this.completed,
    );
  }

  factory TodoTask.fromSupabase(Map<String, dynamic> row) {
    return TodoTask(
      id: row['id'] as String,
      title: row['title'] as String,
      dueAt: row['due_at'] == null
          ? null
          : DateTime.parse(row['due_at'] as String).toLocal(),
      reminder: row['reminder'] as bool? ?? false,
      completed: row['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toSupabaseInsert(String userId) {
    return {
      'user_id': userId,
      'title': title,
      'due_at': dueAt?.toUtc().toIso8601String(),
      'reminder': reminder,
      'completed': completed,
    };
  }
}
