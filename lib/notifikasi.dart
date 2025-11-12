import 'package:flutter/material.dart';

class NotifikasiPage extends StatelessWidget {
  final List<dynamic> notifList;
  const NotifikasiPage({Key? key, required this.notifList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notifikasi")),
      body: notifList.isEmpty
          ? const Center(child: Text("Belum ada notifikasi"))
          : ListView.builder(
              itemCount: notifList.length,
              itemBuilder: (context, index) {
                final item = notifList[index];
                return ListTile(
                  leading: const Icon(Icons.notifications),
                  title: Text(item['pesan']),
                  subtitle: Text(item['tanggal'] ?? ''),
                );
              },
            ),
    );
  }
}
