import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/models/project_model.dart';
import '../../../data/services/project_service.dart';
import '../../viewmodels/project_detail_viewmodel.dart';

class ProjectDetailPage extends StatelessWidget {
  final int? projectId; // null = criação

  const ProjectDetailPage({super.key, this.projectId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProjectDetailViewModel>(
      create: (context) => ProjectDetailViewModel(
        context.read<ProjectService>(),
        projectId: projectId,
      ),
      child: const _ProjectDetailScaffold(),
    );
  }
}

class _ProjectDetailScaffold extends StatelessWidget {
  const _ProjectDetailScaffold();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectDetailViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        appBar: _ProjectAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error != null && vm.project == null && vm.isEditing) {
      return Scaffold(
        appBar: const _ProjectAppBar(),
        body: Center(child: Text(vm.error!)),
      );
    }

    return const Scaffold(appBar: _ProjectAppBar(), body: _ProjectForm());
  }
}

class _ProjectAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ProjectAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectDetailViewModel>();

    return AppBar(
      title: Text(vm.isEditing ? 'Editar projeto' : 'Novo projeto'),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          GoRouter.of(context).go('/app/projects');
        },
      ),
    );
  }
}

class _ProjectForm extends StatefulWidget {
  const _ProjectForm();

  @override
  State<_ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<_ProjectForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _clientController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ProjectDetailViewModel>();
    _nameController = TextEditingController(text: vm.name);
    _clientController = TextEditingController(text: vm.client);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clientController.dispose();
    super.dispose();
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    final vm = context.read<ProjectDetailViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    vm.name = _nameController.text;
    vm.client = _clientController.text;

    final error = await vm.save();

    if (error != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    router.go('/app/projects');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProjectDetailViewModel>();
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do projeto',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o nome do projeto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _clientController,
                      decoration: const InputDecoration(labelText: 'Cliente'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe o cliente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: vm.status,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: ProjectStatus.all
                          .map(
                            (s) => DropdownMenuItem<String>(
                              value: s,
                              child: Text(ProjectStatus.label(s)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          vm.status = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: vm.isSaving
                              ? null
                              : () {
                                  GoRouter.of(context).go('/app/projects');
                                },
                          child: const Text('Cancelar'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: vm.isSaving ? null : _onSavePressed,
                          child: vm.isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  vm.isEditing ? 'Salvar alterações' : 'Criar',
                                ),
                        ),
                      ],
                    ),
                    if (vm.project != null && vm.isEditing) ...[
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Criado em: ${_formatDate(vm.project!.createdAt)}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}
