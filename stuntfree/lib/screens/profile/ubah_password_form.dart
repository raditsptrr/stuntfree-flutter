import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../service/api_service.dart';

class UbahPasswordPage extends StatefulWidget {
  const UbahPasswordPage({super.key});

  @override
  State<UbahPasswordPage> createState() => _UbahPasswordPageState();
}

class _UbahPasswordPageState extends State<UbahPasswordPage> {
  final TextEditingController _lamaController = TextEditingController();
  final TextEditingController _baruController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();

  bool _isLoading = false;
  String? _namaOrtu;

  // Variabel toggle show/hide password
  bool _obscureLama = true;
  bool _obscureBaru = true;
  bool _obscureKonfirmasi = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _namaOrtu = prefs.getString('nama_ortu') ?? 'Orangtua';
    });
  }

  Future<void> _confirmAndChangePassword() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
            'Setelah mengubah password, Anda akan keluar dan harus login ulang. Lanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      _ubahPassword();
    }
  }

  Future<void> _ubahPassword() async {
    final prefs = await SharedPreferences.getInstance();
    final int? idOrangtua = prefs.getInt('id_orangtua');

    if (idOrangtua == null) {
      _showSnackBar('ID Orangtua tidak ditemukan. Silakan login ulang.');
      return;
    }

    final lama = _lamaController.text.trim();
    final baru = _baruController.text.trim();
    final konfirmasi = _konfirmasiController.text.trim();

    if (lama.isEmpty || baru.isEmpty || konfirmasi.isEmpty) {
      _showSnackBar('Semua kolom harus diisi.');
      return;
    }

    if (baru != konfirmasi) {
      _showSnackBar('Konfirmasi kata sandi tidak cocok.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ApiService();
      final result = await apiService.ubahPassword(
        id: idOrangtua,
        lama: lama,
        baru: baru,
      );

      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSnackBar('Password berhasil diubah. Silakan login ulang.');
        // Clear SharedPreferences dan logout otomatis
        await prefs.clear();
        // Navigasi ke halaman login, ganti sesuai route login kamu
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        final message = result['message'] ?? 'Gagal mengubah password.';
        _showSnackBar(message);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('Terjadi kesalahan: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _lamaController.dispose();
    _baruController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleObscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF1F1F1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleObscure,
            ),
          ),
        ),
      ],
    );
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
          'KATA SANDI',
          style: TextStyle(
            color: Color(0xFF007AFF),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFFB3D6FF),
                child: Icon(Icons.person, size: 50, color: Color(0xFF007AFF)),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                _namaOrtu != null ? _namaOrtu!.toUpperCase() : 'ORANGTUA',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007AFF),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildPasswordField(
              'Kata Sandi Lama',
              _lamaController,
              _obscureLama,
              () => setState(() => _obscureLama = !_obscureLama),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              'Kata Sandi Baru',
              _baruController,
              _obscureBaru,
              () => setState(() => _obscureBaru = !_obscureBaru),
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              'Konfirmasi Kata Sandi',
              _konfirmasiController,
              _obscureKonfirmasi,
              () => setState(() => _obscureKonfirmasi = !_obscureKonfirmasi),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _confirmAndChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007AFF),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
