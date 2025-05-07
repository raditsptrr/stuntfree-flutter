import 'package:flutter/material.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';
import 'package:stuntfree/screens/child_detail_screen.dart';
import 'package:stuntfree/screens/news_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header dengan Icon
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CircleAvatar(
                      backgroundColor: Color(0xFFE3F0FF),
                      child: Icon(Icons.person, color: Color(0xFF5D78FD)),
                    ),
                    Icon(Icons.menu, color: Color(0xFF5D78FD)),
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

              // Info Card
              const SizedBox(height: 16),
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
                    const InfoCard(
                      name: "Fahzil Raul",
                      gender: "Laki-Laki",
                      weight: 50,
                      age: 20,
                      height: 170,
                      score: -2.3,
                      color: Colors.amber,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Teman Sehat Anak", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: const [
                    Expanded(
                      child: CategoryCard(title: 'Pediatrics', icon: Icons.child_care, color: Colors.red),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: CategoryCard(title: 'Cardiology', icon: Icons.favorite, color: Color(0xFF5D78FD)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Terbaru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    NewsCard(
                      title: "Victory College",
                      date: "10 May 2025",
                      description: "Studying how CBD awareness and availability as it related to pain management alternatives.",
                      imagePath: 'assets/images/doctor.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NewsDetailScreen(
                              title: "Victory College",
                              date: "10 May 2025", // tambahkan ini
                              imagePath: 'assets/images/doctor.png',
                              content: "Studying how CBD awareness and availability as it related to pain management alternatives. Full article here.",
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) return;
          if (index == 1) Navigator.pushNamed(context, '/dataanak');
          if (index == 2) Navigator.pushNamed(context, '/berita');
          if (index == 3) Navigator.pushNamed(context, '/profil');
        },
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
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
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
  final VoidCallback? onTap; // Tambahan

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
      onTap: onTap, // Tambahan
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
