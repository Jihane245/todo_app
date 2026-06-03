import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

class EditTaskPage extends StatefulWidget {
  final Task task;

  const EditTaskPage({super.key, required this.task});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  final TaskController controller = TaskController();

  DateTime? startDate;
  DateTime? endDate;
  int priority = 1;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(text: widget.task.description);
    if (widget.task.startDate != null) startDate = DateTime.tryParse(widget.task.startDate!);
    if (widget.task.endDate != null) endDate = DateTime.tryParse(widget.task.endDate!);
    priority = widget.task.priority;
    progress = widget.task.progress.toDouble();
  }

  Future<void> pickDate({required bool isStart}) async {
    DateTime initial = isStart ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now());
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Color(0xFF6C63FF)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) startDate = picked;
        else endDate = picked;
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
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Form(
            key: formKey,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              builder: (context, double val, child) {
                return Opacity(
                  opacity: val,
                  child: Transform.scale(scale: 0.95 + (0.05 * val), child: child),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Modifier Tâche", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
                  const SizedBox(height: 5),
                  const Text("Mettez à jour vos avancées ✨", style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 30),

                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleController,
                          validator: (v) => (v == null || v.isEmpty) ? "Titre requis" : null,
                          decoration: InputDecoration(
                            labelText: "Titre",
                            prefixIcon: const Icon(Icons.title, color: Color(0xFF6C63FF)),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: descriptionController,
                          maxLines: 3,
                          validator: (v) => (v == null || v.isEmpty) ? "Description requise" : null,
                          decoration: InputDecoration(
                            labelText: "Description",
                            prefixIcon: const Icon(Icons.description, color: Color(0xFF6C63FF)),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 25),

                        Row(
                          children: [
                            Expanded(child: _buildDateButton("Début", startDate, true)),
                            const SizedBox(width: 15),
                            Expanded(child: _buildDateButton("Fin", endDate, false)),
                          ],
                        ),
                        const SizedBox(height: 25),

                        DropdownButtonFormField<int>(
                          value: priority,
                          decoration: InputDecoration(
                            labelText: "Priorité",
                            prefixIcon: const Icon(Icons.flag, color: Color(0xFF6C63FF)),
                            filled: true,
                            fillColor: const Color(0xFFF8F9FA),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          ),
                          items: const [
                            DropdownMenuItem(value: 1, child: Text("🟢 Basse")),
                            DropdownMenuItem(value: 2, child: Text("🟠 Moyenne")),
                            DropdownMenuItem(value: 3, child: Text("🔴 Haute")),
                          ],
                          onChanged: (value) => setState(() => priority = value!),
                        ),
                        const SizedBox(height: 30),

                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Progression : ${progress.toInt()}%", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D3142))),
                        ),
                        Slider(
                          value: progress,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          activeColor: const Color(0xFF6C63FF),
                          inactiveColor: const Color(0xFF6C63FF).withOpacity(0.2),
                          label: "${progress.toInt()}%",
                          onChanged: (value) => setState(() => progress = value),
                        ),
                        const SizedBox(height: 30),

                        // Bouton de mise à jour corrigé
                        _buildUpdateButton(),
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

  Widget _buildDateButton(String label, DateTime? date, bool isStart) {
    return InkWell(
      onTap: () => pickDate(isStart: isStart),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(color: const Color(0xFFF8F9FA), borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Icon(isStart ? Icons.calendar_today : Icons.event_available, color: const Color(0xFF6C63FF)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(formatDate(date), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF9D94FF)]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          onPressed: () async {
            if (!formKey.currentState!.validate()) return;

            try {
              widget.task.title = titleController.text;
              widget.task.description = descriptionController.text;
              widget.task.startDate = startDate?.toString();
              widget.task.endDate = endDate?.toString();
              widget.task.priority = priority;
              widget.task.progress = progress.toInt();

              // Logique de complétion automatique
              widget.task.status = (widget.task.progress == 100) ? 1 : 0;

              await controller.updateTask(widget.task);
              
              // Redirection forcée après la mise à jour
              if (mounted) {
                Navigator.of(context).pop(true);
              }
            } catch (e) {
              debugPrint("Erreur lors de la modification : $e");
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text("SAUVEGARDER", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}