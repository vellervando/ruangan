import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '../supabase_client.dart';
import 'home_page.dart';
import 'booking_saya_page.dart';
import 'profil_page.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  final int _currentIndex = 2;
  DateTime _selectedDate = DateTime.now();
  List<dynamic> _jadwalList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJadwal();
  }

  Future<void> _fetchJadwal() async {
    setState(() => _isLoading = true);
    try {
      // Format tanggal harus sama dengan data di kolom 'day_date' (text)
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      
      final data = await supabase
          .from('jadwal_penggunaan')
          .select('*')
          .eq('day_date', dateStr) 
          .order('time_slot');
      
      setState(() {
        _jadwalList = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error fetching jadwal: $e");
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: const Color(0xFFE8F1F0)),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Jadwal Penggunaan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
                
                // Kalender Horizontal
                SizedBox(
                  height: 85,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 30, 
                    itemBuilder: (context, index) {
                      DateTime date = DateTime.now().add(Duration(days: index));
                      bool isSelected = DateFormat('yyyy-MM-dd').format(_selectedDate) == 
                                        DateFormat('yyyy-MM-dd').format(date);
                      
                      return GestureDetector(
                        onTap: () {
                          setState(() { _selectedDate = date; });
                          _fetchJadwal();
                        },
                        child: Container(
                          width: 58,
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF247A75) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(DateFormat('EEE').format(date), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
                              Text(DateFormat('d').format(date), style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // List Jadwal
                Expanded(
                  child: _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : _jadwalList.isEmpty 
                      ? const Center(child: Text("Tidak ada jadwal untuk tanggal ini"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(20),
                          itemCount: _jadwalList.length,
                          itemBuilder: (context, index) {
                            final item = _jadwalList[index];
                            return _buildJadwalRow(
                              item['time_slot']?.toString() ?? '-',
                              item['room_name']?.toString() ?? '-',
                              item['agenda']?.toString() ?? '-'
                            );
                          },
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

  Widget _buildJadwalRow(String time, String room, String agenda) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(width: 95, child: Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF247A75)))),
          Container(width: 2, height: 45, color: Colors.black12),
          const SizedBox(width: 16),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text(agenda, style: const TextStyle(color: Colors.grey, fontSize: 13)),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF247A75),
      currentIndex: _currentIndex,
      onTap: (index) {
        if (index == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
        else if (index == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BookingSayaPage()));
        else if (index == 3) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilPage()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Bookingan\nSaya'),
        BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Jadwal'),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: 'Profil'),
      ],
    );
  }
}