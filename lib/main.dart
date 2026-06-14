// lib/main.dart
import 'package:flutter/material.dart';
import 'pages/login_page.dart'; // Import halaman login dari Langkah 2

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pinjam Ruang SV Unpak',
      theme: ThemeData(
        primaryColor: const Color(0xFF247A75),
        useMaterial3: true,
      ),
      home: const LoginPage(), // Menjadikan LoginPage sebagai tampilan awal
    );
  }
}