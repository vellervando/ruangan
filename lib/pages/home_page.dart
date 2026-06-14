// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'booking_saya_page.dart'; // Import halaman Booking Saya
import 'jadwal_page.dart';       // Import halaman Jadwal
import 'profil_page.dart';       // Import halaman Profil

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index aktif untuk Beranda selalu 0 di halaman ini
  final int _currentIndex = 0; 

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
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  _buildMiniHeader(),
                  const SizedBox(height: 24),
                  const Text('Hai, Vel', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.1)),
                  const Text('Mau Pinjam Ruangan', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.1)),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  const Text('Kategori Ruangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildCategoryRow(),
                  const SizedBox(height: 28),
                  const Text('Rekomendasi Ruangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildRecommendationGrid(context),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildMiniHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.meeting_room_outlined, size: 28, color: Color(0xFF247A75)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Peminjaman Ruangan', 
                  style: TextStyle(
                    fontSize: 11, 
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xFF247A75).withValues(alpha: 0.8), 
                    height: 1.0,
                  ),
                ),
                const Text('Sekolah Vokasi Universitas Pakuan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF247A75), height: 1.0)),
              ],
            )
          ],
        ),
        IconButton(icon: const Icon(Icons.notifications_none_outlined, size: 28, color: Colors.black), onPressed: () {})
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black26),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Cari Ruangan',
          hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem(Icons.groups_outlined, 'Ruang\nRapat', const Color(0xFF9CEFE3)),
        _buildCategoryItem(Icons.computer, 'Lab\nKomputer', const Color(0xFFFFE082)),
        _buildCategoryItem(Icons.chair_alt_outlined, 'Aula', const Color(0xFFB39DDB)),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String title, Color bgColor) {
    return Column(
      children: [
        Container(
          width: 75,
          height: 75,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 3))],
          ),
          child: Icon(icon, size: 36, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black))
      ],
    );
  }

  Widget _buildRecommendationGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildRoomCard(
            context,
            'https://images.unsplash.com/photo-1416339306562-f3d12fefd36f?q=80&w=400',
            'Ruang Rapat Utama',
            '15 Orang',
            'Ac, WiFi, Proyektor dan Papan Tulis',
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildRoomCard(
            context,
            'https://images.unsplash.com/photo-1562774053-701939374585?q=80&w=400',
            'Lab Komputer',
            '30 orang',
            'PC High-End, AC, WiFi, Proyektor, LAN',
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard(BuildContext context, String imageUrl, String roomName, String capacity, String facilities) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(imageUrl, height: 110, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(roomName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.groups, size: 16, color: Colors.black.withOpacity(0.6)),
                    const SizedBox(width: 4),
                    Text(capacity, style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6), fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF247A75),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            roomName: roomName,
                            capacity: capacity,
                            imageUrl: imageUrl,
                            facilities: facilities,
                          ),
                        ),
                      );
                    },
                    child: const Text('Booking', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF247A75),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      onTap: (index) {
        if (index == 1) {
          // Berpindah ke halaman Booking Saya
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookingSayaPage()),
          );
        } else if (index == 2) {
          // Berpindah ke halaman Jadwal
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const JadwalPage()),
          );
        } else if (index == 3) {
          // Berpindah ke halaman Profil
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Bookingan\nSaya'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profil'),
      ],
    );
  }
}