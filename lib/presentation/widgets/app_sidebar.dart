import 'package:flutter/material.dart';
import 'package:gestao_projetos/presentation/viewmodels/auth_state.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.toString();

    return Container(
      color: colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.dashboard_customize_outlined,
                color: colorScheme.primary,
              ),
              title: const Text('Project Dashboard'),
            ),
            const Divider(),
            _SidebarItem(
              icon: Icons.view_kanban_outlined,
              label: 'Projetos',
              selected: location.startsWith('/app/projects'),
              onTap: () => context.go('/app/projects'),
            ),
            _SidebarItem(
              icon: Icons.settings_outlined,
              label: 'Configurações',
              selected: location.startsWith('/app/settings'),
              onTap: () => context.go('/app/settings'),
            ),
            const Spacer(),
            _SidebarItem(
              icon: Icons.logout_outlined,
              label: 'Sair',
              selected: false,
              onTap: () async {
                final auth = context.read<AuthState>();
                final router = GoRouter.of(context);

                await auth.logout();

                router.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      onTap: onTap,
    );
  }
}
