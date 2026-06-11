import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

// Liste des catégories disponibles
const List<String> kCategories = [
  'Général',
  'Travail',
  'Personnel',
  'Études',
  'Santé',
  'Projets',
];

class AddTaskPage extends StatefulWidget {
  final int userId;

  const AddTaskPage({super.key, required this.userId});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskController controller = TaskController();

  DateTime? startDate;
  DateTime? endDate;
  int priority = 1;
  String selectedCategory = 'Général';

  Future<void> pickDate({required bool isStart}) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF6C63FF),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          // Si la date de fin est avant la nouvelle date de début, on la réinitialise
          if (endDate != null && endDate!.isBefore(picked)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) return "Sélectionner";
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        centerTitle: true,
        title: const Text("Nouvelle Tâche", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Form(
            key: formKey,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, val, child) {
                return Opacity(
                  opacity: val,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - val)),
                    child: child,
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Planifiez vos objectifs 🚀", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 25),

                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Titre
                        _buildTextField(
                          controller: titleController,
                          label: "Titre de la tâche",
                          icon: Icons.title_rounded,
                          validatorMessage: "Le titre est requis",
                        ),
                        const SizedBox(height: 20),

                        // Description
                        _buildTextField(
                          controller: descriptionController,
                          label: "Description détaillée",
                          icon: Icons.description_rounded,
                          maxLines: 3,
                          validatorMessage: "La description est requise",
                        ),
                        const SizedBox(height: 25),

                        // Dates
                        Row(
                          children: [
                            Expanded(child: _buildDateButton("Début", startDate, true)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildDateButton("Fin", endDate, false)),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Priorité
                        _buildPriorityDropdown(),
                        const SizedBox(height: 20),

                        // Catégorie
                        _buildCategoryDropdown(),
                        const SizedBox(height: 35),

                        // Bouton d'ajout
                        _buildSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    required String validatorMessage,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) => (value == null || value.trim().isEmpty) ? validatorMessage : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildDateButton(String label, DateTime? date, bool isStart) {
    return InkWell(
      onTap: () => pickDate(isStart: isStart),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(isStart ? Icons.calendar_today : Icons.event_available, color: const Color(0xFF6C63FF)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 4),
            Text(formatDate(date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityDropdown() {
    return DropdownButtonFormField<int>(
      value: priority,
      decoration: InputDecoration(
        labelText: "Priorité",
        prefixIcon: const Icon(Icons.flag_rounded, color: Color(0xFF6C63FF)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
      items: const [
        DropdownMenuItem(value: 1, child: Text("🟢 Basse")),
        DropdownMenuItem(value: 2, child: Text("🟠 Moyenne")),
        DropdownMenuItem(value: 3, child: Text("🔴 Haute")),
      ],
      onChanged: (value) => setState(() => priority = value!),
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: InputDecoration(
        labelText: "Catégorie",
        prefixIcon: const Icon(Icons.label_rounded, color: Color(0xFF6C63FF)),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
      items: kCategories
          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
          .toList(),
      onChanged: (value) => setState(() => selectedCategory = value!),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D94FF)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5)),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            // Validation : date de fin >= date de début
            if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("La date de fin doit être égale ou postérieure à la date de début")),
              );
              return;
            }

            try {
              await controller.addTask(
                Task(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  startDate: startDate?.toIso8601String(),
                  endDate: endDate?.toIso8601String(),
                  priority: priority,
                  progress: 0,
                  status: 0,
                  userId: widget.userId,
                  category: selectedCategory,
                ),
              );

              if (mounted) Navigator.of(context).pop(true);
            } catch (e) {
              debugPrint("Erreur lors de l'ajout : $e");
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_task, color: Colors.white),
              SizedBox(width: 10),
              Text("CRÉER LA TÂCHE", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}