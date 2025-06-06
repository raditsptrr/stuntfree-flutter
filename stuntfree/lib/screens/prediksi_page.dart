import 'package:flutter/material.dart';
import '../service/api_service.dart';

class PrediksiPage extends StatefulWidget {
  const PrediksiPage({super.key});

  @override
  State<PrediksiPage> createState() => _PrediksiPageState();
}

class _PrediksiPageState extends State<PrediksiPage> {
  final TextEditingController _umurController = TextEditingController();
  final TextEditingController _beratController = TextEditingController();
  final TextEditingController _tinggiController = TextEditingController();
  bool _isLoading = false;

  late int idAnak;
  late String namaAnak;

  bool isEditMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    idAnak = arguments['idAnak'];
    namaAnak = arguments['nama'];

    if (arguments.containsKey('umur') &&
        arguments.containsKey('berat') &&
        arguments.containsKey('tinggi')) {
      isEditMode = true;
      _umurController.text = arguments['umur']?.toString() ?? '';
      _beratController.text = arguments['berat']?.toString() ?? '';
      _tinggiController.text = arguments['tinggi']?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _umurController.dispose();
    _beratController.dispose();
    _tinggiController.dispose();
    super.dispose();
  }

  Future<void> _submitPrediksi() async {
    final String umurText = _umurController.text;
    final String beratText = _beratController.text;
    final String tinggiText = _tinggiController.text;

    if (umurText.isEmpty || beratText.isEmpty || tinggiText.isEmpty) {
      _showSnackBar('Semua field harus diisi.');
      return;
    }

    try {
      setState(() => _isLoading = true);

      final int umur = int.parse(umurText);
      final double berat = double.parse(beratText);
      final double tinggi = double.parse(tinggiText);

      final result = await ApiService().submitPengukuran(
        idAnak: idAnak,
        berat: berat,
        tinggi: tinggi,
        usiaBulan: umur,
      );

      setState(() => _isLoading = false);

      if (result != null) {
        _showSnackBar('Data berhasil dikirim!');
        Navigator.pushReplacementNamed(context, '/dataanak');
      } else {
        _showSnackBar('Gagal mengirim data');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Terjadi kesalahan: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content:
            const Text('Apakah Anda yakin ingin membatalkan pengisian form?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dataanak');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5D78FD),
            ),
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF5D78FD),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF2F2F2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Column(
          children: [
            // Header tanpa AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF5D78FD)),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  const Text(
                    'Tambah Data',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF5D78FD),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // Konten Tengah
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Silahkan masukkan data untuk prediksi',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF5D78FD),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Masukkan umur, tinggi badan, dan berat badan agar mengetahui prediksi tumbuh kembang anak',
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 24),

                        _buildFieldLabel('Nama Anak'),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: namaAnak,
                          items: [
                            DropdownMenuItem(
                              value: namaAnak,
                              child: Text(namaAnak),
                            ),
                          ],
                          onChanged: null,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFF2F2F2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),

                        const SizedBox(height: 16),
                        _buildFieldLabel('Umur (bulan)'),
                        _buildTextField(_umurController, 'Masukkan umur dalam bulan'),
                        const SizedBox(height: 16),
                        _buildFieldLabel('Berat Badan (kg)'),
                        _buildTextField(_beratController, 'Masukkan berat badan'),
                        const SizedBox(height: 16),
                        _buildFieldLabel('Tinggi Badan (cm)'),
                        _buildTextField(_tinggiController, 'Masukkan tinggi badan'),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _showCancelConfirmation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: const Text(
                                  'Batal',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _submitPrediksi,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5D78FD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                        isEditMode ? 'Update' : 'Prediksi',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
