import 'package:flutter/material.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/validation.dart';
import 'package:qreo/pages/login/register_page.dart';
import 'package:qreo/widgets/custom_button.dart';
import 'package:qreo/widgets/custom_input.dart';

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
  final TextEditingController _mControlController = TextEditingController();
  Validation mValidation = Validation();

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
      backgroundColor: Constants.colorMensaje,
      builder: (BuildContext context) {
        return Container(
          color: Constants.colorMensaje,
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 30,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Autorizar Registro',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black,
                  ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: CustomInput(
                  //title: 'Valor',
                  obscurePassword: true,
                  controller: _mControlController,
                  textInputType: TextInputType.number,
                  validator: (value) {
                    return mValidation.validate(
                      type: TypeValidation.varchar,
                      name: 'clave',
                      value: _mControlController.text,
                      isRequired: false,
                      max: 6,
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Flexible(
                  flex: 1,
                  child: CustomButton(
                    width: double.infinity,
                    color: Constants.colorAccent,
                    callback: () {
                      if (_mControlController.text == "157676") {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                        _mControlController.text = "";
                      } else {
                        Navigator.pop(context);
                        _mControlController.text = "";
                      }
                    },
                    child: Text("Accesar", style: Constants.textStyleBlackBold),
                  ),
                ),
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
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset(
                      'assets/imagenes/logoapp.png',
                      width: 200,
                      height: 200,
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
                        decoration: InputDecoration(
                          label: Text("Email"),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 18),
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
                        decoration: InputDecoration(
                          label: Text("Password"),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
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
