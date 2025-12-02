import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Aparência', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              const _ThemeCard(),
              const SizedBox(height: 24),
              Text(
                'Sobre o app',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Symbols.info_i_rounded),
                  title: const Text('Versão'),
                  subtitle: const Text('1.0.0 (fake dev build)'),
                  trailing: Icon(Symbols.code, color: cs.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard();

  @override
  Widget build(BuildContext context) {
    final themeState = context.watch<ThemeState>();
    final current = themeState.themeMode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Symbols.pallet_rounded),
              title: const Text('Tema'),
              subtitle: Text(_labelForMode(current)),
            ),
            const Divider(height: 1),
            RadioListTile<ThemeMode>(
              value: ThemeMode.light,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  themeState.setThemeMode(value);
                }
              },
              title: const Text('Claro'),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.dark,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  themeState.setThemeMode(value);
                }
              },
              title: const Text('Escuro'),
            ),
            RadioListTile<ThemeMode>(
              value: ThemeMode.system,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  themeState.setThemeMode(value);
                }
              },
              title: const Text('Seguir sistema'),
            ),
          ],
        ),
      ),
    );
  }

  String _labelForMode(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Escuro';
      case ThemeMode.system:
      default:
        return 'Seguir sistema';
    }
  }
}
