// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/modules/auth/services/auth_service.dart';
import 'package:frontend/core/models/usuario.dart';
import 'package:frontend/modules/home/widgets/dashboard_header.dart';
import 'package:frontend/modules/home/widgets/navigation_menu.dart';
import 'package:frontend/modules/home/widgets/user_profile_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final AuthService _authService;
  Usuario? _currentUser;

  @override
  void initState() {
    super.initState();
    _authService = GetIt.instance<AuthService>();
    _currentUser = _authService.currentUser;

    _authService.addListener(_onAuthChanged);
  }

  @override
  void dispose() {
    _authService.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    if (mounted) {
      setState(() {
        _currentUser = _authService.currentUser;
      });
    }
  }

  void _onLogout() async {
    await _authService.logout();
    context.go('/login');
  }

  void _navigateToFuncionarios() {
    context.pushNamed('/funcionarios');
  }

  void _navigateToFolhaPagamento() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Folha de Pagamento - Funcionalidade em desenvolvimento'),
        backgroundColor: Color(0xFFEA580C),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(currentUser: _currentUser, onLogout: _onLogout),

              const SizedBox(height: 32),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 768) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: NavigationMenu(
                            onFuncionariosPressed: _navigateToFuncionarios,
                            onFolhaPressed: _navigateToFolhaPagamento,
                          ),
                        ),

                        const SizedBox(width: 24),

                        Expanded(
                          flex: 1,
                          child: UserProfileCard(currentUser: _currentUser, onLogout: _onLogout),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        NavigationMenu(
                          onFuncionariosPressed: _navigateToFuncionarios,
                          onFolhaPressed: _navigateToFolhaPagamento,
                        ),

                        const SizedBox(height: 24),

                        UserProfileCard(currentUser: _currentUser, onLogout: _onLogout),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
