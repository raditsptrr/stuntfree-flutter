import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import 'package:stuntfree/screens/child_detail_screen.dart';
import 'package:stuntfree/screens/news_detail_screen.dart';
import '../service/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _anakFuture;

  Future<String?> getNamaOrtu() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('nama_ortu');
  }

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
    // Filter anak yang statusnya diterima
    return data.where((anak) => anak['status'].toString().toLowerCase() == 'diterima').toList();
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [Color(0xFF5D78FD), Color(0xFF448AFF)],
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
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [Color(0xFF5D78FD), Color(0xFF448AFF)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const Text(
                                          "...",
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [Color(0xFF5D78FD), Color(0xFF448AFF)],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ).createShader(bounds);
                                        },
                                        child: const Text(
                                          "Error",
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    } else {
                                      final namaOrtu = snapshot.data ?? 'Nama Tidak Tersedia';
                                      return ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [Color(0xFF5D78FD), Color(0xFF448AFF)],
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
                                    }
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info Card List dari API (dengan hasil model)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: SizedBox(
                        height: 155,
                        child: FutureBuilder<List<Map<String, dynamic>>>(
                          future: _anakFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Gagal memuat data anak'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('Tidak ada anak yang diterima'));
                            } else {
                              final anakList = snapshot.data!;
                              return ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: anakList.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final anak = anakList[index];

                                  // Ambil hasil model dari data API dengan key 'hasil'
                                  final hasilModel = anak['hasil'] ?? 'Tidak Ada Data';

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ChildDetailScreen(),
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
                                      modelResult: hasilModel,  // pakai key 'hasil' dari API
                                    ),
                                  );
                                },

                              );
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Teman Sehat Anak",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: const [
                          Expanded(
                            child: CategoryCard(
                              title: 'Pediatrics',
                              icon: Icons.child_care,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: CategoryCard(
                              title: 'Cardiology',
                              icon: Icons.favorite,
                              color: Color(0xFF5D78FD),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Terbaru",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          NewsCard(
                            title:
                                "Pemerintah Terus Gencarkan Upaya Penanggulangan Stunting di Indonesia",
                            date: "10 May 2025",
                            description:
                                "Stunting masih menjadi tantangan serius dalam pembangunan sumber daya manusia di Indonesia.",
                            imagePath: 'assets/images/3.jpg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewsDetailScreen(
                                    title:
                                        "Pemerintah Terus Gencarkan Upaya Penanggulangan Stunting di Indonesia",
                                    date: "10 May 2025",
                                    imagePath: 'assets/images/3.jpg',
                                    content:
                                        "Stunting masih menjadi tantangan serius dalam pembangunan sumber daya manusia di Indonesia. [...]",
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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

// Modifikasi InfoCard supaya bisa menerima hasil model
class InfoCard extends StatelessWidget {
  final String name;
  final String gender;
  final int weight;
  final int age;
  final int height;
  final double score;
  final Color color;

  // Tambahan untuk hasil model prediksi
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
      height: 155, // tambah tinggi sedikit untuk hasil model
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
              Text(gender, style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.monitor_weight, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text("$weight Kg", style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 14),
              const SizedBox(width: 4),
              Text("$age Bulan • $height cm", style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Spacer(),

          // Tampilkan score dan hasil model di bawah
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

// Kelas CategoryCard dan NewsCard tetap sama seperti sebelumnya
class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const CategoryCard({super.key, required this.title, required this.icon, required this.color});

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
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imagePath;
  final VoidCallback onTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(imagePath), fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
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
            )
          ],
        ),
      ),
    );
  }
}
