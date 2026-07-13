import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/todo_task.dart';
import 'task_repository.dart';

class SupabaseTaskRepository implements TaskRepository {
  SupabaseTaskRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<TodoTask>> listTasks() async {
    final rows = await _client
        .from('tasks')
        .select()
        .order('created_at', ascending: false);

    return rows.map(TodoTask.fromSupabase).toList();
  }

  @override
  Future<TodoTask> addTask(
    String title, {
    DateTime? dueAt,
    bool reminder = false,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const AuthException('请先登录');
    }

    final task = TodoTask(
      id: 'pending',
      title: title,
      dueAt: dueAt,
      reminder: reminder,
    );
    final row = await _client
        .from('tasks')
        .insert(task.toSupabaseInsert(userId))
        .select()
        .single();

    return TodoTask.fromSupabase(row);
  }

  @override
  Future<TodoTask> toggleTask(TodoTask task) async {
    final row = await _client
        .from('tasks')
        .update({'completed': !task.completed})
        .eq('id', task.id)
        .select()
        .single();

    return TodoTask.fromSupabase(row);
  }

  @override
  Future<void> deleteTask(TodoTask task) async {
    await _client.from('tasks').delete().eq('id', task.id);
  }
}
