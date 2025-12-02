import 'package:flutter/material.dart';
import 'package:gestao_projetos/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';

import '../../../data/models/task_model.dart';
import '../../../data/services/task_service.dart';
import '../../viewmodels/task_board_viewmodel.dart';

class TaskBoardPage extends StatelessWidget {
  final int projectId;

  const TaskBoardPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskBoardViewModel>(
      create: (context) =>
          TaskBoardViewModel(context.read<TaskService>(), projectId: projectId),
      child: const _TaskBoardScaffold(),
    );
  }
}

class _TaskBoardScaffold extends StatelessWidget {
  const _TaskBoardScaffold();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskBoardViewModel>();
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Board do projeto #${vm.projectId}'),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Symbols.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/app/projects');
          },
        ),
        actions: [
          IconButton(
            onPressed: vm.isLoading ? null : () => vm.loadTasks(),
            icon: const Icon(Symbols.refresh),
          ),
        ],
      ),
      body:
          vm.isLoading && vm.todo.isEmpty && vm.doing.isEmpty && vm.done.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: const [
                  Expanded(child: _TaskColumn(status: TaskStatus.todo)),
                  SizedBox(width: 8),
                  Expanded(child: _TaskColumn(status: TaskStatus.doing)),
                  SizedBox(width: 8),
                  Expanded(child: _TaskColumn(status: TaskStatus.done)),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        onPressed: () async {
          await _showTaskDialog(context);
        },
        icon: const Icon(Symbols.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

class _TaskColumn extends StatelessWidget {
  final String status;

  const _TaskColumn({required this.status});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TaskBoardViewModel>();
    final cs = Theme.of(context).colorScheme;

    List<TaskModel> tasks;
    String title;
    Color headerColor;

    switch (status) {
      case TaskStatus.todo:
        tasks = vm.todo;
        title = 'A Fazer';
        headerColor = AppColors.purpleSoft;
        break;
      case TaskStatus.doing:
        tasks = vm.doing;
        title = 'Em Progresso';
        headerColor = AppColors.orange;
        break;
      case TaskStatus.done:
        tasks = vm.done;
        title = 'Concluído';
        headerColor = AppColors.success;
        break;
      default:
        tasks = const [];
        title = status;
        headerColor = AppColors.purpleSoft;
    }

    return DragTarget<TaskModel>(
      onWillAccept: (task) => task != null && task.status != status,
      onAccept: (task) {
        vm.moveTask(task, status);
      },
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return Card(
          elevation: isHovering ? 4 : 2,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: headerColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  '$title (${tasks.length})',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (isHovering)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    'Solte aqui para mover',
                    style: TextStyle(fontSize: 10, fontStyle: FontStyle.italic),
                  ),
                ),
              const SizedBox(height: 4),
              Expanded(
                child: tasks.isEmpty
                    ? const Center(
                        child: Text(
                          'Sem tarefas',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return _DraggableTaskCard(task: task);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DraggableTaskCard extends StatelessWidget {
  final TaskModel task;

  const _DraggableTaskCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TaskBoardViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    Future<void> handleMove(String newStatus) async {
      final error = await vm.moveTask(task, newStatus);
      if (error != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error)));
      }
    }

    Future<void> handleDelete() async {
      final error = await vm.deleteTask(task);
      if (error != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(error)));
      }
    }

    return Draggable<TaskModel>(
      data: task,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 260),
          child: _TaskCardContent(
            task: task,
            isDraggingPreview: true,
            onMoveStatus: null,
            onDelete: null,
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.4,
        child: _TaskCardContent(
          task: task,
          onMoveStatus: handleMove,
          onDelete: handleDelete,
        ),
      ),
      child: _TaskCardContent(
        task: task,
        onMoveStatus: handleMove,
        onDelete: handleDelete,
      ),
    );
  }
}

class _TaskCardContent extends StatelessWidget {
  final TaskModel task;
  final bool isDraggingPreview;
  final Future<void> Function(String newStatus)? onMoveStatus;
  final Future<void> Function()? onDelete;

  const _TaskCardContent({
    required this.task,
    this.isDraggingPreview = false,
    this.onMoveStatus,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),

      child: InkWell(
        onTap: isDraggingPreview
            ? null
            : () async {
                await _showTaskDialog(context, task: task);
              },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              if (task.assignee != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Responsável: ${task.assignee}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 4),
              Row(
                children: [
                  Chip(
                    label: Text(
                      TaskPriority.label(task.priority),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.lightBg,
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: _priorityColor(task.priority, cs),
                  ),
                  const Spacer(),
                  if (!isDraggingPreview &&
                      onMoveStatus != null &&
                      onDelete != null)
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value.startsWith('status:')) {
                          final newStatus = value.split(':')[1];
                          await onMoveStatus!(newStatus);
                        } else if (value == 'delete') {
                          await onDelete!();
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'status:todo',
                          child: Text('Mover para A Fazer'),
                        ),
                        PopupMenuItem(
                          value: 'status:doing',
                          child: Text('Mover para Em Progresso'),
                        ),
                        PopupMenuItem(
                          value: 'status:done',
                          child: Text('Mover para Concluído'),
                        ),
                        PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text(
                            'Excluir',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String priority, ColorScheme cs) {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.danger;
      case TaskPriority.medium:
        return AppColors.orange;
      case TaskPriority.low:
        return AppColors.success;
      default:
        return AppColors.danger;
    }
  }
}

Future<void> _showTaskDialog(BuildContext context, {TaskModel? task}) async {
  final vm = context.read<TaskBoardViewModel>();
  final messenger = ScaffoldMessenger.of(context);

  final titleController = TextEditingController(text: task?.title ?? '');
  final descriptionController = TextEditingController(
    text: task?.description ?? '',
  );
  final assigneeController = TextEditingController(text: task?.assignee ?? '');
  String status = task?.status ?? TaskStatus.todo;
  String priority = task?.priority ?? TaskPriority.medium;

  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(task == null ? 'Nova tarefa' : 'Editar tarefa'),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: assigneeController,
                  decoration: const InputDecoration(labelText: 'Responsável'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: status,
                  items: TaskStatus.all
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(TaskStatus.label(s)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      status = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Status'),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: priority,
                  items: TaskPriority.all
                      .map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(TaskPriority.label(p)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      priority = value;
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Prioridade'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text;
              final description = descriptionController.text;
              final assignee = assigneeController.text.isEmpty
                  ? null
                  : assigneeController.text;

              String? error;
              if (task == null) {
                error = await vm.createTask(
                  title: title,
                  description: description,
                  status: status,
                  assignee: assignee,
                  priority: priority,
                );
              } else {
                final updated = task.copyWith(
                  title: title,
                  description: description.isEmpty ? null : description,
                  assignee: assignee,
                  status: status,
                  priority: priority,
                );
                error = await vm.updateTask(updated);
              }

              if (error != null) {
                messenger
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(error)));
                return;
              }

              Navigator.of(context).pop();
            },
            child: const Text('Salvar'),
          ),
        ],
      );
    },
  );
}
