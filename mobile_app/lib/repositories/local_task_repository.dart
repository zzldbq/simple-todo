import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  static const _storageKey = 'simple_todo_mobile_tasks';

  int _nextId = DateTime.now().millisecondsSinceEpoch;

  @override
  Future<List<TodoTask>> listTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTasks = prefs.getStringList(_storageKey);

    if (rawTasks == null) {
      final seedTasks = [
        TodoTask(id: 'local-1', title: '学习 Flutter 页面结构'),
        TodoTask(id: 'local-2', title: '接入 Supabase 登录'),
        TodoTask(id: 'local-3', title: '测试电脑手机同步'),
      ];
      await _save(seedTasks);
      return seedTasks;
    }

    return rawTasks
        .map((raw) => TodoTask.fromJson(jsonDecode(raw) as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<TodoTask> addTask(String title) async {
    final tasks = await listTasks();
    final task = TodoTask(id: 'local-${_nextId++}', title: title);
    final updatedTasks = [task, ...tasks];
    await _save(updatedTasks);
    return task;
  }

  @override
  Future<TodoTask> toggleTask(TodoTask task) async {
    final tasks = await listTasks();
    final updatedTask = task.copyWith(completed: !task.completed);
    final updatedTasks = [
      for (final item in tasks) item.id == task.id ? updatedTask : item,
    ];
    await _save(updatedTasks);
    return updatedTask;
  }

  @override
  Future<void> deleteTask(TodoTask task) async {
    final tasks = await listTasks();
    final updatedTasks = [
      for (final item in tasks)
        if (item.id != task.id) item,
    ];
    await _save(updatedTasks);
  }

  Future<void> _save(List<TodoTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final rawTasks = [
      for (final task in tasks) jsonEncode(task.toJson()),
    ];
    await prefs.setStringList(_storageKey, rawTasks);
  }
}
