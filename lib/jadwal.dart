import 'package:flutter/material.dart';

class JadwalPage extends StatelessWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Jadwal Dokter")),
      body: const Center(child: Text("Halaman Jadwal Dokter")),
    );
  }
}
