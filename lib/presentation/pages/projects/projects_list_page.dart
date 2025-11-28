import 'package:flutter/material.dart';

class ProjectsListPage extends StatelessWidget {
  const ProjectsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projetos'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text('Lista de projetos (placeholder)'),
      ),
    );
  }
}
