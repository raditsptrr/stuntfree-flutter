import 'package:flutter/material.dart';
import 'package:stuntfree/models/faskes.dart';
import 'package:stuntfree/models/kecamatan.dart';
import 'package:stuntfree/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class FaskesPage extends StatefulWidget {
  const FaskesPage({Key? key}) : super(key: key);

  @override
  State<FaskesPage> createState() => _FaskesPageState();
}

class _FaskesPageState extends State<FaskesPage> {
  late Future<List<Faskes>> _futureFaskes;
  late Future<List<Kecamatan>> _futureKecamatan;
  int? _selectedKecamatanId;

  final Color primaryColor = const Color(0xFF5D78FD);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _futureFaskes = ApiService().fetchFaskes(idKecamatan: _selectedKecamatanId);
    _futureKecamatan = ApiService().fetchKecamatan();
  }

  void _onKecamatanChanged(int? id) {
    setState(() {
      _selectedKecamatanId = id;
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor.withOpacity(0.05),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        title: Text(
          "Fasilitas Kesehatan",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder<List<Kecamatan>>(
            future: _futureKecamatan,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Gagal memuat kecamatan: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              final kecamatanList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: DropdownButtonFormField<int>(
                  value: _selectedKecamatanId,
                  isExpanded: true,
                  hint: const Text("Pilih Kecamatan"),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Semua Kecamatan"),
                    ),
                    ...kecamatanList.map(
                      (kec) => DropdownMenuItem(
                        value: kec.id,
                        child: Text(kec.nama),
                      ),
                    ),
                  ],
                  onChanged: _onKecamatanChanged,
                ),
              );
            },
          ),
          Expanded(
            child: FutureBuilder<List<Faskes>>(
              future: _futureFaskes,
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
                  return const Center(child: Text("Tidak ada data faskes."));
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final faskes = items[index];
                    return Card(
  color: Colors.white, // Warna putih polos
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  ),
  elevation: 3,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          faskes.nama,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor, // Tetap pakai warna utama untuk teks judul
          ),
        ),
        const SizedBox(height: 6),
        Text(
          faskes.alamat,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.phone, size: 16, color: primaryColor),
            const SizedBox(width: 6),
            Text(
              faskes.telepon,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final Uri uri = Uri.parse(faskes.urlMaps);
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Tidak dapat membuka Maps")),
              );
            }
          },
          icon: Icon(Icons.map, color: primaryColor),
          label: Text(
            'Lihat di Maps',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: primaryColor),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    ),
  ),
);

                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
