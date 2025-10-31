import 'package:apam/splash.dart';
import 'package:apam/home.dart';
import 'package:apam/beranda.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Splash(),
        '/home': (context) => Home(),
        '/beranda': (context) => BerandaPage(nik: ''),
      },
    );
  }
}
