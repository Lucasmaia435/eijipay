import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('404 - Página não encontrada', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            FilledButton(onPressed: () => context.go('/'), child: Text('Voltar para a página inicial')),
          ],
        ),
      ),
    );
  }
}
