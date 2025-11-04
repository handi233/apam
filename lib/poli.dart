import 'package:flutter/material.dart';

class DaftarPage extends StatelessWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Poli"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100),
        foregroundColor: Colors.white,
      ),
      body: const Center(child: Text("Poli", style: TextStyle(fontSize: 18))),
      backgroundColor: Colors.white,
    );
  }
}
