class ProjectStatus {
  static const active = 'active';
  static const completed = 'completed';
  static const archived = 'archived';

  static const all = [active, completed, archived];

  static String label(String status) {
    switch (status) {
      case active:
        return 'Ativo';
      case completed:
        return 'Concluído';
      case archived:
        return 'Arquivado';
      default:
        return status;
    }
  }
}

class ProjectModel {
  final int id;
  final String name;
  final String client;
  final String status;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.name,
    required this.client,
    required this.status,
    required this.createdAt,
  });
}
