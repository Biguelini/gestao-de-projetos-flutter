import 'package:flutter/material.dart';
import 'package:gestao_projetos/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/services/auth_service.dart';
import 'data/services/project_service.dart';
import 'data/services/task_service.dart';
import 'presentation/viewmodels/auth_state.dart';
import 'presentation/viewmodels/theme_state.dart';
import 'url_strategy.dart';

void main() {
  configureUrlStrategy();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<AuthState>(
          create: (context) => AuthState(context.read<AuthService>()),
        ),
        Provider<ProjectService>(create: (_) => ProjectService()),
        Provider<TaskService>(create: (_) => TaskService()),

        ChangeNotifierProvider<ThemeState>(create: (_) => ThemeState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late App app;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final authState = context.read<AuthState>();

    app = App(authState);
  }

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeState>();

    return MaterialApp.router(
      title: 'Project Dashboard',
      debugShowCheckedModeBanner: false,
      routerConfig: app.router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode,
    );
  }
}
