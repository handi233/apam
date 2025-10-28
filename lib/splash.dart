import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String logoUrl = '';

  @override
  void initState() {
    super.initState();
    fetchLogo();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  Future<void> fetchLogo() async {
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2/apiapam/get_logo.php'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['logo'] != null) {
          setState(() {
            logoUrl = data['logo'];
          });
          print('Logo URL: $logoUrl');
        } else if (data['error'] != null) {
          print('Server error: ${data['error']}');
        } else {
          print('Response tidak mengandung logo');
        }
      } else {
        print('Gagal load logo: ${response.statusCode}');
      }
    } on TimeoutException {
      print('Request logo timeout');
    } catch (e) {
      print('Error fetch logo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 211, 123),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logoUrl.isEmpty
                ? const CircularProgressIndicator(color: Colors.white)
                : Image.network(
                    logoUrl,
                    width: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 100,
                      color: Colors.white,
                    ),
                  ),
            const SizedBox(height: 250),
            const Text(
              'Versi 1.0',
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
