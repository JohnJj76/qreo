import 'package:flutter/material.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  //
  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmar = _confirmPasswordController.text;
    //
    if (password != confirmar) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Password incorrecto')));
      return;
    }
    //
    try {
      await authService.signUpWithEmailPassword(email, password);
      //
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
      //
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("REGISTRAR"), centerTitle: true),
      body: ListView(
        children: [
          //
          TextField(controller: _emailController),
          //
          TextField(controller: _passwordController),
          //
          TextField(controller: _confirmPasswordController),
          //
          ElevatedButton(onPressed: signUp, child: const Text('Registrar')),
          //
          const SizedBox(height: 20),
          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
            child: Center(child: Text("si ya estas registrado logeate")),
          ),
        ],
      ),
    );
  }
}
