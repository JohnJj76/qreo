import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qreo/auth/auth_gate.dart';
import 'package:qreo/custom/configurations.dart';
import 'package:qreo/custom/library.dart';
import 'package:qreo/providers/erosqr_provider.dart';

import 'package:qreo/providers/orionqr_provider.dart';
import 'package:qreo/providers/qr_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: Configurations.mSupabaseUrl,
    anonKey: Configurations.mSupabaseKey,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ErosQrProvider()),
        ChangeNotifierProvider(create: (_) => OrionQrProvider()),
        ChangeNotifierProvider(create: (_) => QrProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      navigatorObservers: [mRouteObserver],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const SplashPage(),
      home: AuthGate(),
    );
  }
}
