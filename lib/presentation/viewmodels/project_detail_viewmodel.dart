import 'package:flutter/foundation.dart';

import '../../data/models/project_model.dart';
import '../../data/services/project_service.dart';

class ProjectDetailViewModel extends ChangeNotifier {
  final ProjectService _service;
  final int? projectId; // null = criação

  ProjectDetailViewModel(this._service, {this.projectId}) {
    if (projectId != null) {
      _loadProject();
    } else {
      _isLoading = false;
    }
  }

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  ProjectModel? _project;

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  ProjectModel? get project => _project;

  bool get isEditing => projectId != null;

  String name = '';
  String client = '';
  String status = ProjectStatus.active;

  Future<void> _loadProject() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final p = await _service.getById(projectId!);
      _project = p;
      name = p.name;
      client = p.client;
      status = p.status;
    } catch (e) {
      _error = 'Erro ao carregar projeto.';
      if (kDebugMode) {
        print('Erro ao carregar projeto: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> save() async {
    if (name.trim().isEmpty) {
      return 'Nome é obrigatório.';
    }
    if (client.trim().isEmpty) {
      return 'Cliente é obrigatório.';
    }

    _isSaving = true;
    _error = null;
    notifyListeners();

    try {
      if (isEditing) {
        final updated = await _service.updateProject(
          id: projectId!,
          name: name.trim(),
          client: client.trim(),
          status: status,
        );
        _project = updated;
      } else {
        final created = await _service.createProject(
          name: name.trim(),
          client: client.trim(),
          status: status,
        );
        _project = created;
      }

      return null;
    } catch (e) {
      _error = 'Erro ao salvar projeto. Tente novamente.';
      if (kDebugMode) {
        print('Erro ao salvar projeto: $e');
      }
      return _error;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
