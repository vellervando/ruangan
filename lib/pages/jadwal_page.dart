// lib/pages/jadwal_page.dart
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'booking_saya_page.dart';
import 'profil_page.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final int _currentIndex = 2; // Indeks 2 untuk menu 'Jadwal'
  int _selectedDayIndex = 0; // Mengontrol hari yang dipilih di kalender horizontal

  // Data tiruan untuk kalender horizontal
  final List<Map<String, String>> _days = [
    {'day': 'Sen', 'date': '21'},
    {'day': 'Sel', 'date': '22'},
    {'day': 'Rab', 'date': '23'},
    {'day': 'Kam', 'date': '24'},
    {'day': 'Jum', 'date': '25'},
    {'day': 'Sab', 'date': '26'},
    {'day': 'Ming', 'date': '27'},
  ];

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
                image: NetworkImage('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=600'),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),

          // --- 2. KONTEN HALAMAN ---
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // --- MINI HEADER ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
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
                              const Text(
                                'Sekolah Vokasi Universitas Pakuan',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF247A75), height: 1.0),
                              ),
                            ],
                          )
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_none_outlined, size: 28, color: Colors.black),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // --- JUDUL HALAMAN ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Jadwal Saya',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),

                const SizedBox(height: 16),

                // --- KALENDER HORIZONTAL ---
                Container(
                  height: 65,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_days.length, (index) {
                      final isSelected = _selectedDayIndex == index;
                      final textColor = isSelected ? const Color(0xFF247A75) : Colors.black;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: index != _days.length - 1
                                  ? const Border(right: BorderSide(color: Colors.black12, width: 1))
                                  : null,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _days[index]['day']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _days[index]['date']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 24),

                // --- TEXT SUBJUDUL AGENDA ---
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'Agenda',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),

                // --- DAFTAR AGENDA (LIST VIEW) ---
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    children: [
                      _buildAgendaCard(
                        imageUrl: 'https://images.unsplash.com/photo-1517502884422-41eaead166d4?q=80&w=150',
                        timeRoom: '09.00 - 12.00 | Ruang Rapat Utama',
                        status: 'Dipesan',
                        purpose: 'Rapat Internal',
                      ),
                      const SizedBox(height: 14),
                      _buildAgendaCard(
                        imageUrl: 'https://images.unsplash.com/photo-1562774053-701939374585?q=80&w=150',
                        timeRoom: '13.00 - 15.00 | Lab Komputer',
                        status: 'Selesai',
                        purpose: 'Praktikum',
                      ),
                      const SizedBox(height: 14),
                      _buildAgendaCard(
                        imageUrl: 'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=150',
                        timeRoom: '13.00 - 15.00 | Aula',
                        status: 'Dibatalkan',
                        purpose: 'Seminar',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // --- 3. BOTTOM NAVIGATION BAR (Navigasi Diperbaiki Total) ---
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF247A75),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        onTap: (index) {
          if (index == 0) {
            // Kembali ke Beranda / Reset Stack agar bersih
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false,
            );
          } else if (index == 1) {
            // Pindah ke halaman Booking Saya
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const BookingSayaPage()),
            );
          } else if (index == 3) {
            // Pindah ke halaman Profil
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Bookingan\nSaya'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Jadwal'), 
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profil'),
        ],
      ),
    );
  }

  // Widget Pembuat Kartu Konten Agenda
  Widget _buildAgendaCard({
    required String imageUrl,
    required String timeRoom,
    required String status,
    required String purpose,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 90,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 90,
                  height: 70,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeRoom,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Status : $status',
                    style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Keperluan : $purpose',
                    style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}