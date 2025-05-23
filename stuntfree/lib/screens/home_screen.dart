import 'package:flutter/material.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import 'package:stuntfree/screens/child_detail_screen.dart';
import 'package:stuntfree/screens/news_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Background dan konten utama
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
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      colors: [Color(0xFF5D78FD), Color(0xFF448AFF)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: const Text(
                                    "FAHZIL RAUL",
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                    ),
                                  ),
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

                    // Search Bar
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

                    // Info Card List
                    SizedBox(
                      height: 140,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 16),
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ChildDetailScreen()),
                              );
                            },
                            child: const InfoCard(
                              name: "Fahzil Raul",
                              gender: "Laki-Laki",
                              weight: 50,
                              age: 20,
                              height: 170,
                              score: -2.3,
                              color: Color(0xFF5D78FD),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
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
                            title: "Pemerintah Terus Gencarkan Upaya Penanggulangan Stunting di Indonesia",
                            date: "10 May 2025",
                            description:
                                "Stunting masih menjadi tantangan serius dalam pembangunan sumber daya manusia di Indonesia.",
                            imagePath: 'assets/images/3.jpg',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => NewsDetailScreen(
                                    title: "Pemerintah Terus Gencarkan Upaya Penanggulangan Stunting di Indonesia",
                                    date: "10 May 2025",
                                    imagePath: 'assets/images/3.jpg',
                                    content:
                                        "Stunting masih menjadi tantangan serius dalam pembangunan sumber daya manusia di Indonesia. Data dari Survei Kesehatan Indonesia (SKI) 2023 menunjukkan bahwa angka stunting nasional berada pada angka 21,6 persen. Meskipun mengalami penurunan dari tahun sebelumnya, angka tersebut masih jauh dari target pemerintah yang ingin menurunkan stunting hingga 14 persen pada tahun 2024. Berbagai program terus digalakkan oleh pemerintah, seperti pemberian makanan tambahan bergizi, edukasi pola asuh kepada orang tua, serta pemeriksaan kesehatan rutin bagi ibu hamil dan balita. Presiden Joko Widodo dalam beberapa kesempatan menegaskan pentingnya kerja sama lintas sektor mulai dari pemerintah pusat hingga ke tingkat desa dalam upaya percepatan penurunan stunting. Para ahli kesehatan juga menekankan bahwa pencegahan stunting harus dimulai sejak masa kehamilan, bahkan sebelum bayi lahir. Asupan gizi yang cukup, akses air bersih, dan sanitasi yang baik merupakan faktor penting dalam menciptakan lingkungan tumbuh kembang yang sehat bagi anak. Dengan komitmen bersama dan keterlibatan masyarakat, Indonesia optimistis mampu mengatasi masalah stunting secara berkelanjutan.",
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


class InfoCard extends StatelessWidget {
  final String name;
  final String gender;
  final int weight;
  final int age;
  final int height;
  final double score;
  final Color color;

  const InfoCard({
    super.key,
    required this.name,
    required this.gender,
    required this.weight,
    required this.age,
    required this.height,
    required this.score,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 140,
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
                  color: Colors.yellow,
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
              Text("$age Tahun • $height cm", style: const TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              score.toString(),
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
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 36),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String date;
  final String description;
  final String imagePath;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}