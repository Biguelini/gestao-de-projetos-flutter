import 'package:gestao_projetos/presentation/pages/projects/project_detail_page.dart';
import 'package:gestao_projetos/presentation/pages/tasks/task_board_page.dart';
import 'package:go_router/go_router.dart';

import 'presentation/pages/auth/login_page.dart';
import 'presentation/pages/shell/app_shell_page.dart';
import 'presentation/pages/projects/projects_list_page.dart';
import 'presentation/pages/settings/settings_page.dart';
import 'presentation/pages/errors/not_found_page.dart';
import 'presentation/viewmodels/auth_state.dart';

class App {
  final AuthState authState;

  App(this.authState);

  GoRouter get router => GoRouter(
    initialLocation: '/login',

    refreshListenable: authState,

    redirect: (context, state) {
      final initialized = authState.isInitialized;
      final loggedIn = authState.isAuthenticated;
      final String loc = state.uri.path;

      if (!initialized) {
        return null;
      }

      final bool loggingIn = loc == '/login';
      final bool inApp = loc.startsWith('/app');

      if (!loggedIn && inApp) {
        return '/login';
      }

      if (loggedIn && loggingIn) {
        return '/app/projects';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const LoginPage()),
      ),

      ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
          key: state.pageKey,
          child: AppShellPage(child: child),
        ),
        routes: [
          GoRoute(
            path: '/app/projects',
            name: 'projects',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProjectsListPage(),
            ),
          ),
          GoRoute(
            path: '/app/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsPage(),
            ),
          ),
          GoRoute(
            path: '/app/projects/new',
            name: 'project_new',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProjectDetailPage(projectId: null),
            ),
          ),
          GoRoute(
            path: '/app/projects/:id',
            name: 'project_detail',
            pageBuilder: (context, state) {
              final idStr = state.pathParameters['id'];
              if (idStr == null) {
                return NoTransitionPage(
                  key: state.pageKey,
                  child: const NotFoundPage(),
                );
              }

              final id = int.parse(
                idStr,
              );

              return NoTransitionPage(
                key: state.pageKey,
                child: ProjectDetailPage(projectId: id),
              );
            },
          ),

          GoRoute(
            path: '/app/projects/:id/board',
            name: 'project_board',
            pageBuilder: (context, state) {
              final idStr = state.pathParameters['id']!;
              final id = int.parse(idStr);
              return NoTransitionPage(
                key: state.pageKey,
                child: TaskBoardPage(projectId: id),
              );
            },
          ),
        ],
      ),
    ],

    errorPageBuilder: (context, state) =>
        NoTransitionPage(key: state.pageKey, child: const NotFoundPage()),
  );
}
