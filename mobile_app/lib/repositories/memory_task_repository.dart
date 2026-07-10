import '../models/todo_task.dart';
import 'task_repository.dart';

class MemoryTaskRepository implements TaskRepository {
  final List<TodoTask> _tasks = [
    TodoTask(id: 'local-1', title: '学习 Flutter 页面结构'),
    TodoTask(id: 'local-2', title: '接入 Supabase 登录'),
    TodoTask(id: 'local-3', title: '测试电脑手机同步'),
  ];

  int _nextId = 4;

  @override
  Future<List<TodoTask>> listTasks() async {
    return List.unmodifiable(_tasks);
  }

  @override
  Future<TodoTask> addTask(String title) async {
    final task = TodoTask(id: 'local-${_nextId++}', title: title);
    _tasks.insert(0, task);
    return task;
  }

  @override
  Future<TodoTask> toggleTask(TodoTask task) async {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    final updated = task.copyWith(completed: !task.completed);

    if (index != -1) {
      _tasks[index] = updated;
    }

    return updated;
  }

  @override
  Future<void> deleteTask(TodoTask task) async {
    _tasks.removeWhere((item) => item.id == task.id);
  }
}
