import 'package:flutter/material.dart';
import '../supabase_client.dart'; // Sesuaikan path ini

class DetailAkunPage extends StatefulWidget {
  const DetailAkunPage({super.key});

  @override
  State<DetailAkunPage> createState() => _DetailAkunPageState();
}

class _DetailAkunPageState extends State<DetailAkunPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _npmController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // Mengambil data dari Supabase
  Future<void> _fetchUserData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('users_profile')
          .select('nama, npm, email, prodi')
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _namaController.text = data['nama'] ?? '';
          _npmController.text = data['npm'] ?? '';
          _emailController.text = data['email'] ?? '';
          _prodiController.text = data['prodi'] ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Menyimpan perubahan ke Supabase
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      await supabase.from('profiles').update({
        'nama': _namaController.text,
        'email': _emailController.text,
        'prodi': _prodiController.text,
      }).eq('id', user!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perubahan akun berhasil disimpan!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _npmController.dispose();
    _emailController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F0),
      appBar: AppBar(
        title: const Text('Detail Akun', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF247A75),
        foregroundColor: Colors.white,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) 
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Foto Profil
                  Container(
                    width: 90, height: 90,
                    decoration: const BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: AssetImage('assets/velka.jpeg'), fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(controller: _namaController, label: 'Nama Lengkap', icon: Icons.person_outline),
                  const SizedBox(height: 16),
                  _buildInputField(controller: _npmController, label: 'NPM', icon: Icons.badge_outlined, enabled: false),
                  const SizedBox(height: 16),
                  _buildInputField(controller: _emailController, label: 'Email', icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildInputField(controller: _prodiController, label: 'Program Studi / Fakultas', icon: Icons.school_outlined),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF247A75), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      onPressed: _updateProfile,
                      child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildInputField({required TextEditingController controller, required String label, required IconData icon, bool enabled = true, TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF247A75), fontSize: 14)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller, enabled: enabled, keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF247A75)),
            filled: true, fillColor: enabled ? Colors.white : Colors.grey[200],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
          ),
        ),
      ],
    );
  }
}