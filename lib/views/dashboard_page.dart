import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';

class DashboardPage extends StatefulWidget {
  final int userId;
  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final TaskController controller = TaskController();
  Map<String, double> stats = {'total': 0, 'completed': 0, 'pending': 0, 'prod': 0};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    final t = await controller.getTotalTasks(widget.userId);
    final c = await controller.getCompletedTasks(widget.userId);
    final p = await controller.getPendingTasks(widget.userId);
    final pr = await controller.getProductivity(widget.userId);
    setState(() {
      stats = {'total': t.toDouble(), 'completed': c.toDouble(), 'pending': p.toDouble(), 'prod': pr};
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistiques"), elevation: 0),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildStatTile("Total Tâches", stats['total']!, Icons.list, Colors.blue),
                _buildStatTile("Complétées", stats['completed']!, Icons.check_circle, Colors.green),
                _buildStatTile("Productivité", stats['prod']!, Icons.trending_up, Colors.purple, isPercent: true),
              ],
            ),
          ),
    );
  }

  Widget _buildStatTile(String title, double value, IconData icon, Color color, {bool isPercent = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: value),
          duration: const Duration(seconds: 1),
          builder: (context, double val, child) {
            return Text(
              isPercent ? "${val.toInt()}%" : "${val.toInt()}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            );
          },
        ),
      ),
    );
  }
}