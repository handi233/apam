import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //atur api .env

class SaranPage extends StatefulWidget {
  const SaranPage({Key? key}) : super(key: key);

  @override
  _SaranPageState createState() => _SaranPageState();
}

class _SaranPageState extends State<SaranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController isiController = TextEditingController();
  bool isLoading = false;
  late final String baseUrl;

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? '';
    print("BASE_URL SaranPage: $baseUrl"); // Debug
  }

  Future<void> kirimSaran() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/tambah_saran.php"),
        body: {"isi": isiController.text},
      );

      var data = json.decode(response.body);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));

      if (data['success']) {
        isiController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal terhubung ke server.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saran"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: isiController,
                decoration: const InputDecoration(
                  labelText: "Masukan Saran",
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? "Saran tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isLoading ? null : kirimSaran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 24, 150, 100),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send, color: Colors.white),
                label: Text(
                  isLoading ? "Mengirim..." : "Kirim Saran",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
