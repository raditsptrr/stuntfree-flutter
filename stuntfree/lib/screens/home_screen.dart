import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import 'package:stuntfree/screens/child_detail_screen.dart';
import 'package:stuntfree/screens/news_detail_screen.dart';
import '../service/api_service.dart';
import '../models/edukasi.dart';
import '../util/app_constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _anakFuture;
  late Future<List<Edukasi>> _beritaFuture;
  List<Map<String, dynamic>> _allAnak = [];
  List<Map<String, dynamic>> _filteredAnak = [];
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  Future<String?> getNamaOrtu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama_ortu');
  }

  @override
  void initState() {
    super.initState();
    _anakFuture = _fetchAnakDiterima();
    _beritaFuture = ApiService().fetchEdukasi();
    _loadAnakDiterima();
    _searchController.addListener(_onSearchChanged);
  }

  // load
  Future<void> _loadAnakDiterima() async {
    final prefs = await SharedPreferences.getInstance();
    final idOrtu = prefs.getInt('id_orangtua');
    if (idOrtu == null) {
      setState(() {
        _allAnak = [];
        _filteredAnak = [];
        _loading = false;
      });
      return;
    }
    final data = await ApiService().fetchAnak(idOrtu);
    final anakDiterima = data.where((anak) => anak['status'].toString().toLowerCase() == 'diterima').toList();
    setState(() {
      _allAnak = anakDiterima;
      _filteredAnak = anakDiterima;
      _loading = false;
    });
  }

  // search 
  void _onSearchChanged() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredAnak = _allAnak.where((anak) {
        final nama = (anak['nama'] ?? '').toString().toLowerCase();
        return nama.contains(keyword);
      }).toList();
    });
  }

  Future<List<Map<String, dynamic>>> _fetchAnakDiterima() async {
    final prefs = await SharedPreferences.getInstance();
    final idOrtu = prefs.getInt('id_orangtua');
    if (idOrtu == null) return [];
    final data = await ApiService().fetchAnak(idOrtu);
    return data
        .where((anak) => anak['status'].toString().toLowerCase() == 'diterima')
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF2F7FD), Color(0xFFEAF0FB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 80),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Tetap Sama)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [
                                        Color(0xFF5D78FD),
                                        Color(0xFF448AFF)
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    "SELAMAT DATANG",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 1),
                                FutureBuilder<String?>(
                                  future: getNamaOrtu(),
                                  builder: (context, snapshot) {
                                    final namaOrtu =
                                        snapshot.data ?? 'Nama Tidak Tersedia';
                                    return ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return const LinearGradient(
                                          colors: [
                                            Color(0xFF5D78FD),
                                            Color(0xFF448AFF)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ).createShader(bounds);
                                      },
                                      child: Text(
                                        namaOrtu.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Image.asset(
                            'assets/images/jerapah.png',
                            height: 120,
                          ),
                        ],
                      ),
                    ),

                    // Search bar (Tetap Sama)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 

                    // Info Card List (Tetap Sama)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(
                        height: 155,
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : _filteredAnak.isEmpty
                                ? const Center(child: Text('Tidak ada anak yang sesuai pencarian'))
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _filteredAnak.length,
                                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                                    itemBuilder: (context, index) {
                                      final anak = _filteredAnak[index];
                                      final hasilModel = anak['hasil'] ?? 'Tidak Ada Data';

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ChildDetailScreen(anakData: anak),
                                            ),
                                          );
                                        },
                                        child: InfoCard(
                                          name: anak['nama'] ?? '-',
                                          gender: anak['jenis_kelamin'] == 1
                                              ? 'Laki-laki'
                                              : anak['jenis_kelamin'] == 0
                                                  ? 'Perempuan'
                                                  : '-',
                                          weight: anak['berat']?.round() ?? 0,
                                          age: anak['usia_bulan']?.round() ?? 0,
                                          height: anak['tinggi']?.round() ?? 0,
                                          score: double.tryParse(anak['z_score']?.toString() ?? '0') ?? 0.0,
                                          color: const Color(0xFF5D78FD),
                                          modelResult: hasilModel,
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Teman Sehat Anak (Tetap Sama)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Teman Sehat Anak",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/faskes');
                              },
                            
                            child: CategoryCard(
                              title: 'Fasilitas Kesehatan',
                              icon: Icons.child_care,
                              color: Colors.red,
                            ),
                           ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/paketgizi');
                              },
                              child: const CategoryCard(
                                title: 'Paket Gizi',
                                icon: Icons.restaurant,
                                color: Color(0xFF5D78FD),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Terbaru (Tetap Sama)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Terbaru",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: FutureBuilder<List<Edukasi>>(
                        future: _beritaFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Gagal memuat berita: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Tidak ada berita terbaru.'));
                          } else {
                            final allBerita = snapshot.data!;
                            final latestBerita = allBerita.take(3).toList();
                            return Column(
                              children: latestBerita.map((berita) {
                                // Gunakan NetworkNewsCard yang sudah direvisi
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: NetworkNewsCard( // <-- Pastikan ini memanggil NetworkNewsCard yang baru
                                    title: berita.judul,
                                    date: berita.kategori,
                                    description: berita.content,
                                    imageUrl: berita.fullImageUrl != null
                                        ? '${AppConstant.imageBaseUrl}${berita.fullImageUrl}'
                                        : null,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => NewsDetailScreen(
                                            title: berita.judul,
                                            date: berita.kategori,
                                            imagePath: berita.fullImageUrl != null
                                                ? '${AppConstant.imageBaseUrl}${berita.fullImageUrl!}'
                                                : null,
                                            content: berita.content,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          // BottomNavBar (Tetap Sama)
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                if (index == 0) return;
                if (index == 1) Navigator.pushNamed(context, '/dataanak');
                if (index == 2) Navigator.pushNamed(context, '/berita');
                if (index == 3) Navigator.pushNamed(context, '/profil');
              },
            ),
          ),
        ],
      ),
    );
  }
}

