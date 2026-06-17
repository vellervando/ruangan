import 'dart:ui';
import 'package:flutter/material.dart';
import '../supabase_client.dart'; // Pastikan path ini benar sesuai struktur foldermu
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordObscured = true;
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _npmController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fungsi Login ke Supabase
  Future<void> _handleLogin() async {
    String email = "${_npmController.text.trim()}@unpak.ac.id";
    String password = _passwordController.text.trim();

    if (_npmController.text.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('NPM dan Password tidak boleh kosong!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Gagal: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFE8F1F0),
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=600'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildHeader(),
                  const SizedBox(height: 30),
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
                          children: [
                            const Text('Masukkan Akun', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF247A75))),
                            const SizedBox(height: 24),
                            LocalCustomTextField(controller: _npmController, label: 'NPM', hintText: 'Masukkan NPM', prefixIcon: Icons.account_box_outlined, keyboardType: TextInputType.number),
                            const SizedBox(height: 20),
                            LocalCustomTextField(
                              controller: _passwordController,
                              label: 'Password',
                              hintText: 'Masukkan Password',
                              prefixIcon: Icons.lock_outline,
                              obscureText: _isPasswordObscured,
                              suffixIcon: IconButton(
                                icon: Icon(_isPasswordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF247A75)),
                                onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
                              ),
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF247A75), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                onPressed: _isLoading ? null : _handleLogin,
                                child: _isLoading 
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Masuk', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Widget Tambahan (Header, dll tetap sama) ---
  Widget _buildHeader() { /* ... kode header kamu sebelumnya ... */ return const SizedBox(); }
}

class LocalCustomTextField extends StatelessWidget {
  // ... kode LocalCustomTextField kamu sebelumnya ...
  final String label; final String hintText; final IconData prefixIcon; final bool obscureText; final Widget? suffixIcon; final TextEditingController controller; final TextInputType? keyboardType;
  const LocalCustomTextField({super.key, required this.label, required this.hintText, required this.prefixIcon, required this.controller, this.obscureText = false, this.suffixIcon, this.keyboardType});
  
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF247A75))),
      const SizedBox(height: 6),
      TextField(controller: controller, obscureText: obscureText, keyboardType: keyboardType, decoration: InputDecoration(hintText: hintText, prefixIcon: Icon(prefixIcon, color: const Color(0xFF247A75)), suffixIcon: suffixIcon, filled: true, fillColor: const Color(0xFFF7F4EB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
    ]);
  }
}