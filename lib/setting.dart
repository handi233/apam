import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100), // warna Bar
        foregroundColor: Colors.white, // teks putih
      ),
      body: const Center(
        child: Text("Setting", style: TextStyle(fontSize: 18)),
      ),
      backgroundColor: Colors.white,
    );
  }
}
