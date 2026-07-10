import '../models/todo_task.dart';

abstract class TaskRepository {
  Future<List<TodoTask>> listTasks();

  Future<TodoTask> addTask(String title);

  Future<TodoTask> toggleTask(TodoTask task);

  Future<void> deleteTask(TodoTask task);
}
