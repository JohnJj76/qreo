import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/library.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTime(CustomPage mPage) async {
    Timer(const Duration(seconds: 3), () {
      navigate(context, mPage);
    });
  }

  @override
  void initState() {
    super.initState();

    globalContext = context;
    //startTime(CustomPage.home);
    //startTime(CustomPage.formNotas); //*****mio */
    //startTime(CustomPage.homeNotas); //*****mio */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.colorBackgroundSplash,
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        child: const Text(
          "Splash Page",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
