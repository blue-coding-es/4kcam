import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/home_page.dart';   // ⬅️ tu nueva pantalla con streaming RTSP

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: ActionCamApp()));
}

class ActionCamApp extends StatelessWidget {
  const ActionCamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '4K Cam',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),        // ⬅️ punto de entrada a tu RTSP player
    );
  }
}
