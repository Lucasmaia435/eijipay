import 'package:frontend/modules/404/not_found_view.dart';
import 'package:frontend/modules/auth/pages/login_view.dart';
import 'package:frontend/modules/home/home_view.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => HomeView()),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
  ],

  errorBuilder: (context, state) => NotFoundView(),
);
