import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  final List<Map<String, String>> faqs = const [
    {
      'question': 'Bagaimana cara pertama daftar aplikasi apam?',
      'answer':
          'Anda langsung ke bagian staff pendaftaran / admin agar dibantu lebih lanjut. ',
    },
    {
      'question': 'Bagaimana cara login?',
      'answer': 'Masukkan NIK dan password Anda lalu tekan tombol "Masuk".',
    },
    {
      'question': 'Saya lupa password, apa yang harus dilakukan?',
      'answer':
          'Silakan hubungi admin atau menuju staff pendaftaran agar dibantu lebih lanjut.',
    },
    {
      'question': 'Bagaimana cara menghubungi support?',
      'answer': 'Anda bisa menghubungi nomor telepon - atau email -',
    },
    {
      'question': 'Apakah data saya aman?',
      'answer':
          'Semua data disimpan secara aman menggunakan protokol enkripsi standar.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan"),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ExpansionTile(
              title: Text(
                faq['question']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    faq['answer']!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
