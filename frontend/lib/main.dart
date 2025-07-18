import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frontend/core/routes/router.dart';
import 'package:frontend/core/service_locator.dart';

void main() {
  usePathUrlStrategy();

  setupServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EijiPay - Sistema de Gestão Contábil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB), brightness: Brightness.light),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
