import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:apam/edukasi.dart';
import 'package:apam/setting.dart';
import 'package:apam/saran.dart';
import 'package:apam/jadwal.dart';
import 'package:apam/poli.dart';
import 'package:apam/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BerandaPage extends StatefulWidget {
  final String nik;

  const BerandaPage({Key? key, required this.nik}) : super(key: key);

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  List<String> imageUrls = [];
  bool isLoading = true;
  bool hasError = false;
  int idUsersFromDB = 0;

  @override
  void initState() {
    super.initState();
    fetchImagesFromDatabase();
  }

  Future<void> fetchImagesFromDatabase() async {
    try {
      final response1 = await http.get(
        Uri.parse('http://192.168.1.6/apiapam/carosel.php'),
      );
      final response2 = await http.get(
        Uri.parse('http://192.168.1.6/apiapam/carosel2.php'),
      );

      List<String> tempImages = [];

      if (response1.statusCode == 200) {
        List<dynamic> data1 = jsonDecode(response1.body);
        if (data1.isNotEmpty) {
          tempImages.add(data1[0]['image'].toString());
        }
      }

      if (response2.statusCode == 200) {
        List<dynamic> data2 = jsonDecode(response2.body);
        if (data2.isNotEmpty) {
          tempImages.add(data2[0]['image'].toString());
        }
      }

      setState(() {
        imageUrls = tempImages;
        isLoading = false;
        hasError = imageUrls.isEmpty;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      print("Error fetching images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${widget.nik}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),

                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                else if (hasError)
                  const Center(
                    child: Text(
                      "⚠️ Gagal memuat gambar dari database",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else if (imageUrls.isEmpty)
                  const Center(
                    child: Text(
                      "Tidak ada gambar tersedia",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      aspectRatio: 16 / 9,
                      autoPlayInterval: const Duration(seconds: 3),
                    ),
                    items: imageUrls.map((imageUrl) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.redAccent,
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 30),

                const Text(
                  "Menu Pilihan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 10),

                // Row pertama
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMenuCard(
                      Icons.account_circle,
                      "Daftar Poli",
                      Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DaftarPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.calendar_today,
                      "Jadwal Dokter",
                      const Color.fromARGB(255, 235, 218, 33),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const JadwalPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.edit,
                      "Saran",
                      const Color.fromARGB(255, 5, 85, 204),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SaranPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Row kedua
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildMenuCard(
                      Icons.lightbulb,
                      "Edukasi",
                      const Color.fromARGB(255, 187, 91, 50),
                      margin: const EdgeInsets.only(top: 16, right: 16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EdukasiPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.settings,
                      "Setting",
                      const Color.fromARGB(255, 219, 22, 101),
                      margin: const EdgeInsets.only(top: 16, left: 30),
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int? idUsersFromDB = prefs.getInt('id_users');
                        if (idUsersFromDB == null || idUsersFromDB == 0) {
                          // Bisa pakai snackbar atau alert kalau id belum tersedia
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User belum login!")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SettingPage(idUsers: idUsersFromDB!),
                          ),
                        );
                      },
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _buildMenuCard(
                          Icons.logout,
                          "Logout",
                          Colors.redAccent,
                          margin: const EdgeInsets.only(top: 16, left: 45),
                          onTap: () async {
                            bool? confirmLogout = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Konfirmasi Logout"),
                                content: const Text(
                                  "Apakah Anda yakin ingin keluar dari akun ini?",
                                ),
                                actions: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color.fromARGB(
                                        255,
                                        15,
                                        15,
                                        15,
                                      ),
                                    ),
                                    child: const Text("Batal"),
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Keluar"),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                  ),
                                ],
                              ),
                            );

                            if (confirmLogout == true) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _buildMenuCard  onTap dan margin
  Widget _buildMenuCard(
    IconData icon,
    String title,
    Color color, {
    VoidCallback? onTap,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
