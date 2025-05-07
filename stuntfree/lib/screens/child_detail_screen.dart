import 'package:flutter/material.dart';

class ChildDetailScreen extends StatelessWidget {
  const ChildDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FD),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Color(0xFF5D78FD)),
                    iconSize: 32,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "INFORMASI",
                    style: TextStyle(color: Color(0xFF5D78FD), fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const Icon(Icons.more_vert, color: Color(0xFF5D78FD)),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Profile Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset("assets/images/doctor.png", width: 80, height: 100),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Fahzila Raul", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text("Status: Normal", style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 12),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detail Info Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 3.5,
                  ),
                  children: const [
                    InfoItem(icon: Icons.male, label: "Jenis Kelamin", value: "Laki-laki"),
                    InfoItem(icon: Icons.calendar_today, label: "Umur", value: "20 Tahun"),
                    InfoItem(icon: Icons.monitor_weight, label: "Berat", value: "50 Kg"),
                    InfoItem(icon: Icons.height, label: "Tinggi", value: "170 cm"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Status Section (Dummy)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Status", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    alignment: Alignment.center,
                    child: const Text("Grafik dummy"),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Delete Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Hapus Data"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoItem({super.key, required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF5D78FD)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }
}
