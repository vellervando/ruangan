// lib/pages/profil_page.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'booking_saya_page.dart';
import 'jadwal_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final int _currentIndex = 3; // Aktif di indeks 3 (Profil)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // --- 1. BACKGROUND IMAGE ---
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

          // --- 2. KONTEN HALAMAN ---
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  // --- DATA DIRI USER ---
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage('assets/velka.jpeg'),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rasyid Charles',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Mahasiswa',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black.withValues(alpha: 0.6),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // --- SUB-JUDUL RIWAYAT ---
                  const Text(
                    'Riwayat Bookingan',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- LIST RIWAYAT ---
                  _buildHistoryItem(
                    'https://images.unsplash.com/photo-1517502884422-41eaead166d4?q=80&w=150',
                    'Ruang Rapat Utama',
                    '-Berhasil',
                    const Color(0xFF247A75),
                  ),
                  _buildHistoryItem(
                    'https://images.unsplash.com/photo-1562774053-701939374585?q=80&w=150',
                    'Lab Komputer',
                    '-Selesai',
                    const Color(0xFF247A75),
                  ),
                  _buildHistoryItem(
                    'https://images.unsplash.com/photo-1517502884422-41eaead166d4?q=80&w=150',
                    'Aula',
                    '-Berhasil',
                    const Color(0xFF247A75),
                  ),

                  const SizedBox(height: 10),

                  // --- MENU PENGATURAN AKUN ---
                  _buildSettingMenu(Icons.settings_outlined, 'Pengaturan Akun'),
                  _buildSettingMenu(Icons.help_outline, 'Bantuan'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),

      // --- 3. BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF247A75),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookingSayaPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const JadwalPage()),
            );
          } else if (index == 3) {
            // TAMBAHKAN INI: Navigasi ke halaman profil
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Bookingan\nSaya'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Jadwal'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String imageUrl, String title, String status, Color statusColor) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  imageUrl,
                  width: 90,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.black54, thickness: 1),
      ],
    );
  }

  Widget _buildSettingMenu(IconData icon, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          child: Row(
            children: [
              Icon(icon, size: 26, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        const Divider(color: Colors.black54, thickness: 1),
      ],
    );
  }
}