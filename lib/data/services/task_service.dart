import 'dart:math';

import '../models/task_model.dart';

class TaskService {
  final List<TaskModel> _tasks = [];

  TaskService() {
    _seedFakeData();
  }

  int _generateNextId() {
    if (_tasks.isEmpty) return 1;
    final maxId = _tasks.map((t) => t.id).reduce(max);
    return maxId + 1;
  }

  void _seedFakeData() {
    if (_tasks.isNotEmpty) return;

    final random = Random();

    for (int projectId = 1; projectId <= 5; projectId++) {
      for (int i = 0; i < 8; i++) {
        final status = TaskStatus.all[random.nextInt(TaskStatus.all.length)];
        final priority =
            TaskPriority.all[random.nextInt(TaskPriority.all.length)];

        final id = _generateNextId();

        _tasks.add(
          TaskModel(
            id: id,
            projectId: projectId,
            title: 'Tarefa $id do Projeto $projectId',
            description: 'Descrição da tarefa $id do projeto $projectId',
            status: status,
            assignee: random.nextBool() ? 'Dev ${random.nextInt(5) + 1}' : null,
            priority: priority,
            createdAt: DateTime.now().subtract(
              Duration(days: random.nextInt(30)),
            ),
          ),
        );
      }
    }
  }

  Future<List<TaskModel>> fetchTasksByProject(int projectId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _tasks.where((t) => t.projectId == projectId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<TaskModel> createTask({
    required int projectId,
    required String title,
    String? description,
    required String status,
    String? assignee,
    required String priority,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final id = _generateNextId();

    final task = TaskModel(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      status: status,
      assignee: assignee,
      priority: priority,
      createdAt: DateTime.now(),
    );

    _tasks.add(task);
    return task;
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) {
      throw Exception('Tarefa não encontrada');
    }

    _tasks[index] = task;
    return task;
  }

  Future<void> deleteTask(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tasks.removeWhere((t) => t.id == id);
  }
}
