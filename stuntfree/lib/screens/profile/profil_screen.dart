import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stuntfree/widgets/bottom_navbar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  String _userName = 'Memuat...';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('nama_ortu'); // <- gunakan key yang benar!
    setState(() {
      _userName = name ?? 'Nama Tidak Ditemukan';
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data login
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F9FF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'PROFIL',
          style: TextStyle(
            color: Color(0xFF5D78FD),
            fontWeight: FontWeight.w600,
            fontSize: 18,
            letterSpacing: 1,
          ),
        ),
        
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFF5D78FD),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            _userName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF007AFF),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Material(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      _buildListItem(
                        context,
                        Icons.person_outline,
                        'Data Pribadi',
                        onTap: () => Navigator.pushNamed(context, '/datapribadi'),
                      ),
                      _buildDivider(),
                      _buildListItem(
                        context,
                        Icons.lock_outline,
                        'Ubah Kata Sandi',
                        onTap: () => Navigator.pushNamed(context, '/ubahpassword'),
                      ),
                      _buildDivider(),
                      _buildListItem(
                        context,
                        Icons.info_outline,
                        'Tentang Aplikasi',
                        onTap: () => Navigator.pushNamed(context, '/tentangaplikasi'),
                      ),
                      _buildDivider(),
                      _buildListItem(
                        context,
                        Icons.logout,
                        'Logout',
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.pushNamed(context, '/home');
          if (index == 1) Navigator.pushNamed(context, '/dataanak');
          if (index == 2) Navigator.pushNamed(context, '/berita');
        },
      ),
    );
  }

  Widget _buildListItem(BuildContext context, IconData icon, String title,
      {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListTile(
          leading: Icon(icon, color: const Color(0xFF5D78FD)),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 0.5,
      indent: 16,
      endIndent: 16,
    );
  }
}
