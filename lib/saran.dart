import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saran"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100), // warna Bar
        foregroundColor: Colors.white, // teks putih
      ),
      body: const Center(child: Text("Saran", style: TextStyle(fontSize: 18))),
      backgroundColor: Colors.white,
    );
  }
}
