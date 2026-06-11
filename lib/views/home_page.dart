import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/task_controller.dart';
import '../controllers/auth_controller.dart';
import '../controllers/quote_controller.dart';
import '../models/task.dart';
import '../main.dart'; // Pour themeNotifier (Dark Mode sans Provider)
import 'add_task_page.dart';
import 'edit_task_page.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ==============================
  // CONTROLLERS (MVC — pas de DB directe)
  // ==============================
  final TaskController controller = TaskController();
  final AuthController authController = AuthController();
  final QuoteController quoteController = QuoteController();

  // ==============================
  // ÉTAT
  // ==============================
  List<Task> tasks = [];
  bool isLoading = true;
  String userName = "Utilisateur";
  String quoteText = "";
  String quoteAuthor = "";
  String? profileImagePath; // Chemin local de la photo de profil (null = avatar par défaut)

  // ==============================
  // STATISTIQUES (calculées depuis la liste en mémoire — aucune requête DB supplémentaire)
  // ==============================
  int get totalTasks => tasks.length;
  int get completedTasks => tasks.where((t) => t.status == 1).length;
  int get pendingTasks => tasks.where((t) => t.status == 0).length;
  int get highPriorityTasks => tasks.where((t) => t.priority == 3).length;

  @override
  void initState() {
    super.initState();
    loadAll();
  }

  // ==============================
  // CHARGEMENT PRINCIPAL
  // MVC : on passe uniquement par les controllers
  // ==============================
  Future<void> loadAll() async {
    setState(() => isLoading = true);

    // 1. Données utilisateur via AuthController (nom + photo)
    final user = await authController.getUserById(widget.userId);
    userName = user != null ? (user['name'] as String? ?? 'Utilisateur') : 'Utilisateur';
    profileImagePath = user != null ? user['profile_image_path'] as String? : null;

    // 2. Tâches via TaskController
    tasks = await controller.getTasks(widget.userId);

    // 3. Citation du jour via QuoteController (ne bloque pas l'app si erreur réseau)
    final q = await quoteController.fetchQuote();
    quoteText = q['quote']!;
    quoteAuthor = q['author']!;

    setState(() => isLoading = false);
  }

  // ==============================
  // PHOTO DE PROFIL — Sélection depuis la galerie
  // ==============================
  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );

    // L'utilisateur a annulé — on ne fait rien
    if (picked == null) return;

    final success = await authController.updateProfileImage(widget.userId, picked.path);

    if (!mounted) return;

    if (success) {
      setState(() => profileImagePath = picked.path);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Photo de profil mise à jour ✅"),
          backgroundColor: Color(0xFF6C63FF),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la mise à jour de la photo")),
      );
    }
  }

  Future<void> _deleteProfileImage() async {
    final success = await authController.deleteProfileImage(widget.userId);

    if (!mounted) return;

    if (success) {
      setState(() => profileImagePath = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Photo de profil supprimée")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur lors de la suppression de la photo")),
      );
    }
  }

  // Retourne vrai si le fichier image existe vraiment sur l'appareil
  bool _profileImageExists() {
    if (profileImagePath == null) return false;
    try {
      return File(profileImagePath!).existsSync();
    } catch (_) {
      return false; // Ne bloque jamais l'app
    }
  }

  // ==============================
  // COULEUR SELON PRIORITÉ
  // ==============================
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 3:
        return Colors.redAccent;
      case 2:
        return Colors.orangeAccent;
      case 1:
      default:
        return Colors.greenAccent;
    }
  }

  // ==============================
  // CONFIRMATION DE SUPPRESSION
  // ==============================
  Future<void> _confirmDelete(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Text("Supprimer la tâche ?"),
          ],
        ),
        content: Text(
          'Voulez-vous vraiment supprimer "${task.title}" ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await controller.deleteTask(task.id!);
      loadAll();
    }
  }

  // ==============================
  // BUILD PRINCIPAL
  // ==============================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: _buildDrawer(isDark),
      appBar: AppBar(
        title: const Text(
          "TaskFlow",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),
        ),
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
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF6C63FF),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nouvelle tâche", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        elevation: 8,
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskPage(userId: widget.userId)),
          );
          if (result == true) loadAll();
        },
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6C63FF)))
          : RefreshIndicator(
              color: const Color(0xFF6C63FF),
              onRefresh: loadAll,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 100),
                children: [
                  _buildStatsSection(),
                  _buildQuoteCard(),
                  _buildSectionHeader("Mes Tâches", tasks.length),
                  if (tasks.isEmpty)
                    _buildEmptyState()
                  else
                    _buildTaskList(),
                ],
              ),
            ),
    );
  }

  // ==============================
  // DRAWER (menu latéral)
  // ==============================
  Widget _buildDrawer(bool isDark) {
    return Drawer(
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
                // ---- Avatar : image réelle ou icône par défaut ----
                GestureDetector(
                  onTap: _pickProfileImage, // Tap sur l'avatar pour changer la photo
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white,
                        backgroundImage: _profileImageExists()
                            ? FileImage(File(profileImagePath!))
                            : null,
                        child: _profileImageExists()
                            ? null
                            : const Icon(Icons.person, size: 38, color: Color(0xFF6C63FF)),
                      ),
                      // Badge caméra pour indiquer que c'est cliquable
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.photo_library_rounded, size: 14, color: Color(0xFF6C63FF)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "$totalTasks tâche${totalTasks > 1 ? 's' : ''}  •  $completedTasks terminée${completedTasks > 1 ? 's' : ''}",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          // Modifier la photo
          ListTile(
            dense: true,
            leading: const Icon(Icons.photo_library_outlined, color: Color(0xFF6C63FF), size: 22),
            title: const Text("Modifier la photo", style: TextStyle(fontSize: 14)),
            onTap: () async {
              Navigator.pop(context); // Ferme le drawer
              await _pickProfileImage();
            },
          ),

          // Supprimer la photo (visible seulement si une photo existe)
          if (_profileImageExists())
            ListTile(
              dense: true,
              leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
              title: const Text("Supprimer la photo", style: TextStyle(fontSize: 14, color: Colors.redAccent)),
              onTap: () async {
                Navigator.pop(context);
                await _deleteProfileImage();
              },
            ),

          // Accueil
          ListTile(
            leading: const Icon(Icons.home_rounded, color: Color(0xFF6C63FF)),
            title: const Text("Accueil", style: TextStyle(fontWeight: FontWeight.w600)),
            onTap: () => Navigator.pop(context),
          ),

          // Switch Dark Mode
          ListTile(
            leading: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: const Color(0xFF6C63FF),
            ),
            title: Text(
              isDark ? "Mode Sombre" : "Mode Clair",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            trailing: Switch(
              value: isDark,
              activeColor: const Color(0xFF6C63FF),
              onChanged: (val) {
                themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
              },
            ),
          ),

          const Divider(),

          // Déconnexion
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              "Déconnexion",
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
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
    );
  }

  // ==============================
  // SECTION STATISTIQUES (Dashboard)
  // ==============================
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bonjour, $userName 👋",
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            "Voici vos statistiques du jour",
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: "Total",
                  count: totalTasks,
                  icon: Icons.task_alt_rounded,
                  color: const Color(0xFF6C63FF),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  label: "Terminées",
                  count: completedTasks,
                  icon: Icons.check_circle_rounded,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  label: "En cours",
                  count: pendingTasks,
                  icon: Icons.hourglass_top_rounded,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCard(
                  label: "Priorité haute",
                  count: highPriorityTasks,
                  icon: Icons.flag_rounded,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 500),
      builder: (context, val, child) => Opacity(
        opacity: val,
        child: Transform.scale(scale: 0.85 + (0.15 * val), child: child),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$count",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==============================
  // CARTE CITATION DU JOUR (API REST)
  // ==============================
  Widget _buildQuoteCard() {
    if (quoteText.isEmpty) return const SizedBox.shrink();

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, val, child) => Opacity(opacity: val, child: child),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6C63FF), Color(0xFF9D94FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6C63FF).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.format_quote_rounded, color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Text(
                  "Citation du jour",
                  style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              quoteText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontStyle: FontStyle.italic,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "— $quoteAuthor",
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================
  // EN-TÊTE DE SECTION
  // ==============================
  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$count",
              style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ==============================
  // ÉTAT VIDE
  // ==============================
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.task_alt, size: 90, color: Colors.grey.withOpacity(0.25)),
            const SizedBox(height: 20),
            const Text(
              "Aucune tâche pour le moment ✨",
              style: TextStyle(fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            const Text(
              "Appuyez sur + pour commencer",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ==============================
  // LISTE DES TÂCHES (avec animations)
  // ==============================
  Widget _buildTaskList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 8),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 300 + (index * 80)),
          builder: (context, opacity, child) {
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 25 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: _buildTaskCard(task),
        );
      },
    );
  }

  // ==============================
  // CARTE D'UNE TÂCHE
  // ==============================
  Widget _buildTaskCard(Task task) {
    final bool isDone = task.status == 1;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Row(
          children: [
            // Barre de couleur selon priorité
            Container(
              width: 6,
              height: 95,
              color: isDone ? Colors.grey.shade300 : getPriorityColor(task.priority),
            ),

            Expanded(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                leading: Transform.scale(
                  scale: 1.15,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    activeColor: const Color(0xFF6C63FF),
                    value: isDone,
                    onChanged: (v) async {
                      task.status = v! ? 1 : 0;
                      task.progress = v ? 100 : task.progress;
                      await controller.updateTask(task);
                      loadAll();
                    },
                  ),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.grey : null,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        // Badge Catégorie
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            task.category,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Progression (si > 0 et pas terminée)
                        if (task.progress > 0 && !isDone) ...[
                          const SizedBox(width: 8),
                          Text(
                            "${task.progress}%",
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bouton Modifier
                    IconButton(
                      icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF6C63FF), size: 26),
                      tooltip: "Modifier",
                      onPressed: () async {
                        bool? result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditTaskPage(task: task)),
                        );
                        if (result == true) loadAll();
                      },
                    ),
                    // Bouton Supprimer (avec confirmation)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 24),
                      tooltip: "Supprimer",
                      onPressed: () => _confirmDelete(task),
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