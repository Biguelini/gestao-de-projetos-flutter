class TaskStatus {
  static const todo = 'todo';
  static const doing = 'doing';
  static const done = 'done';

  static const all = [todo, doing, done];

  static String label(String status) {
    switch (status) {
      case todo:
        return 'A Fazer';
      case doing:
        return 'Em Progresso';
      case done:
        return 'Concluída';
      default:
        return status;
    }
  }
}

class TaskPriority {
  static const low = 'low';
  static const medium = 'medium';
  static const high = 'high';

  static const all = [low, medium, high];

  static String label(String priority) {
    switch (priority) {
      case low:
        return 'Baixa';
      case medium:
        return 'Média';
      case high:
        return 'Alta';
      default:
        return priority;
    }
  }
}

class TaskModel {
  final int id;
  final int projectId;
  final String title;
  final String? description;
  final String status;
  final String? assignee;
  final String priority;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.projectId,
    required this.title,
    this.description,
    required this.status,
    this.assignee,
    required this.priority,
    required this.createdAt,
  });

  TaskModel copyWith({
    int? id,
    int? projectId,
    String? title,
    String? description,
    String? status,
    String? assignee,
    String? priority,
    DateTime? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      assignee: assignee ?? this.assignee,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
