import 'dart:math';
import '../models/project_model.dart';

class PagedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  PagedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });
}

class ProjectService {
  final List<ProjectModel> _allProjects = [];

  ProjectService() {
    _seedFakeData();
  }

  int _generateNextId() {
    if (_allProjects.isEmpty) return 1;
    final maxId = _allProjects.map((p) => p.id).reduce(max);
    return maxId + 1;
  }

  void _seedFakeData() {
    if (_allProjects.isNotEmpty) return;

    final random = Random();
    final clients = [
      'Acme Corp',
      'Globex',
      'InovaTech',
      'StartUPX',
      'Loja do Zé',
    ];

    for (int i = 0; i < 20; i++) {
      final statusIndex = random.nextInt(ProjectStatus.all.length);
      final status = ProjectStatus.all[statusIndex];
      final client = clients[random.nextInt(clients.length)];

      final id = _generateNextId();

      final project = ProjectModel(
        id: id,
        name: 'Projeto #$id',
        client: client,
        status: status,
        createdAt: DateTime.now().subtract(Duration(days: random.nextInt(120))),
      );

      _allProjects.add(project);
    }
  }

  Future<PagedResult<ProjectModel>> fetchProjects({
    required int page,
    required int pageSize,
    String? search,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    Iterable<ProjectModel> filtered = _allProjects;

    if (search != null && search.trim().isNotEmpty) {
      final term = search.trim().toLowerCase();
      filtered = filtered.where(
        (p) =>
            p.name.toLowerCase().contains(term) ||
            p.client.toLowerCase().contains(term),
      );
    }

    if (status != null && status.isNotEmpty) {
      filtered = filtered.where((p) => p.status == status);
    }

    final total = filtered.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = min(startIndex + pageSize, total);

    final items = startIndex >= total
        ? <ProjectModel>[]
        : filtered.toList().sublist(startIndex, endIndex);

    return PagedResult<ProjectModel>(
      items: items,
      totalCount: total,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<ProjectModel> getById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final project = _allProjects.firstWhere(
      (p) => p.id == id,
      orElse: () => throw Exception('Projeto não encontrado'),
    );
    return project;
  }

  Future<ProjectModel> createProject({
    required String name,
    required String client,
    required String status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final id = _generateNextId();

    final project = ProjectModel(
      id: id,
      name: name,
      client: client,
      status: status,
      createdAt: DateTime.now(),
    );

    _allProjects.add(project);
    return project;
  }

  Future<ProjectModel> updateProject({
    required int id,
    required String name,
    required String client,
    required String status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final index = _allProjects.indexWhere((p) => p.id == id);
    if (index == -1) {
      throw Exception('Projeto não encontrado');
    }

    final existing = _allProjects[index];

    final updated = ProjectModel(
      id: existing.id,
      name: name,
      client: client,
      status: status,
      createdAt: existing.createdAt,
    );

    _allProjects[index] = updated;
    return updated;
  }

  Future<void> deleteProject(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _allProjects.removeWhere((p) => p.id == id);
  }
}
