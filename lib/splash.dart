import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String logoUrl = '';
  late final String baseUrl;

  @override
  void initState() {
    super.initState();
    baseUrl = dotenv.env['BASE_URL'] ?? ''; // ambil dari .env
    if (baseUrl.isEmpty) {
      print('BASE_URL tidak diatur di .env');
    } else {
      fetchLogo();
    }

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  String combineUrl(String base, String path) {
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    if (path.startsWith('/')) path = path.substring(1);
    return '$base/$path';
  }

  Future<void> fetchLogo() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/get_logo.php'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Server response: $data');

        if (data['logo'] != null && data['logo'].toString().isNotEmpty) {
          final fullLogoUrl = combineUrl(baseUrl, data['logo'].toString());
          if (!mounted) return;
          setState(() {
            // logoUrl = '$baseUrl/${data['logo']}';
            logoUrl = fullLogoUrl;
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
