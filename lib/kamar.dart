import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //atur api .env

class KamarPage extends StatefulWidget {
  const KamarPage({Key? key}) : super(key: key);

  @override
  _KamarPageState createState() => _KamarPageState();
}

class _KamarPageState extends State<KamarPage> {
  List Kamar = [];
  bool isLoading = true;
  late final String baseUrl;

  Future<void> getKamar() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_kamar.php"));

      if (response.statusCode == 200) {
        setState(() {
          Kamar = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception("Gagal mengambil data.");
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat data dari server.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? '';
    print("BASE_URL Kamar: $baseUrl"); // Debug
    getKamar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Kamar Tersedia"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Kamar.isEmpty
          ? const Center(child: Text("Belum ada kamar kosong."))
          : ListView.builder(
              itemCount: Kamar.length,
              itemBuilder: (context, index) {
                final d = Kamar[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.bed, color: Colors.green),
                    title: Text("Kamar      : ${d['nama_kamar']}"),
                    subtitle: Text("Sisa kamar : ${d['sisa_kamar']}"),
                  ),
                );
              },
            ),
    );
  }
}
