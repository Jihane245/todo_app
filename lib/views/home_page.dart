import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'add_task_page.dart';
import 'edit_task_page.dart';

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
  String userName = "Utilisateur"; // Nom par défaut

  @override
  void initState() {
    super.initState();
    loadUserDataAndTasks();
  }

  // Charge le nom de l'utilisateur ET ses tâches
  Future<void> loadUserDataAndTasks() async {
    setState(() => isLoading = true);
    
    // 1. Récupérer le nom de l'utilisateur
    try {
      final users = await controller.db.getAllUsers();
      final user = users.firstWhere(
        (u) => u['id'] == widget.userId, 
        orElse: () => {'name': 'Utilisateur'}
      );
      userName = user['name'];
    } catch (e) {
      userName = "Utilisateur";
    }

    // 2. Récupérer les tâches
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
      backgroundColor: const Color(0xFFF0F4F8),
      
      // ====================
      // MENU LATÉRAL (DRAWER)
      // ====================
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF9D94FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35, color: Color(0xFF6C63FF)),
                  ),
                  const SizedBox(height: 15),
                  // Affichage dynamique du nom de l'utilisateur
                  Text(
                    userName,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF6C63FF)),
              title: const Text("Tâches", style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      appBar: AppBar(
        title: const Text("Mes Tâches", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF9D94FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nouvelle", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 8,
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskPage(userId: widget.userId)),
          );
          if (result == true) loadUserDataAndTasks();
        },
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : tasks.isEmpty
              ? _buildEmptyState()
              : _buildTaskList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 100, color: Colors.grey.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text(
            "Aucune tâche pour le moment ✨",
            style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 15, bottom: 80),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 100)),
          builder: (context, double opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: _buildTaskCard(task),
        );
      },
    );
  }

  Widget _buildTaskCard(Task task) {
    bool isDone = task.status == 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Row(
          children: [
            Container(width: 8, height: 90, color: isDone ? Colors.grey : getPriorityColor(task.priority)),
            
            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                leading: Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    activeColor: const Color(0xFF6C63FF),
                    value: isDone,
                    onChanged: (v) async {
                      task.status = v! ? 1 : 0;
                      task.progress = v ? 100 : task.progress;
                      await controller.updateTask(task);
                      loadUserDataAndTasks();
                    },
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.grey : Colors.black87,
                  ),
                ),
                subtitle: Text(
                  task.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                
                // AJOUT : Row pour inclure les boutons Modifier ET Supprimer
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bouton Modifier
                    IconButton(
                      icon: const Icon(Icons.edit_note, color: Color(0xFF6C63FF), size: 28),
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
                        );
                        if (result == true) loadUserDataAndTasks();
                      },
                    ),
                    // Bouton Supprimer (Corrigé)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent, size: 24),
                      onPressed: () async {
                        await controller.deleteTask(task.id!);
                        loadUserDataAndTasks();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}