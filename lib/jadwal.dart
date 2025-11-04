import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JadwalPage extends StatefulWidget {
  const JadwalPage({Key? key}) : super(key: key);

  @override
  _JadwalPageState createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  List jadwal = [];
  bool isLoading = true;

  Future<void> ambilJadwal() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.1.6/apiapam/lihat_jadwal.php"),
      );

      if (response.statusCode == 200) {
        setState(() {
          jadwal = json.decode(response.body);
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
    ambilJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Dokter"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jadwal.isEmpty
          ? const Center(child: Text("Belum ada jadwal dokter."))
          : ListView.builder(
              itemCount: jadwal.length,
              itemBuilder: (context, index) {
                final d = jadwal[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.medical_services,
                      color: Colors.green,
                    ),
                    title: Text(d['nama_dokter']),
                    subtitle: Text(
                      "${d['spesialis']} - ${d['hari']}\n${d['jam_mulai']} - ${d['jam_selesai']}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}
