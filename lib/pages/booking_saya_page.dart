import 'package:flutter/material.dart';
import '../supabase_client.dart';
import 'home_page.dart';
import 'jadwal_page.dart';
import 'profil_page.dart';

class BookingSayaPage extends StatefulWidget {
  const BookingSayaPage({super.key});

  @override
  State<BookingSayaPage> createState() => _BookingSayaPageState();
}

class _BookingSayaPageState extends State<BookingSayaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _currentIndex = 1;

  // Query: Mengambil data tanpa .order('created_at') untuk menghindari error kolom hilang
  final _futureBookings = supabase
    .from('bookings')
    .select('*, ruangan(nama_ruangan)')
    .eq('user_id', supabase.auth.currentUser!.id); 
    // JANGAN tambahkan .order('created_at') di sini jika kolomnya belum ada!

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            child: FutureBuilder(
              future: _futureBookings,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFF247A75)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final bookings = snapshot.data as List<dynamic>;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Booking Saya', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                    TabBar(
                      controller: _tabController,
                      labelColor: const Color(0xFF247A75),
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: const Color(0xFF247A75),
                      tabs: const [
                        Tab(text: 'Aktif'),
                        Tab(text: 'Selesai'),
                        Tab(text: 'Dibatalkan'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildBookingList(bookings, 'Aktif'),
                          _buildBookingList(bookings, 'Selesai'),
                          _buildBookingList(bookings, 'Dibatalkan'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(context),
    );
  }

  Widget _buildBookingList(List<dynamic> data, String targetStatus) {
    // Logika penentuan status otomatis
    String getAutoStatus(item) {
        if (item['status'] == 'Dibatalkan') return 'Dibatalkan';

        // Debug: Lihat data apa yang sedang diproses di Terminal
        // debugPrint("Memproses booking: ${item['selected_date']}");

        try {
          // Pastikan format data di database adalah "YYYY-MM-DD"
          // Jika datamu formatnya lain, kita harus sesuaikan di sini
          DateTime tglBooking = DateTime.parse(item['selected_date']);
          DateTime hariIni = DateTime.now();

          // Membandingkan hanya bagian tahun, bulan, dan hari (tanpa jam)
          DateTime tglBookingBersih = DateTime(tglBooking.year, tglBooking.month, tglBooking.day);
          DateTime hariIniBersih = DateTime(hariIni.year, hariIni.month, hariIni.day);

          if (tglBookingBersih.isBefore(hariIniBersih)) {
            return 'Selesai';
          } else {
            return 'Aktif';
          }
        } catch (e) {
          debugPrint("Error parsing tanggal: $e");
          return 'Aktif'; // Fallback
        }
      }

    // Filter data sesuai tab
    final filteredData = data.where((item) => getAutoStatus(item) == targetStatus).toList();

    if (filteredData.isEmpty) {
      return Center(child: Text('Tidak ada booking $targetStatus'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final item = filteredData[index];
        final roomName = item['ruangan'] != null ? item['ruangan']['nama_ruangan'] : 'Ruangan';
        
        Color statusColor = targetStatus == 'Aktif' 
            ? const Color(0xFF247A75) 
            : (targetStatus == 'Selesai' ? Colors.blue : Colors.red);

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(targetStatus, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Text(roomName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${item['selected_day'] ?? ''}, ${item['selected_date'] ?? ''} | ${item['selected_time'] ?? ''}', 
                     style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF247A75),
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (index == 2) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const JadwalPage()));
        } else if (index == 3) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilPage()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Booking Saya'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month_outlined), label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profil'),
      ],
    );
  }
}