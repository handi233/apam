import 'package:flutter/material.dart';

class DaftarPage extends StatelessWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Poli")),
      body: const Center(child: Text("Halaman Daftar")),
    );
  }
}
