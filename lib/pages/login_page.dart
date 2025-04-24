import 'package:flutter/material.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  //
  void login() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LOGIN"), centerTitle: true),
      body: ListView(
        children: [
          //
          const Text("Bienvenido a la aplicación."),
          const SizedBox(height: 10),
          //
          SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: TextFormField(
              validator:
                  (value) =>
                      value!.isEmpty ? "El correo no puede estar vacio." : null,
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Correo"),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: TextFormField(
              validator:
                  (value) =>
                      value!.length < 8
                          ? "La contraseña debe tener al menos ocho caracteres."
                          : null,
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("Clave"),
              ),
            ),
          ),
          SizedBox(height: 10),
          //
          //TextField(controller: _emailController),
          //
          //TextField(controller: _passwordController),
          //
          ElevatedButton(onPressed: login, child: const Text('Login')),
          //
          const SizedBox(height: 20),
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPage()),
                ),
            child: Center(child: Text("si no estas registrado registrate")),
          ),
        ],
      ),
    );
  }
}
