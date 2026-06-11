import '../database/database_helper.dart';
import '../models/task.dart';

class TaskController {
  final DatabaseHelper db = DatabaseHelper();

  // =========================
  // LECTURE (READ)
  // =========================
  Future<List<Task>> getTasks(int userId) async {
    final data = await db.getTasksByUser(userId);
    return data.map((e) => Task.fromMap(e)).toList();
  }

  // =========================
  // CRÉATION (CREATE)
  // =========================
  Future<void> addTask(Task task) async {
    await db.insertTask(
      task.title,
      task.description,
      task.startDate,
      task.endDate,
      task.priority,
      task.progress,
      task.status,
      task.userId,
      task.category, // Ajout du champ category
    );
  }

  // =========================
  // MISE À JOUR (UPDATE)
  // =========================
  Future<void> updateTask(Task task) async {
    await db.updateTask(
      task.id!,
      task.title,
      task.description,
      task.startDate,
      task.endDate,
      task.priority,
      task.progress,
      task.status,
      task.category, // Ajout du champ category
    );
  }

  // =========================
  // SUPPRESSION (DELETE)
  // =========================
  Future<void> deleteTask(int id) async {
    await db.deleteTask(id);
  }

  // =========================
  // STATISTIQUES
  // =========================
  Future<int> getTotalTasks(int userId) async {
    final tasks = await getTasks(userId);
    return tasks.length;
  }

  Future<int> getCompletedTasks(int userId) async {
    final tasks = await getTasks(userId);
    return tasks.where((task) => task.status == 1).length;
  }

  Future<int> getPendingTasks(int userId) async {
    final tasks = await getTasks(userId);
    return tasks.where((task) => task.status == 0).length;
  }

  Future<int> getHighPriorityCount(int userId) async {
    final tasks = await getTasks(userId);
    return tasks.where((task) => task.priority == 3).length;
  }

  Future<double> getProductivity(int userId) async {
    final tasks = await getTasks(userId);
    if (tasks.isEmpty) return 0;

    double totalProgress = tasks.fold(0, (sum, task) => sum + task.progress);
    return totalProgress / tasks.length;
  }
}