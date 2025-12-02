import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../../widgets/app_sidebar.dart';

class AppShellPage extends StatelessWidget {
  final Widget child;

  const AppShellPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 900;

        if (isWide) {
          return Scaffold(
            body: Row(
              children: [
                const SizedBox(width: 260, child: AppSidebar()),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Container(
                    color: cs.surface,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          int currentIndex = 0;
          final location = GoRouterState.of(context).uri.toString();

          if (location.startsWith('/app/settings')) {
            currentIndex = 1;
          } else {
            currentIndex = 0;
          }

          return Scaffold(
            appBar: AppBar(title: const Text('Project Dashboard')),
            body: child,
            bottomNavigationBar: NavigationBar(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                switch (index) {
                  case 0:
                    context.go('/app/projects');
                    break;
                  case 1:
                    context.go('/app/settings');
                    break;
                }
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Symbols.view_kanban),
                  label: 'Projetos',
                ),
                NavigationDestination(
                  icon: Icon(Symbols.settings_rounded),
                  label: 'Configurações',
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
