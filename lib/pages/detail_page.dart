// lib/pages/detail_page.dart
import 'package:flutter/material.dart';
import 'review_page.dart'; // Pastikan file review_page.dart sudah diimport

class DetailPage extends StatefulWidget {
  final String roomName;
  final String capacity;
  final String imageUrl;
  final String facilities;

  const DetailPage({
    super.key,
    required this.roomName,
    required this.capacity,
    required this.imageUrl,
    required this.facilities,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int selectedDayIndex = 0; 
  String selectedTime = "08.00"; 

  // Data kalender horizontal mini (Sen - Ming)
  final List<Map<String, String>> days = [
    {'day': 'Senin', 'date': '20'},
    {'day': 'Selasa', 'date': '21'},
    {'day': 'Rabu', 'date': '22'},
    {'day': 'Kamis', 'date': '23'},
    {'day': 'Jumat', 'date': '24'},
    {'day': 'Sabtu', 'date': '25'},
    {'day': 'Minggu', 'date': '26'},
  ];

  // Data pilihan jam slot waktu
  final List<String> times = ['08.00', '09.00', '10.00', '11.00', '12.00', '13.00'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFFE8F1F0),
          ),
          SafeArea(
            top: false, 
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildImageBanner(context),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.roomName,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(height: 12),

                        const Text('Detail Ruangan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        
                        _buildDetailRow('Kapasitas', ': ${widget.capacity}'),
                        _buildDetailRow('Fasilitas', ': ${widget.facilities}'),
                        
                        const SizedBox(height: 20),
                        _buildHorizontalCalendar(),
                        const SizedBox(height: 24),
                        _buildTimeGrid(),
                        const SizedBox(height: 30),
                        
                        // Pemanggilan fungsi tombol yang sudah diperbarui
                        _buildActionButton(),
                      ],
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

  // --- WIDGET SUB-KOMPONEN ---

  Widget _buildImageBanner(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imageUrl,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Container(
          height: 250,
          color: Colors.black.withOpacity(0.1),
        ),
        Positioned(
          top: 45,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: index == 0 ? 12 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: index == 0 ? Colors.white : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalCalendar() {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black38)),
      child: Table(
        border: const TableBorder(
          horizontalInside: BorderSide(color: Colors.black38),
          verticalInside: BorderSide(color: Colors.black38),
        ),
        children: [
          TableRow(
            children: days.map((d) {
              // Mengambil substring singkatan (Sen, Sel, Rab...) untuk tampilan header tabel
              String shortDay = d['day']!.substring(0, 3);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(shortDay, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              );
            }).toList(),
          ),
          TableRow(
            children: List.generate(days.length, (index) {
              bool isSelected = selectedDayIndex == index;
              return GestureDetector(
                onTap: () => setState(() => selectedDayIndex = index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  color: isSelected ? const Color(0xFFC8E6C9) : Colors.transparent,
                  child: Text(
                    days[index]['date']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 14,
        childAspectRatio: 2.3,
      ),
      itemCount: times.length,
      itemBuilder: (context, index) {
        bool isTimeSelected = selectedTime == times[index];
        return GestureDetector(
          onTap: () => setState(() => selectedTime = times[index]),
          child: Container(
            decoration: BoxDecoration(
              color: isTimeSelected ? const Color(0xFF80CBC4) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black87),
            ),
            child: Center(
              child: Text(times[index], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
          ),
        );
      },
    );
  }

  // --- KODINGAN FULL JALUR NAVIGATION KE REVIEW PAGE ---
  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF247A75),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
        ),
        onPressed: () {
          // Mengambil data dinamis hari dan tanggal yang sedang aktif diklik user
          String currentDay = days[selectedDayIndex]['day']!;
          String currentDate = days[selectedDayIndex]['date']!;

          // Berpindah halaman ke ReviewPage membawa data pilihan secara realtime
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(
                roomName: widget.roomName,
                selectedDay: currentDay,
                selectedDate: currentDate,
                selectedTime: selectedTime,
              ),
            ),
          );
        },
        child: const Text(
          'Pilih Jadwal',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}