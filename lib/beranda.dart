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

class _BerandaPageState extends State<BerandaPage>
    with SingleTickerProviderStateMixin {
  List<String> imageUrls = [];
  bool isLoading = true;
  bool hasError = false;
  int idUsersFromDB = 0;

  // Notifikasi
  int notifCount = 0;
  List<dynamic> notifList = [];

  // Animation untuk badge
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    loadUserIdAndFetchData();
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        if (notifCount > 0) _controller.forward();
      }
    });
  }

  Future<void> loadUserIdAndFetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? idUser = prefs.getInt('id_users');
    if (idUser != null) {
      setState(() {
        idUsersFromDB = idUser;
      });
      await fetchNotifikasi();
    }
    await fetchImagesFromDatabase();
  }

  Future<void> fetchNotifikasi() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.6/apiapam/notifikasi.php'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        // Tidak perlu filter enum lagi karena PHP sudah filter status=1
        setState(() {
          notifList = data;
          notifCount = data.length;
        });

        if (notifCount > 0) _controller.forward();
      } else {
        print('Gagal fetch notifikasi, status: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching notifications: $e");
    }
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
        if (data1.isNotEmpty) tempImages.add(data1[0]['image'].toString());
      }

      if (response2.statusCode == 200) {
        List<dynamic> data2 = jsonDecode(response2.body);
        if (data2.isNotEmpty) tempImages.add(data2[0]['image'].toString());
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Widget lonceng notifikasi
  Widget _notificationBell() {
    return InkWell(
      onTap: () {
        if (notifCount == 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Belum ada notifikasi baru")),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotifikasiPage(notifList: notifList),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Icon(Icons.notifications, color: Colors.white, size: 28),
          if (notifCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: ScaleTransition(
                scale: _animation,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notifCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
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
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Welcome, ${widget.nik}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    _notificationBell(),
                  ],
                ),
                const SizedBox(height: 25),

                // Carousel
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

                // Menu dengan Wrap
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
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
                      const Color(0xFFEBDA21),
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
                      const Color(0xFF0555CC),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SaranPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.lightbulb,
                      "Edukasi",
                      const Color(0xFFBB5B32),
                      margin: const EdgeInsets.only(top: 16, left: 5),
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
                      const Color(0xFFDB1665),
                      margin: const EdgeInsets.only(
                        top: 16,
                        left: 15,
                      ), // margin kiri
                      onTap: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        int? idUsersFromDB = prefs.getInt('id_users');
                        if (idUsersFromDB == null || idUsersFromDB == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("User belum login!")),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SettingPage(idUsers: idUsersFromDB),
                          ),
                        );
                      },
                    ),
                    _buildMenuCard(
                      Icons.logout,
                      "Logout",
                      Colors.redAccent,
                      margin: const EdgeInsets.only(
                        top: 16,
                        left: 15,
                      ), // margin kiri
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
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text("Keluar"),
                                onPressed: () => Navigator.pop(context, true),
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
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    IconData icon,
    String title,
    Color color, {
    VoidCallback? onTap,
    EdgeInsets? margin,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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

// Halaman Notifikasi
class NotifikasiPage extends StatelessWidget {
  final List<dynamic> notifList;
  const NotifikasiPage({Key? key, required this.notifList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: ListView.builder(
        itemCount: notifList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(notifList[index]['title'] ?? 'Tidak ada judul'),
            subtitle: Text(notifList[index]['message'] ?? 'Tidak ada pesan'),
          );
        },
      ),
    );
  }
}
