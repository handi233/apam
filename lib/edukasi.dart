import 'package:flutter/material.dart';

class EdukasiPage extends StatelessWidget {
  const EdukasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color themeColor = const Color.fromARGB(255, 24, 150, 100);

    final List<Map<String, String>> edukasiList = [
      {
        "judul": "Pola Makan Sehat",
        "deskripsi":
            "Konsumsi makanan bergizi seimbang, banyak buah dan sayur, serta batasi makanan tinggi gula dan lemak.",
      },
      {
        "judul": "Cukupi Kebutuhan Cairan",
        "deskripsi":
            "Minum air putih minimal 8 gelas per hari agar tubuh tetap terhidrasi.",
      },
      {
        "judul": "Istirahat yang Cukup",
        "deskripsi":
            "Tidur minimal 7 jam setiap malam membantu tubuh memulihkan energi.",
      },
      {
        "judul": "Olahraga Teratur",
        "deskripsi":
            "Lakukan aktivitas fisik ringan seperti jalan kaki, yoga, atau bersepeda selama 30 menit setiap hari.",
      },
      {
        "judul": "Kelola Stres",
        "deskripsi":
            "Luangkan waktu untuk relaksasi, meditasi, atau melakukan hobi yang disukai.",
      },
      {
        "judul": "Menjaga Kebersihan Diri",
        "deskripsi":
            "Cuci tangan sebelum makan dan setelah beraktivitas di luar rumah untuk mencegah infeksi.",
      },
      {
        "judul": "Periksa Kesehatan Rutin",
        "deskripsi":
            "Lakukan pemeriksaan kesehatan secara berkala agar penyakit dapat dideteksi lebih awal.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edukasi"),
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: edukasiList.length,
        itemBuilder: (context, index) {
          final item = edukasiList[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(Icons.health_and_safety, color: themeColor),
              title: Text(
                item["judul"]!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item["deskripsi"]!),
            ),
          );
        },
      ),
    );
  }
}
