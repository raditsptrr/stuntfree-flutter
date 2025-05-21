import 'package:flutter/material.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import '../service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataAnakPage extends StatefulWidget {
  const DataAnakPage({super.key});

  @override
  State<DataAnakPage> createState() => _DataAnakPageState();
}

class _DataAnakPageState extends State<DataAnakPage> {
  late Future<List<Map<String, dynamic>>> _anakFuture;

  @override
  void initState() {
    super.initState();
    _anakFuture = _fetchAnakDiterima();
  }

  Future<List<Map<String, dynamic>>> _fetchAnakDiterima() async {
    final prefs = await SharedPreferences.getInstance();
    final idOrtu = prefs.getInt('id_orangtua');
    if (idOrtu == null) return [];
    final data = await ApiService().fetchAnak(idOrtu);
    // Filter yang statusnya 'diterima' sudah di API, tapi tetap jaga aman
    return data.where((anak) => anak['status'].toString().toLowerCase() == 'diterima').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'DATA ANAK',
          style: TextStyle(
            color: Color(0xFF5D78FD),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: CircleAvatar(
            backgroundColor: Color(0xFFE3F0FF),
            child: Icon(Icons.person, color: Color(0xFF5D78FD)),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.menu, color: Color(0xFF5D78FD)),
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _anakFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Belum ada data anak yang diterima'));
              } else {
                final anakList = snapshot.data!;
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 8),
                    // Search bar (belum aktif fungsi pencarian)
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Cari nama anak...',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...anakList.map((anak) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildChildCard(context, anak),
                    )),
                    const SizedBox(height: 100),
                  ],
                );
              }
            },
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.pushNamed(context, '/tambah');
              },
              backgroundColor: const Color(0xFF5D78FD),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Tambah',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pushReplacementNamed(context, '/home');
          if (index == 2) Navigator.pushReplacementNamed(context, '/berita');
          if (index == 3) Navigator.pushReplacementNamed(context, '/profil');
        },
      ),
    );
  }

  Widget _buildChildCard(BuildContext context, Map<String, dynamic> anak) {
    int jenisKelaminValue = anak['jenis_kelamin'] ?? -1;
    bool isLakiLaki = jenisKelaminValue == 1;

    // Contoh asumsi field z_score di API sebagai tanda ada prediksi
    bool hasPrediction = anak['z_score'] != null;
    String zScore = anak['z_score']?.toString() ?? '-';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            anak['nama'] ?? '-',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text('NIK: ${anak['nik'] ?? '-'}', style: const TextStyle(color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                isLakiLaki ? Icons.male : Icons.female,
                size: 16,
                color: const Color(0xFF5D78FD),
              ),
              const SizedBox(width: 4),
              Text(isLakiLaki ? 'Laki-laki' : 'Perempuan'),
              const SizedBox(width: 16),
              const Icon(Icons.cake, size: 16, color: Color(0xFF5D78FD)),
              const SizedBox(width: 4),
              Text(_calculateAge(anak['tanggal_lahir'] ?? '2000-01-01')),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasPrediction) ...[
                      Row(
                        children: const [
                          Icon(Icons.warning_amber, size: 16, color: Colors.redAccent),
                          SizedBox(width: 4),
                          Text('Stunting', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.analytics, size: 16, color: Colors.deepPurple),
                          const SizedBox(width: 4),
                          Text('Z-Score: $zScore'),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  if (!hasPrediction) {
                    Navigator.pushNamed(context, '/prediksi');
                  } else {
                    Navigator.pushNamed(context, '/edit_prediksi');
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF5D78FD),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(hasPrediction ? Icons.edit : Icons.calculate, color: Colors.white),
                label: Text(hasPrediction ? 'Edit' : 'Prediksi'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _calculateAge(String tanggalLahir) {
    try {
      final birthDate = DateTime.parse(tanggalLahir);
      final now = DateTime.now();
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      return '$age tahun';
    } catch (e) {
      return '- tahun';
    }
  }
}
