import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Tambahan
import '../service/api_service.dart';
import '../models/ortu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        isLoading = false;
        errorMessage = 'Email dan password harus diisi';
      });
      return;
    }

    try {
      final result = await apiService.login(email, password);

      if (result['success']) {
        Ortu ortu = result['ortu'];
        String token = result['token'];

        // ✅ Simpan id_ortu ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('id_ortu', ortu.id!);

        print('Login berhasil, token: $token');
        print('Nama user: ${ortu.nama}');

        // Navigasi ke halaman home (ganti sesuai kebutuhan)
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Login gagal';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundGradient,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Image.asset(
                          'assets/images/child.png',
                          height: 150,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                            decoration: containerDecoration,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hai\nSelamat Datang!',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Sobat Jalu silahkan masuk untuk melaporkan',
                                  style: greySubtitleText,
                                ),
                                const SizedBox(height: 20),

                                // Email
                                TextField(
                                  controller: emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 20),

                                // Password
                                TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: 'Kata Sandi',
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30),

                                // Tombol Login
                                ElevatedButton(
                                  onPressed: isLoading ? null : _login,
                                  style: buttonStyle,
                                  child: isLoading
                                      ? const CircularProgressIndicator(color: Colors.white)
                                      : const Text('Masuk', style: buttonTextStyle),
                                ),

                                if (errorMessage != null) ...[
                                  const SizedBox(height: 20),
                                  Text(
                                    errorMessage!,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ],

                                const SizedBox(height: 20),

                                // Daftar
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Belum punya akun? ',
                                          style: greySmallText,
                                        ),
                                        TextSpan(
                                          text: 'Daftar di sini',
                                          style: boldBlackSmallText,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(context, '/signup');
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// Styling
const backgroundGradient = BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
);

const containerDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(30),
  ),
);

const greySubtitleText = TextStyle(
  color: Colors.grey,
  fontSize: 14,
);

const buttonTextStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

final buttonStyle = ElevatedButton.styleFrom(
  backgroundColor: Color(0xFF5D78FD),
  minimumSize: Size.fromHeight(50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);

const greySmallText = TextStyle(
  color: Color.fromARGB(255, 212, 212, 212),
  fontSize: 12,
);

const boldBlackSmallText = TextStyle(
  color: Colors.black,
  fontSize: 14,
  fontWeight: FontWeight.bold,
);
