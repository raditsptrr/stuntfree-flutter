import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import '../service/api_service.dart'; // Import ApiService
import '../models/pengukuran_model.dart'; // Import Pengukuran

class ChildDetailScreen extends StatefulWidget {
  final Map<String, dynamic> anakData;

  const ChildDetailScreen({super.key, required this.anakData});

  @override
  State<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends State<ChildDetailScreen> {
  late Future<List<Pengukuran>> _pengukuranFuture;
  late int idAnak;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    idAnak = widget.anakData['id'];
    _pengukuranFuture = _apiService.fetchPengukuranAnak(idAnak);
  }

  // Fungsi untuk memformat tanggal lahir (DD-MM-YYYY)
  String _formatTanggalLahir(String? tanggalLahirStr) {
    if (tanggalLahirStr == null) return '-';
    try {
      final birthDate = DateTime.parse(tanggalLahirStr);
      return DateFormat('dd-MM-yyyy').format(birthDate);
    } catch (e) {
      return tanggalLahirStr;
    }
  }

  // Fungsi generik untuk membangun LineChart
  Widget _buildLineChart({
    required List<FlSpot> spots,
    required double minY,
    required double maxY,
    required double minX,
    required double maxX,
    required Color lineColor,
    required List<Color> gradientColors,
  }) {
     if (spots.isEmpty) {
       return const Center(child: Text("Data tidak tersedia untuk grafik ini."));
    }

    return LineChart(
      LineChartData(
        minY: (minY - 1).floorToDouble(), // Padding Y
        maxY: (maxY + 1).ceilToDouble(), // Padding Y
        minX: minX == maxX ? minX -1 : minX, // Handle 1 data point X
        maxX: minX == maxX ? maxX + 1: maxX, // Handle 1 data point X
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: Colors.grey, strokeWidth: 0.5),
          getDrawingVerticalLine: (value) =>
              const FlLine(color: Colors.grey, strokeWidth: 0.5),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: ((maxX - minX) / 4 > 1 ? ((maxX - minX) / 4) : 1).roundToDouble(),
              getTitlesWidget: (value, meta) => SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8.0,
                child: Text(value.toInt().toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 10)),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(value.toStringAsFixed(1),
                  style: const TextStyle(color: Colors.black, fontSize: 10)),
            ),
          ),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey)),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(colors: gradientColors),
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: gradientColors.map((color) => color.withOpacity(0.3)).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun grafik ZS TBU
  Widget _buildZsTbuChart(List<Pengukuran> data) {
    final chartData = data.where((p) => p.zsTbu != null).toList();
    if (chartData.isEmpty) return const Center(child: Text("Tidak ada data ZS TBU."));

    final spots = chartData.map((p) => FlSpot(p.usiaBulan.toDouble(), p.zsTbu!)).toList();
    final minX = chartData.first.usiaBulan.toDouble();
    final maxX = chartData.last.usiaBulan.toDouble();
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return _buildLineChart(
      spots: spots,
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineColor: Colors.blueAccent,
      gradientColors: [const Color(0xFF5D78FD), const Color(0xFF448AFF)],
    );
  }

  // Fungsi untuk membangun grafik Tinggi Badan
  Widget _buildTinggiChart(List<Pengukuran> data) {
    final chartData = data.where((p) => p.tinggi > 0).toList();
     if (chartData.isEmpty) return const Center(child: Text("Tidak ada data Tinggi Badan."));

    final spots = chartData.map((p) => FlSpot(p.usiaBulan.toDouble(), p.tinggi)).toList();
    final minX = chartData.first.usiaBulan.toDouble();
    final maxX = chartData.last.usiaBulan.toDouble();
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return _buildLineChart(
      spots: spots,
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineColor: Colors.green,
      gradientColors: [Colors.greenAccent, Colors.green],
    );
  }

  // Fungsi untuk membangun grafik Berat Badan
  Widget _buildBeratChart(List<Pengukuran> data) {
     final chartData = data.where((p) => p.berat > 0).toList();
     if (chartData.isEmpty) return const Center(child: Text("Tidak ada data Berat Badan."));

    final spots = chartData.map((p) => FlSpot(p.usiaBulan.toDouble(), p.berat)).toList();
    final minX = chartData.first.usiaBulan.toDouble();
    final maxX = chartData.last.usiaBulan.toDouble();
    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return _buildLineChart(
      spots: spots,
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineColor: Colors.orange,
      gradientColors: [Colors.orangeAccent, Colors.orange],
    );
  }

  // Fungsi helper untuk membangun section grafik
  Widget _buildChartSection({
      required String title,
      required Future<List<Pengukuran>> future,
      required Widget Function(List<Pengukuran>) builder,
  }) {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 10),
                  Container(
                      height: 250,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                           boxShadow: const [ // Tambahkan shadow
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                      alignment: Alignment.center,
                      child: FutureBuilder<List<Pengukuran>>(
                          future: future,
                          builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return const Text("Tidak ada riwayat pengukuran.");
                              } else {
                                  return builder(snapshot.data!);
                              }
                          },
                      ),
                  ),
                  const SizedBox(height: 24), // Jarak antar grafik
              ],
          ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final String nama = widget.anakData['nama'] ?? 'Tidak Diketahui';
    final String status = widget.anakData['hasil'] ?? 'Belum ada data';
    final int jenisKelaminValue = widget.anakData['jenis_kelamin'] ?? -1;
    final String jenisKelamin = jenisKelaminValue == 1 ? 'Laki-laki' : 'Perempuan';
    final String tanggalLahir = _formatTanggalLahir(widget.anakData['tanggal_lahir']);
    final String usiaBulan = (widget.anakData['usia_bulan']?.toString() ?? '-') + ' Bulan';
    final String berat = (widget.anakData['berat']?.toString() ?? '-') + ' Kg';
    final String tinggi = (widget.anakData['tinggi']?.toString() ?? '-') + ' cm';
    final String nik = widget.anakData['nik'] ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F7FD),
      body: SafeArea(
        child: SingleChildScrollView( // Bungkus Column dengan SingleChildScrollView
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
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Color(0xFF5D78FD)),
                      onPressed: () {},
                    ),
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
                     boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Icon(
                          jenisKelaminValue == 1 ? Icons.male : Icons.female,
                          size: 80,
                          color: const Color(0xFF5D78FD),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nama, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text("NIK: $nik", style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text("Tgl Lahir: $tanggalLahir", style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Text("Status: $status",
                                style: TextStyle(
                                    color: status.toLowerCase().contains('stunting') || status.toLowerCase().contains('gizi')
                                        ? Colors.redAccent
                                        : Colors.green,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
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
                     boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ],
                  ),
                  child: GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Penting saat di dalam ScrollView
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 3.5,
                    ),
                    children: [
                      InfoItem(icon: Icons.person_outline, label: "Jenis Kelamin", value: jenisKelamin),
                      InfoItem(icon: Icons.calendar_today, label: "Umur", value: usiaBulan),
                      InfoItem(icon: Icons.monitor_weight, label: "Berat", value: berat),
                      InfoItem(icon: Icons.height, label: "Tinggi", value: tinggi),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tampilkan Tiga Grafik
              _buildChartSection(
                title: "Riwayat Status Gizi (ZS TBU)",
                future: _pengukuranFuture,
                builder: (data) => _buildZsTbuChart(data),
              ),
              _buildChartSection(
                title: "Riwayat Tinggi Badan (cm)",
                future: _pengukuranFuture,
                builder: (data) => _buildTinggiChart(data),
              ),
              _buildChartSection(
                title: "Riwayat Berat Badan (kg)",
                future: _pengukuranFuture,
                builder: (data) => _buildBeratChart(data),
              ),
              // Hapus const Spacer();

              // Delete Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("Hapus Data Anak"),
                                content: Text("Apakah Anda yakin ingin menghapus data $nama?"),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
                                  ElevatedButton(
                                      onPressed: () {
                                        print("Hapus data anak ID: $idAnak");
                                        Navigator.pop(ctx);
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: const Text("Hapus", style: TextStyle(color: Colors.white))),
                                ],
                              ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text(
                      "Hapus Data",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// InfoItem (Tetap Sama)
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
            mainAxisAlignment: MainAxisAlignment.center,
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