import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/models/project_model.dart';
import '../../data/services/project_service.dart';

class ProjectListViewModel extends ChangeNotifier {
  final ProjectService _service;

  ProjectListViewModel(this._service) {
    loadFirstPage();
  }

  final int _pageSize = 10;

  List<ProjectModel> _projects = [];
  int _page = 1;
  int _totalCount = 0;
  bool _isLoading = false;
  String? _error;

  String _search = '';
  String? _statusFilter;

  Timer? _searchDebounce;

  List<ProjectModel> get projects => _projects;
  int get page => _page;
  int get totalCount => _totalCount;
  int get pageSize => _pageSize;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get search => _search;
  String? get statusFilter => _statusFilter;

  int get totalPages =>
      (_totalCount == 0) ? 1 : ((_totalCount - 1) ~/ _pageSize) + 1;

  bool get hasPrevPage => _page > 1;
  bool get hasNextPage => _page < totalPages;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> loadFirstPage() async {
    _page = 1;
    await _loadPage();
  }

  Future<void> goToNextPage() async {
    if (!hasNextPage) return;
    _page++;
    await _loadPage();
  }

  Future<void> goToPrevPage() async {
    if (!hasPrevPage) return;
    _page--;
    await _loadPage();
  }

  Future<void> refresh() async {
    await _loadPage();
  }

  void updateSearch(String value) {
    _search = value;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      loadFirstPage();
    });
  }

  void updateStatusFilter(String? status) {
    _statusFilter = status;
    loadFirstPage();
  }

  Future<void> _loadPage() async {
    _setLoading(true);
    _error = null;

    try {
      final result = await _service.fetchProjects(
        page: _page,
        pageSize: _pageSize,
        search: _search,
        status: _statusFilter,
      );

      _projects = result.items;
      _totalCount = result.totalCount;
    } catch (e) {
      _error = 'Erro ao carregar projetos. Tente novamente.';
      if (kDebugMode) {
        print('Erro ao buscar projetos: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }
}
