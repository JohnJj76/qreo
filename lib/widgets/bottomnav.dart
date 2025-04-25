import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/pages/eros/homeqr_eros.dart';
import 'package:qreo/pages/eros/verif_eros.dart';
import 'package:qreo/pages/orion/homeqr_orion.dart';
import 'package:qreo/pages/orion/verif_orion.dart';
import 'package:qreo/subir_fotos/upload_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  late List<Widget> pages;
  late HomeqrEros moteleros;
  late HomeqrOrion motelorion;
  late VerifEros verifEros;
  late VerifOrion verifOrion;

  int currentTabIndex = 0;

  @override
  void initState() {
    moteleros = HomeqrEros();
    motelorion = HomeqrOrion();
    verifEros = VerifEros();
    verifOrion = VerifOrion();
    pages = [moteleros, motelorion, verifEros, verifOrion];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 52,
        backgroundColor: Constants.colorFondo1,
        //color: Colors.black,
        color: Constants.colorBarra,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: [
          Image.asset('assets/imagenes/ico_qre.png', width: 60, height: 40),
          Image.asset('assets/imagenes/ico_qro.png', width: 60, height: 40),
          Image.asset('assets/imagenes/re1.png', width: 50, height: 30),
          Image.asset('assets/imagenes/re2.png', width: 50, height: 30),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
