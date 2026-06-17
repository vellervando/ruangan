import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Tambahkan package intl di pubspec.yaml
import 'review_page.dart'; 

class DetailPage extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String capacity;
  final String imageUrl;
  final String facilities;

  const DetailPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.capacity,
    required this.imageUrl,
    required this.facilities,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  // Membuat list 30 hari (15 hari lalu s.d 15 hari ke depan)
  final List<DateTime> _days = List.generate(30, (index) => DateTime.now().subtract(const Duration(days: 15)).add(Duration(days: index)));
  
  int selectedDayIndex = 15; // Default ke hari ini (index ke-15)
  String selectedTime = "08.00"; 
  final List<String> times = ['08.00', '09.00', '10.00', '11.00', '12.00', '13.00'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.roomName, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(widget.imageUrl, height: 200, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
            Text(widget.roomName, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(widget.capacity, style: const TextStyle(fontSize: 16, color: Color(0xFF247A75), fontWeight: FontWeight.w600)),
            const SizedBox(height: 14),
            Text(widget.facilities, style: const TextStyle(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 24),
            const Text('Pilih Tanggal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildCalendarHorizontal(),
            const SizedBox(height: 24),
            const Text('Pilih Waktu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTimeSlots(),
            const SizedBox(height: 32),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarHorizontal() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _days.length,
        itemBuilder: (context, index) {
          final date = _days[index];
          bool isSelected = selectedDayIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedDayIndex = index),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF247A75) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(DateFormat('EEE').format(date), style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.w600)),
                  Text(date.day.toString(), style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.5),
      itemCount: times.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedTime == times[index];
        return GestureDetector(
          onTap: () => setState(() => selectedTime = times[index]),
          child: Container(
            decoration: BoxDecoration(color: isSelected ? const Color(0xFF247A75) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? Colors.transparent : Colors.grey.shade300)),
            child: Center(child: Text(times[index], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black))),
          ),
        );
      },
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF247A75), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        onPressed: () {
          final selectedDate = _days[selectedDayIndex];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReviewPage(
                roomId: widget.roomId,
                roomName: widget.roomName,
                // Kirim data lengkap
                selectedDay: DateFormat('EEEE').format(selectedDate),
                selectedDate: DateFormat('yyyy-MM-dd').format(selectedDate), 
                selectedTime: selectedTime,
              ),
            ),
          );
        },
        child: const Text('Pilih Jadwal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}