import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';
import 'dashboard_page.dart';
import 'login_page.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  final int userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskController controller = TaskController();
  List<Task> tasks = [];
  bool isLoading = true;
  String userName = "Utilisateur";

  @override
  void initState() {
    super.initState();
    loadUserDataAndTasks();
  }

  Future<void> loadUserDataAndTasks() async {
    setState(() => isLoading = true);
    try {
      final users = await controller.db.getAllUsers();
      final user = users.firstWhere(
        (u) => u['id'] == widget.userId,
        orElse: () => {'name': 'Utilisateur'},
      );
      userName = user['name'];
    } catch (e) {
      userName = "Utilisateur";
    }
    tasks = await controller.getTasks(widget.userId);
    setState(() => isLoading = false);
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 3: return Colors.redAccent;
      case 2: return Colors.orangeAccent;
      case 1:
      default: return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9D94FF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person, size: 35, color: Color(0xFF6C63FF))),
                  const SizedBox(height: 15),
                  Text(userName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Tâches"),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardPage(userId: widget.userId)));
              },
            ),
            const Divider(),
            SwitchListTile(
              secondary: Icon(themeNotifier.value == ThemeMode.light ? Icons.light_mode : Icons.dark_mode),
              title: const Text("Mode Sombre"),
              value: themeNotifier.value == ThemeMode.dark,
              onChanged: (bool value) {
                setState(() {
                  themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text("Déconnexion", style: TextStyle(color: Colors.redAccent)),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text("Mes Tâches", style: TextStyle(fontWeight: FontWeight.bold)), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Nouvelle"),
        onPressed: () async {
          bool? result = await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskPage(userId: widget.userId)));
          if (result == true) loadUserDataAndTasks();
        },
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : (tasks.isEmpty ? _buildEmptyState() : _buildTaskList()),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 100, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text("Aucune tâche pour le moment ✨", style: TextStyle(fontSize: 18, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(tasks[index]);
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    bool isDone = task.status == 1;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: Checkbox(
          activeColor: const Color(0xFF6C63FF),
          value: isDone,
          onChanged: (v) async {
            task.status = v! ? 1 : 0;
            task.progress = v ? 100 : 0;
            await controller.updateTask(task);
            loadUserDataAndTasks();
          },
        ),
        title: Text(task.title, style: TextStyle(decoration: isDone ? TextDecoration.lineThrough : null)),
        subtitle: Text(task.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit_note), onPressed: () async {
              bool? result = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditTaskPage(task: task)));
              if (result == true) loadUserDataAndTasks();
            }),
            IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () async {
              await controller.deleteTask(task.id!);
              loadUserDataAndTasks();
            }),
          ],
        ),
      ),
    );
  }
}