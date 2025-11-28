import 'package:flutter/foundation.dart';

import '../../data/models/task_model.dart';
import '../../data/services/task_service.dart';

class TaskBoardViewModel extends ChangeNotifier {
  final TaskService _service;
  final int projectId;

  TaskBoardViewModel(this._service, {required this.projectId}) {
    loadTasks();
  }

  bool _isLoading = false;
  bool _isSaving = false;
  String? _error;

  List<TaskModel> _todo = [];
  List<TaskModel> _doing = [];
  List<TaskModel> _done = [];

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;

  List<TaskModel> get todo => _todo;
  List<TaskModel> get doing => _doing;
  List<TaskModel> get done => _done;

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final tasks = await _service.fetchTasksByProject(projectId);
      _splitByStatus(tasks);
    } catch (e) {
      _error = 'Erro ao carregar tarefas.';
      if (kDebugMode) {
        print('Erro ao carregar tarefas: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _splitByStatus(List<TaskModel> tasks) {
    _todo = tasks.where((t) => t.status == TaskStatus.todo).toList();
    _doing = tasks.where((t) => t.status == TaskStatus.doing).toList();
    _done = tasks.where((t) => t.status == TaskStatus.done).toList();
  }

  Future<String?> createTask({
    required String title,
    String? description,
    required String status,
    String? assignee,
    required String priority,
  }) async {
    if (title.trim().isEmpty) {
      return 'Título é obrigatório.';
    }

    _isSaving = true;
    notifyListeners();

    try {
      final task = await _service.createTask(
        projectId: projectId,
        title: title.trim(),
        description: description?.trim().isEmpty == true
            ? null
            : description?.trim(),
        status: status,
        assignee: assignee?.trim().isEmpty == true ? null : assignee?.trim(),
        priority: priority,
      );

      _addToColumn(task);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao criar tarefa: $e');
      }
      return 'Erro ao criar tarefa.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> updateTask(TaskModel task) async {
    if (task.title.trim().isEmpty) {
      return 'Título é obrigatório.';
    }

    _isSaving = true;
    notifyListeners();

    try {
      final updated = await _service.updateTask(task);
      _updateInColumns(updated);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao atualizar tarefa: $e');
      }
      return 'Erro ao atualizar tarefa.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> deleteTask(TaskModel task) async {
    _isSaving = true;
    notifyListeners();

    try {
      await _service.deleteTask(task.id);
      _removeFromColumns(task);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Erro ao deletar tarefa: $e');
      }
      return 'Erro ao deletar tarefa.';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<String?> moveTask(TaskModel task, String newStatus) async {
    final updated = task.copyWith(status: newStatus);
    return updateTask(updated);
  }

  void _addToColumn(TaskModel task) {
    switch (task.status) {
      case TaskStatus.todo:
        _todo.add(task);
        break;
      case TaskStatus.doing:
        _doing.add(task);
        break;
      case TaskStatus.done:
        _done.add(task);
        break;
    }
  }

  void _removeFromColumns(TaskModel task) {
    _todo.removeWhere((t) => t.id == task.id);
    _doing.removeWhere((t) => t.id == task.id);
    _done.removeWhere((t) => t.id == task.id);
  }

  void _updateInColumns(TaskModel task) {
    _removeFromColumns(task);
    _addToColumn(task);
  }
}
