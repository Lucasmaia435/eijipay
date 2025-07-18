// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:frontend/modules/404/not_found_view.dart';
import 'package:frontend/modules/auth/pages/login_view.dart';
import 'package:frontend/modules/auth/pages/register_view.dart';
import 'package:frontend/modules/home/views/home_view.dart';
import 'package:frontend/modules/funcionarios/pages/funcionarios_list_view.dart';
import 'package:frontend/modules/funcionarios/pages/funcionario_form_view.dart';
import 'package:get_it/get_it.dart';
import 'package:frontend/modules/auth/services/auth_service.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final authService = GetIt.instance<AuthService>();
    await authService.initialize();

    final isAuthenticated = authService.isAuthenticated;
    final isAuthRoute = state.matchedLocation.startsWith('/login') || state.matchedLocation.startsWith('/register');

    if (!isAuthenticated && !isAuthRoute) {
      return '/login';
    }

    if (isAuthenticated && isAuthRoute) {
      return '/';
    }

    return null;
  },
  routes: [
    // Rota da Home (protegida)
    GoRoute(path: '/', builder: (context, state) => const HomeView()),

    // Rotas de autenticação (públicas)
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterView()),

    // Rotas de funcionários (protegidas)
    GoRoute(path: '/funcionarios', builder: (context, state) => const FuncionariosListView()),
    GoRoute(path: '/funcionarios/novo', builder: (context, state) => const FuncionarioFormView()),
    GoRoute(
      path: '/funcionarios/:id/editar',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FuncionarioFormView(funcionarioId: id);
      },
    ),

    // Rotas futuras (placeholders)
    GoRoute(
      path: '/folha-pagamento',
      builder: (context, state) => const PlaceholderView(title: 'Folha de Pagamento'),
    ),
  ],
  errorBuilder: (context, state) => const NotFoundView(),
);

class PlaceholderView extends StatelessWidget {
  final String title;

  const PlaceholderView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: const Color(0xFF64748B).withOpacity(0.1), borderRadius: BorderRadius.circular(60)),
              child: const Icon(Icons.construction, size: 60, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),

            Text(
              '$title em Desenvolvimento',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 8),

            const Text('Esta funcionalidade será implementada em breve.', style: TextStyle(fontSize: 16, color: Color(0xFF64748B))),
            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar'),
            ),
          ],
        ),
      ),
    );
  }
}
