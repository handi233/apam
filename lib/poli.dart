import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DaftarPage extends StatefulWidget {
  const DaftarPage({Key? key}) : super(key: key);

  @override
  State<DaftarPage> createState() => _DaftarPageState();
}

class _DaftarPageState extends State<DaftarPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _keluhanController = TextEditingController();
  String? _selectedPoli;
  DateTime _selectedDate = DateTime.now();
  int? _usersId;

  final List<String> _poliOptions = [
    "Poli Umum",
    "Poli Gigi",
    "Poli Anak",
    "Poli Kandungan",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt('id_users');
    print('Loaded id_users from SharedPreferences: $id'); // Debug
    setState(() {
      _usersId = id ?? 1;
    });
  }

  Future<void> _submitForm() async {
    if (_usersId == null || _usersId == 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("User ID tidak valid")));
      return;
    }

    if (!_formKey.currentState!.validate() || _selectedPoli == null) return;

    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.6/apiapam/daftar_poli.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "users_id": _usersId ?? 1,
          "tgl_daftar": _selectedDate.toIso8601String().split("T")[0],
          "poli_tujuan": _selectedPoli ?? "",
          "keluhan": _keluhanController.text.trim(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final result = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Tidak ada message')),
      );
    } catch (e) {
      print('HTTP or JSON error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi error, cek console')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Poli"),
        backgroundColor: const Color.fromARGB(255, 24, 150, 100),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text(
                  "Tanggal: ${_selectedDate.toLocal()}".split(' ')[0],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Pilih Poli"),
                value: _selectedPoli,
                items: _poliOptions
                    .map(
                      (poli) =>
                          DropdownMenuItem(value: poli, child: Text(poli)),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPoli = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Pilih poli terlebih dahulu" : null,
              ),
              TextFormField(
                controller: _keluhanController,
                decoration: const InputDecoration(labelText: "Keluhan"),
                maxLines: 3,
                validator: (value) =>
                    value!.isEmpty ? "Keluhan tidak boleh kosong" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_usersId != null) ? _submitForm : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_usersId != null)
                      ? const Color.fromARGB(255, 24, 150, 100)
                      : Colors.grey, // disable warna abu-abu
                  foregroundColor: Colors.white,
                ),
                child: const Text("Daftar Poli"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
