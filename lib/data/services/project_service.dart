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

    for (int i = 1; i <= 57; i++) {
      final statusIndex = random.nextInt(3);
      final status = ProjectStatus.all[statusIndex];
      final client = clients[random.nextInt(clients.length)];

      _allProjects.add(
        ProjectModel(
          id: i,
          name: 'Projeto #$i',
          client: client,
          status: status,
          createdAt: DateTime.now().subtract(
            Duration(days: random.nextInt(120)),
          ),
        ),
      );
    }
  }

  Future<PagedResult<ProjectModel>> fetchProjects({
    required int page,
    required int pageSize,
    String? search,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

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
}
