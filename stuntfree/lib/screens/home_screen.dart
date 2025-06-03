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
  // _anakFuture tidak lagi digunakan secara langsung untuk list,
  // namun _loadAnakDiterima yang mengisi _allAnak dan _filteredAnak
  // Jika _anakFuture benar-benar tidak ada kegunaan lain, bisa dipertimbangkan untuk dihapus
  // Untuk saat ini, saya biarkan sesuai kode yang Anda berikan.
  late Future<List<Map<String, dynamic>>> _anakFuture;
  late Future<List<Edukasi>> _beritaFuture;
  List<Map<String, dynamic>> _allAnak = [];
  List<Map<String, dynamic>> _filteredAnak = [];
  bool _loading = true; // Digunakan untuk state loading awal daftar anak
  String? _anakListError; // Untuk menangani error saat fetch data anak
  final TextEditingController _searchController = TextEditingController();

  Future<String?> getNamaOrtu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama_ortu');
  }

  @override
  void initState() {
    super.initState();
    _anakFuture = _fetchAnakDiterima(); // Tetap ada sesuai kode Anda
    _beritaFuture = ApiService().fetchEdukasi();
    _loadAnakDiterima();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadAnakDiterima() async {
    setState(() {
      _loading = true;
      _anakListError = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final idOrtu = prefs.getInt('id_orangtua');
      if (idOrtu == null) {
        setState(() {
          _allAnak = [];
          _filteredAnak = [];
          _loading = false;
          // _anakListError = 'ID Orang tua tidak ditemukan.'; // Opsi jika ingin pesan error spesifik
        });
        return;
      }
      final data = await ApiService().fetchAnak(idOrtu);
      final anakDiterima = data
          .where((anak) => anak['status'].toString().toLowerCase() == 'diterima')
          .toList();
      setState(() {
        _allAnak = anakDiterima;
        _filteredAnak = anakDiterima;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _anakListError = 'Gagal memuat data anak. Periksa koneksi Anda.';
        _allAnak = [];
        _filteredAnak = [];
      });
    }
  }

  void _onSearchChanged() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      if (keyword.isEmpty) {
        _filteredAnak = _allAnak;
      } else {
        _filteredAnak = _allAnak.where((anak) {
          final nama = (anak['nama'] ?? '').toString().toLowerCase();
          return nama.contains(keyword);
        }).toList();
      }
    });
  }

  // _fetchAnakDiterima() tetap ada, karena _anakFuture di initState menggunakannya.
  // Jika _anakFuture dihapus, method ini juga bisa dihapus.
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
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildAnakListWidget() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_anakListError != null) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(_anakListError!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                  textAlign: TextAlign.center)));
    }
    if (_allAnak.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Belum ada data anak yang diterima.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center)));
    }
    if (_filteredAnak.isEmpty) {
      return const Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Tidak ada anak yang sesuai pencarian.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center)));
    }

    return ListView.separated(
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
          child: InfoCard( // Menggunakan InfoCard yang sudah direvisi
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
    );
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
                    // Header
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
                                        snapshot.data ?? 'Pengguna';
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

                    // Search bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari nama anak...',
                          prefixIcon: const Icon(Icons.search),
                           suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              )
                            : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 0),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info Card List
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(
                        height: 155,
                        child: _buildAnakListWidget(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Teman Sehat Anak
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
                              child: const CategoryCard(
                                title: 'Fasilitas Kesehatan',
                                icon: Icons.local_hospital_outlined, // Mengganti ikon
                                color: Colors.redAccent, // Sedikit variasi warna
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
                                icon: Icons.restaurant_menu_outlined, // Mengganti ikon
                                color: Color(0xFF5D78FD),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Terbaru
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
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: NetworkNewsCard(
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

          // BottomNavBar
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

// InfoCard (REVISED FOR OVERFLOW PREVENTION)
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
          Text(
            name.toUpperCase(),
            maxLines: 1, // Ditambahkan
            overflow: TextOverflow.ellipsis, // Ditambahkan
            style: const TextStyle(
                color: Color.fromARGB(255, 255, 224, 98),
                fontSize: 14,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              // Menggunakan Icon yang lebih generik jika jenis kelamin belum pasti ikonnya
              Icon(
                gender.toLowerCase() == 'laki-laki' ? Icons.male : 
                gender.toLowerCase() == 'perempuan' ? Icons.female : Icons.person_outline, 
                color: Colors.white, 
                size: 14
              ),
              const SizedBox(width: 4),
              Text(gender,
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.monitor_weight_outlined, color: Colors.white, size: 14), // Menggunakan outlined icon
              const SizedBox(width: 4),
              Text("$weight Kg",
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 14), // Menggunakan outlined icon
              const SizedBox(width: 4),
              Text("$age Bln • $height cm", // Singkatan "Bulan"
                  style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Spacer(),
          // Tampilkan bagian prediksi hanya jika modelResult valid dan bukan placeholder
          if (modelResult != null && modelResult != 'Tidak Ada Data' && modelResult!.isNotEmpty) ...[
            Text(
              'Prediksi: $modelResult',
              maxLines: 1, // Ditambahkan
              overflow: TextOverflow.ellipsis, // Ditambahkan
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
                fontSize: 20, // Ukuran font skor bisa dipertimbangkan jika masih overflow
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CategoryCard (Tetap Sama, mungkin dengan sedikit penyesuaian ikon/style jika diinginkan)
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
      padding: const EdgeInsets.all(8), // Padding agar konten tidak terlalu mepet
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
            Icon(icon, size: 36, color: Colors.white), // Ukuran ikon mungkin bisa disesuaikan
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center, // Untuk judul yang mungkin panjang
              style: const TextStyle(
                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), // Ukuran font mungkin bisa disesuaikan
            ),
          ],
        ),
      ),
    );
  }
}


// NetworkNewsCard (REVISI - Menggunakan Container + Padding)
// (Kode NetworkNewsCard Anda sebelumnya sudah baik, saya salin kembali)
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
      child: Material( 
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding( 
            padding: const EdgeInsets.all(12.0), 
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0), 
                  child: Container(
                    width: 80, 
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.grey, // Placeholder jika tidak ada gambar
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                            imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image,
                                  size: 40, color: Colors.white70); 
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2));
                            },
                          )
                        : const Icon(Icons.image_outlined, size: 40, color: Colors.white70), 
                  ),
                ),
                const SizedBox(width: 12), 
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