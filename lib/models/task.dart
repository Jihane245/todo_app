class Task {
  int? id;
  String title;
  String description;
  String? startDate;
  String? endDate;
  int priority;
  int progress;
  int status;
  int userId;

  // Constructeur principal
  Task({
    this.id,
    required this.title,
    required this.description,
    this.startDate,
    this.endDate,
    required this.priority,
    required this.progress,
    required this.status,
    required this.userId,
  });

  // Fonction pour convertir les données de la base de données (Map) en objet Task
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      startDate: map['start_date'],
      endDate: map['end_date'],
      priority: map['priority'] ?? 1,
      progress: map['progress'] ?? 0,
      status: map['status'] ?? 0,
      userId: map['user_id'],
    );
  }

  // Fonction pour convertir l'objet Task en Map pour la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_date': startDate,
      'end_date': endDate,
      'priority': priority,
      'progress': progress,
      'status': status,
      'user_id': userId,
    };
  }
}