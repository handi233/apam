import 'package:flutter/material.dart';

class SaranPage extends StatelessWidget {
  const SaranPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saran")),
      body: const Center(child: Text("Halaman Saran")),
    );
  }
}