// InfoCard (Tetap Sama)
class InfoCard extends StatelessWidget {
  final String name;
  final String gender;
  final int weight;
  final int age;
  final int height;
  final double score;
  final Color color;
  final String? modelResult;

  const InfoCard({
    super.key,
    required this.name,
    required this.gender,
    required this.weight,
    required this.age,
    required this.height,
    required this.score,
    required this.color,
    this.modelResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 155,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name.toUpperCase(),
              style: const TextStyle(
                  color: Color.fromARGB(255, 255, 224, 98),
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.male, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text(gender,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.monitor_weight, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text("$weight Kg",
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text("$age Bulan • $height cm",
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Spacer(),
          if (modelResult != null) ...[
            Text(
              'Prediksi: $modelResult',
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 224, 98),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
          ],
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              score.toStringAsFixed(2),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CategoryCard (Tetap Sama)
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 38, color: Colors.white),
            const SizedBox(height: 8),
            Text(title,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}


// NetworkNewsCard (REVISI - Menggunakan Container + Padding)
class NetworkNewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String? imageUrl;
  final VoidCallback onTap;

  const NetworkNewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Material( // Untuk efek InkWell dan clipping
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding( // <-- Tambahkan Padding di sini
            padding: const EdgeInsets.all(12.0), // Padding 12 di semua sisi
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), // Sudut tumpul semua sisi
                  child: Container(
                    width: 80, // Ukuran gambar 80x80
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image,
                                  size: 40, color: Colors.white); // Perkecil ikon
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2));
                            },
                          )
                        : const Icon(Icons.image, size: 40, color: Colors.white), // Perkecil ikon
                  ),
                ),
                const SizedBox(width: 12), // Jarak antara gambar dan teks
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(date,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 6),
                      Text(description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}