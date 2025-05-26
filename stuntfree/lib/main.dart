import 'package:flutter/material.dart';
import 'screens/onboarding_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/home_screen.dart';
import 'screens/tambah_data_page.dart';
import 'screens/berita_screen.dart';
import 'screens/profile/profil_screen.dart';
import 'screens/profile/data_diri_form.dart';
import 'screens/profile/data_pribadi.dart';
import 'screens/profile/ubah_password_form.dart';
import 'screens/data_anak.dart';
import 'screens/prediksi_page.dart';
void main() {
  runApp(const StuntFreeApp());
}

class StuntFreeApp extends StatelessWidget {
  const StuntFreeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StuntFree',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
      fontFamily: 'Inter',
      useMaterial3: true,
      primaryColor: const Color(0xFF5D78FD),
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5D78FD),
        brightness: Brightness.light,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Color(0xFF5D78FD),         // 🔵 kursor
        selectionColor: Color(0x555D78FD), // 🔵 highlight semi transparan
        selectionHandleColor: Color(0xFF5D78FD), // 🔵 bulatan handle
      ),
      ),
      home: const OnboardingPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomeScreen(),
        '/tambah': (context) => const TambahDataAnakPage(),
        '/prediksi': (context) => const PrediksiPage(),
        '/edit_prediksi': (context) => const PrediksiPage(),
        '/dataanak': (context) => const DataAnakPage(),
        '/berita': (context) => const BeritaScreen(),
        '/profil': (context) => const ProfilPage(),
        '/data_diri': (context) => const DataDiriForm(),
        '/datapribadi': (context) => DataPribadiPage(),
        '/ubahpassword': (context) => const UbahPasswordPage(),
      },
    );
  }
}
