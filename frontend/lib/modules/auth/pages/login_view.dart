import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 440),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                spacing: 16,
                children: [
                  Text("Bem vindo ao EijiPay!", style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(labelText: "Email", border: OutlineInputBorder()),
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                    obscureText: true,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Esqueceu sua senha? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Recuperar",
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                          mouseCursor: SystemMouseCursors.click,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recuperar senha clicado!')));
                            },
                        ),
                      ],
                    ),
                  ),

                  Spacer(),
                  SizedBox(
                    width: double.maxFinite,
                    child: FilledButton(
                      onPressed: () => context.go('/'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        backgroundColor: const Color.fromARGB(255, 59, 194, 120),
                      ),
                      child: Text("Fazer Login"),
                    ),
                  ),
                  TextButton(onPressed: () {}, child: Text("Criar conta")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
