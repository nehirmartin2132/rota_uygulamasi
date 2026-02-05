import 'package:flutter/material.dart';
import 'screens/login_page.dart';

void main() {
  runApp(const RotaApp());
}

class RotaApp extends StatelessWidget {
  const RotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF6FBF73); // yeşil ton
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rota Desktop',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFE8F2EA),
      ),
home: LoginPage(),
    );
  }
}
