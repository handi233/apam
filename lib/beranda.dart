import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

      // Ambil hanya 1 gambar pertama dari response pertama
      if (response1.statusCode == 200) {
        List<dynamic> data1 = jsonDecode(response1.body);
        if (data1.isNotEmpty) {
          tempImages.add(data1[0]['image'].toString());
        }
      }

      // Ambil hanya 1 gambar pertama dari response kedua
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, top: 40.0, right: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome, ${widget.nik}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (hasError)
              const Center(
                child: Text(
                  "Gagal memuat gambar dari database",
                  style: TextStyle(color: Colors.red),
                ),
              )
            else if (imageUrls.isEmpty)
              const Center(child: Text("Tidak ada gambar tersedia"))
            else
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: imageUrls.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.red,
                                      size: 50,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
