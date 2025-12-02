import 'package:flutter/material.dart';
import 'package:gestao_projetos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/project_model.dart';
import '../../../data/services/project_service.dart';
import '../../viewmodels/project_list_viewmodel.dart';

class ProjectsListPage extends StatelessWidget {
  const ProjectsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider<ProjectListViewModel>(
      create: (context) => ProjectListViewModel(context.read<ProjectService>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Projetos'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _FiltersBar(colorScheme: colorScheme),
              const SizedBox(height: 16),
              const Expanded(child: _ProjectList()),
              const SizedBox(height: 8),
              const _PaginationBar(),
            ],
          ),
        ),
      ),
    );
  }
}

class _FiltersBar extends StatelessWidget {
  final ColorScheme colorScheme;

  const _FiltersBar({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectListViewModel>();
    final router = GoRouter.of(context);

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar por nome ou cliente',
              prefixIcon: Icon(Symbols.search),
            ),
            onChanged: vm.updateSearch,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String?>(
            initialValue: vm.statusFilter,
            decoration: const InputDecoration(labelText: 'Status'),
            isExpanded: true,
            items: [
              const DropdownMenuItem<String?>(
                value: null,
                child: Text('Todos'),
              ),
              ...ProjectStatus.all.map(
                (status) => DropdownMenuItem<String?>(
                  value: status,
                  child: Text(ProjectStatus.label(status)),
                ),
              ),
            ],
            onChanged: vm.updateStatusFilter,
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'Recarregar',
          onPressed: vm.isLoading ? null : () => vm.refresh(),
          icon: Icon(Symbols.refresh, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () {
            router.go('/app/projects/new');
          },
          icon: const Icon(Symbols.add),
          label: const Text('Novo projeto'),
        ),
      ],
    );
  }
}

class _ProjectList extends StatelessWidget {
  const _ProjectList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectListViewModel>();
    final projects = vm.projects;

    if (vm.isLoading && projects.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(vm.error!),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: vm.refresh,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (projects.isEmpty) {
      return const Center(child: Text('Nenhum projeto encontrado'));
    }

    return ListView.separated(
      itemCount: projects.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final project = projects[index];
        return _ProjectTile(project: project);
      },
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final ProjectModel project;

  const _ProjectTile({required this.project});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final router = GoRouter.of(context);

    return ListTile(
      onTap: () {
        router.go('/app/projects/${project.id}');
      },
      title: Text(project.name),
      subtitle: Text('${project.client} • ${_formatDate(project.createdAt)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Ver board',
            icon: const Icon(Symbols.view_kanban),
            onPressed: () {
              router.go('/app/projects/${project.id}/board');
            },
          ),
          Chip(
            label: Text(
              ProjectStatus.label(project.status),
              style: const TextStyle(fontSize: 12, color: AppColors.lightBg),
            ),
            backgroundColor: _statusColor(project.status, colorScheme),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color _statusColor(String status, ColorScheme cs) {
    switch (status) {
      case ProjectStatus.active:
        return AppColors.purpleSoft;
      case ProjectStatus.completed:
        return AppColors.success;
      case ProjectStatus.archived:
        return AppColors.orange;
      default:
        return AppColors.purpleSoft;
    }
  }
}

class _PaginationBar extends StatelessWidget {
  const _PaginationBar();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectListViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total: ${vm.totalCount} projetos',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Row(
          children: [
            Text('Página ${vm.page} de ${vm.totalPages}'),
            const SizedBox(width: 12),
            IconButton(
              onPressed: vm.hasPrevPage ? vm.goToPrevPage : null,
              icon: const Icon(Symbols.chevron_left),
            ),
            IconButton(
              onPressed: vm.hasNextPage ? vm.goToNextPage : null,
              icon: const Icon(Symbols.chevron_right),
            ),
          ],
        ),
      ],
    );
  }
}
