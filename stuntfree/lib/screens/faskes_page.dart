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
        title: const Text("Fasilitas Kesehatan"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          FutureBuilder<List<Kecamatan>>(
            future: _futureKecamatan,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Text('Gagal memuat kecamatan: ${snapshot.error}');
              }

              final kecamatanList = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<int>(
                  value: _selectedKecamatanId,
                  isExpanded: true,
                  hint: const Text("Pilih Kecamatan"),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text("Semua Kecamatan"),
                    ),
                    ...kecamatanList.map((kec) => DropdownMenuItem(
                          value: kec.id,
                          child: Text(kec.nama),
                        ))
                  ],
                  onChanged: _onKecamatanChanged,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
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

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final faskes = items[index];
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
                            faskes.nama,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(faskes.alamat),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone, size: 16, color: primaryColor),
                              const SizedBox(width: 4),
                              Text(faskes.telepon),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () async {
                              final Uri uri = Uri.parse(faskes.urlMaps);
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
          ),
        ],
      ),
    );
  }
}
