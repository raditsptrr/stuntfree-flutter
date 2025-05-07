import 'package:flutter/material.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String date;
  final String imagePath;
  final String content;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.date,
    required this.imagePath,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App bar custom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, color: Color(0xFF5D78FD), size: 32),
                  ),
                  const Spacer(),
                  const Text(
                    "Berita",
                    style: TextStyle(
                      color: Color(0xFF5D78FD),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24), // untuk mengimbangi icon back
                ],
              ),
            ),

            // Header image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Title & date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
