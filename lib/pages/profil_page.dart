import 'package:flutter/material.dart';
import '../supabase_client.dart'; 
import 'home_page.dart';
import 'booking_saya_page.dart';
import 'jadwal_page.dart';
import 'login_page.dart';
import 'detail_akun_page.dart';
import 'ubah_sandi_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final int _currentIndex = 3;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        // Mengambil data dari tabel 'profiles'
        // Pastikan tabel 'profiles' memiliki kolom 'id', 'nama', 'npm'
        final data = await supabase
            .from('users_profile')
            .select('nama, npm')
            .eq('id', user.id)
            .single();
        
        if (mounted) {
          setState(() {
            _userData = data;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
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
                opacity: 0.25,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 24.0),
                  child: Text(
                    'Profil Pengguna',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                
                Center(
                  child: _isLoading 
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/velka.jpeg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _userData?['nama'] ?? 'Pengguna',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'NPM: ${_userData?['npm'] ?? '-'}',
                            style: TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                ),
                
                const SizedBox(height: 40),
                
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildMenuDivider(),
                      HoverMenuTile(icon: Icons.person_outline, title: 'Detail Akun', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailAkunPage()))),
                      _buildMenuDivider(),
                      HoverMenuTile(icon: Icons.lock_open_outlined, title: 'Ubah Sandi', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const UbahSandiPage()))),
                      _buildMenuDivider(),
                      HoverMenuTile(
                        icon: Icons.logout,
                        title: 'Keluar',
                        onTap: () async {
                          await supabase.auth.signOut();
                          if (!mounted) return;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginPage()), (route) => false);
                        },
                      ),
                      _buildMenuDivider(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildMenuDivider() => Divider(height: 1, thickness: 1, color: Colors.black.withOpacity(0.15));

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF247A75),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        else if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BookingSayaPage()));
        else if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JadwalPage()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Bookingan\nSaya'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profil'),
      ],
    );
  }
}

class HoverMenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const HoverMenuTile({super.key, required this.icon, required this.title, required this.onTap});
  @override
  State<HoverMenuTile> createState() => _HoverMenuTileState();
}

class _HoverMenuTileState extends State<HoverMenuTile> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: ListTile(
        leading: Icon(widget.icon, color: _isHovered ? const Color(0xFF247A75) : Colors.black87),
        title: Text(widget.title, style: TextStyle(color: _isHovered ? const Color(0xFF247A75) : Colors.black87, fontWeight: FontWeight.w600)),
        onTap: widget.onTap,
      ),
    );
  }
}