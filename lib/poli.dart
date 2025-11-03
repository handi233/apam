import 'package:flutter/material.dart';

class DaftarPage extends StatelessWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Poli"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100), // warna Bar
        foregroundColor: Colors.white, // teks putih
      ),
      body: const Center(
        child: Text(" Daftar", style: TextStyle(fontSize: 18)),
      ),
      backgroundColor: Colors.white,
    );
  }
}
