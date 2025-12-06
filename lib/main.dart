import 'package:flutter/material.dart';
import 'package:responsi_2_paket_3_h1d023002/ui/login_page.dart'; // Pastikan import ini ada

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsi 2 Mobile Paket 3 H1D023002', // Sesuai soal
      theme: ThemeData(
        // Set warna utama menjadi Coklat
        primarySwatch: Colors.brown,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginPage(), // Arahkan ke Login Page
    );
  }
}