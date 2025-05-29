import 'package:flutter/material.dart';
import 'package:stuntfree/models/paket_gizi.dart';
import '../service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaketGiziPage extends StatefulWidget {
  const PaketGiziPage({Key? key}) : super(key: key);

  @override
  State<PaketGiziPage> createState() => _PaketGiziPageState();
}

class _PaketGiziPageState extends State<PaketGiziPage> {
  late Future<List<PaketGizi>> _futurePaket;

  final Color primaryColor = const Color(0xFF5D78FD);

  @override
  void initState() {
    super.initState();
    _futurePaket = ApiService().fetchPaketGizi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.05),
      appBar: AppBar(
        title: const Text("Paket Gizi"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<List<PaketGizi>>(
        future: _futurePaket,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Gagal memuat data: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text("Tidak ada data paket gizi."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final paket = items[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      paket.nama,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      paket.alamat,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 16, color: primaryColor),
                        const SizedBox(width: 4),
                        Text(
                          paket.telepon,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () async {
                        final Uri uri = Uri.parse(paket.urlmaps);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Tidak dapat membuka Maps")),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.map, color: primaryColor),
                          const SizedBox(width: 6),
                          Text(
                            'Lihat di Maps',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
