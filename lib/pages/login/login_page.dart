import 'package:flutter/material.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/pages/login/register_page.dart';
import 'package:qreo/widgets/custom_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
  autorizarRegistro() {
    return showModalBottomSheet(
      context: context,
      enableDrag: true,
      backgroundColor: Constants.colorBackgroundPanel,
      builder: (BuildContext context) {
        return Container(
          color: Constants.colorBackgroundPanel,
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Autorizar Registro',
                  style: Constants.textStyleAccentTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Text(
                  'Digite el codigo para registrar usuario.',
                  style: Constants.textStyleLight,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      width: double.infinity,
                      color: Constants.colorBlack,
                      callback: () => Navigator.pop(context),
                      child: Text(
                        "Atrás",
                        style: Constants.textStyleAccentSemiBold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      width: double.infinity,
                      color: Constants.colorAccent,
                      callback: () {
                        /* deleteNota();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNav()),
                          (Route<dynamic> route) => false,
                        );*/
                      },
                      child: Text(
                        "Eliminar",
                        style: Constants.textStyleBlackBold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorLogin,
      body: Form(
        key: formKey,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60),
              SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset(
                      'assets/imagenes/logoapp.png',
                      width: 300,
                      height: 300,
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width * .9,
                      child: TextFormField(
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "El correo no puede estar vacio."
                                    : null,
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
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
                          label: Text("Password"),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * .55,
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿No tienes una cuenta aun?",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(width: 2),
                        TextButton(
                          onPressed: autorizarRegistro,

                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );*/
                          child: const Text(
                            "Registrate",
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
