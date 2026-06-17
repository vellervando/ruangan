import 'package:flutter/material.dart';
import '../supabase_client.dart';
import 'detail_page.dart';
import 'booking_saya_page.dart';
import 'jadwal_page.dart';
import 'profil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String? _userName;
  final _futureRuangan = supabase.from('ruangan').select('*');

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        final response = await supabase
            .from('users_profile')
            .select('nama')
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _userName = response['nama'];
          });
        }
      }
    } catch (e) {
      debugPrint("Error mengambil nama user: $e");
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
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=600',
                ),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),
          SafeArea(
            child: FutureBuilder(
              future: _futureRuangan,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF247A75)));
                }
                if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return const Center(child: Text('Belum ada ruangan tersedia'));
                }

                final ruanganList = snapshot.data as List<dynamic>;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      _buildMiniHeader(),
                      const SizedBox(height: 24),
                      Text('Hai, ${_userName ?? 'User'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const Text('Mau pinjam ruangan apa hari ini?', style: TextStyle(fontSize: 14, color: Colors.grey)),
                      const SizedBox(height: 24),
                      const Text('Daftar Ruangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),

                      // MAP LANGSUNG DI SINI AGAR VARIABEL 'ruangan' BISA DIPAKAI
                      ...ruanganList.map((ruangan) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    roomId: ruangan['id'].toString(),
                                    roomName: ruangan['nama_ruangan'] ?? 'Tanpa Nama',
                                    capacity: 'Kapasitas ${ruangan['kapasitas']} Orang',
                                    imageUrl: ruangan['image_url'] ?? '',
                                    facilities: ruangan['fasilitas'] ?? '-',
                                  ),
                                ),
                              );
                            },
                            child: _buildRoomCard(
                              ruangan['nama_ruangan'] ?? 'Tanpa Nama',
                              'Kapasitas ${ruangan['kapasitas']} Orang',
                              ruangan['fasilitas'] ?? '-',
                              ruangan['image_url'] ?? '',
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 24),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildMiniHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [Icon(Icons.meeting_room, color: Color(0xFF247A75)), SizedBox(width: 8), Text('PinjamRuang', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF247A75)))]),
        Icon(Icons.notifications_none, color: Colors.black),
      ],
    );
  }

  // Parameter disesuaikan agar tidak perlu memanggil variabel 'ruangan' dari luar
  Widget _buildRoomCard(String title, String capacity, String facilities, String imgUrl) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imgUrl, height: 160, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(height: 160, color: Colors.grey[300], child: const Icon(Icons.broken_image))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(capacity, style: const TextStyle(fontSize: 14, color: Color(0xFF247A75), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(facilities, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF247A75),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() => _currentIndex = index);
        if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BookingSayaPage()));
        else if (index == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JadwalPage()));
        else if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilPage()));
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