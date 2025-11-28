import 'package:flutter/material.dart';
import 'package:gestao_projetos/core/theme/app_theme.dart';
import 'package:gestao_projetos/data/services/project_service.dart';
import 'package:provider/provider.dart';

import 'url_strategy.dart';
import 'app.dart';
import 'data/services/auth_service.dart';
import 'presentation/viewmodels/auth_state.dart';

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
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final router = App(authState).router;

    return MaterialApp.router(
      title: 'Project Dashboard',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
    );
  }
}
