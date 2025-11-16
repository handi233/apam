import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; //atur api .env

class SettingPage extends StatefulWidget {
  final int idUsers; //user yang login
  const SettingPage({Key? key, required this.idUsers}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _loading = false;
  late final String baseUrl;

  // Variabel untuk toggle show/hide password
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  //route api .env debug
  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? '';
    print("BASE_URL SaranPage: $baseUrl"); // Debug
  }

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      int userId = widget.idUsers;
      String oldPass = _oldPassController.text;
      String newPass = _newPassController.text;

      final response = await http.post(
        Uri.parse("$baseUrl/ubah_password.php"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_users': widget.idUsers,
          'old_password': oldPass,
          'new_password': newPass,
        }),
      );

      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(data['message'])));

      if (data['status']) {
        _oldPassController.clear();
        _newPassController.clear();
        _confirmPassController.clear();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Terjadi kesalahan: $e")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Password Lama
              TextFormField(
                controller: _oldPassController,
                obscureText: _obscureOld,
                decoration: InputDecoration(
                  labelText: "Password Lama",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureOld ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black, // ikon hitam
                    ),
                    onPressed: () {
                      setState(() => _obscureOld = !_obscureOld);
                    },
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Masukkan password lama" : null,
              ),
              const SizedBox(height: 16),

              // Password Baru
              TextFormField(
                controller: _newPassController,
                obscureText: _obscureNew,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNew ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscureNew = !_obscureNew);
                    },
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Masukkan password baru" : null,
              ),
              const SizedBox(height: 16),

              // Konfirmasi Password Baru
              TextFormField(
                controller: _confirmPassController,
                obscureText: _obscureConfirm,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password Baru",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) return "Konfirmasi password diperlukan";
                  if (value != _newPassController.text)
                    return "Password tidak sama";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          24,
                          150,
                          100,
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        "Ubah Password",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
