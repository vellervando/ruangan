// lib/pages/login_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Latar Belakang (Gambar samar-samar)
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1F0), 
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=600',
                ),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),

          // Konten Utama
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // BAGIAN LOGO & JUDUL aplikasi
                  _buildHeader(),
                  
                  const SizedBox(height: 30),

                  // KARTU LOGIN (Efek Blur / Glassmorphism)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Center(
                              child: Text(
                                'Masukan Akun',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF247A75),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // PENGGUNAAN INPUT FIELD NPM
                            const LocalCustomTextField(
                              label: 'NPM',
                              hintText: 'Masukkan NPM Anda',
                              prefixIcon: Icons.account_box_outlined,
                            ),
                            const SizedBox(height: 20),

                            // PENGGUNAAN INPUT FIELD PASSWORD
                            LocalCustomTextField(
                              label: 'Password',
                              hintText: 'Masukkan Password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _isPasswordObscured,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured 
                                      ? Icons.visibility_off_outlined 
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF247A75),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                            ),
                            
                            // Link Lupa Sandi
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Lupa Kata Sandi?',
                                  style: TextStyle(color: Color(0xFF247A75), fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // TOMBOL MASUK
                            _buildLoginButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),

                  // TEKS HAK CIPTA / FOOTER DI BAWAH
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget pendukung untuk memperbersih susunan kode diatas:
  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.meeting_room_outlined, size: 40, color: Color(0xFF247A75)),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pinjam', 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF247A75).withOpacity(0.8), height: 1.0),
                ),
                const Text(
                  'Ruang', 
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF247A75), height: 1.0),
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Peminjaman Ruangan', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          'Sekolah Vokasi Universitas Pakuan', 
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.8)), // SUDAH DIPERBAIKI
        ),
      ],
    );
  }
Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF247A75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        onPressed: () {
          // Navigasi pindah ke halaman Dashboard (HomePage)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Icon(Icons.login, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '© 2024 Sekolah Vokasi Universitas Pakuan', 
          style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.6)), // SUDAH DIPERBAIKI
        ),
        const SizedBox(width: 8),
        Icon(Icons.settings_outlined, size: 16, color: const Color(0xFF247A75).withOpacity(0.7)),
        const SizedBox(width: 4),
        Icon(Icons.help_outline, size: 16, color: const Color(0xFF247A75).withOpacity(0.7)),
      ],
    );
  }
}

// Widget Custom Text Field Lokal agar tidak usah pusing urusan import folder
class LocalCustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  const LocalCustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF247A75),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(prefixIcon, color: const Color(0xFF247A75)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF7F4EB),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.black.withOpacity(0.38)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF247A75), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}