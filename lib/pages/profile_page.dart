import 'package:flutter/material.dart';
import 'package:qreo/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final authService = AuthService();
  void loggout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: const Text("PERFIL"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: loggout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Center(child: Text(currentEmail.toString())),
    );
  }
}
