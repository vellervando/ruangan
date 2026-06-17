import 'package:flutter/material.dart';
import '../supabase_client.dart'; 
import 'booking_saya_page.dart';

class ReviewPage extends StatefulWidget {
  final String roomId; 
  final String roomName;
  final String selectedDay;
  final String selectedDate; // Pastikan format YYYY-MM-DD
  final String selectedTime;

  const ReviewPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.selectedDay,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _acaraController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception("Sesi user tidak ditemukan. Silakan login kembali.");

      // 1. Data untuk tabel bookings
      final bookingData = {
        'user_id': user.id,
        'room_id': widget.roomId,
        'selected_day': widget.selectedDay,
        'selected_date': widget.selectedDate,
        'selected_time': widget.selectedTime,
        'purpose': _acaraController.text,
        'nama_pemesan': _namaController.text,
        'telp_pemesan': _telpController.text,
        'status': 'Menunggu Konfirmasi',
      };

      // 2. Data untuk tabel jadwal_penggunaan (Agar muncul di halaman Jadwal)
      final jadwalData = {
        'room_name': widget.roomName,
        'agenda': _acaraController.text,
        'time_slot': widget.selectedTime,
        'day_date': widget.selectedDate, 
      };

      // Melakukan dua insert ke database
      await supabase.from('bookings').insert(bookingData);
      await supabase.from('jadwal_penggunaan').insert(jadwalData);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking berhasil dibuat!'), backgroundColor: Colors.green),
      );
      
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BookingSayaPage()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal booking: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _telpController.dispose();
    _acaraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F1F0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Navigator.pop(context)),
                const Text('Review & Konfirmasi', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                
                // Ringkasan Booking
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ruangan: ${widget.roomName}', style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      Text('Waktu: ${widget.selectedDay}, ${widget.selectedDate} | ${widget.selectedTime}', 
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Form Input
                const Text('Detail Pembooking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(controller: _namaController, decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: 10),
                TextFormField(controller: _telpController, decoration: const InputDecoration(labelText: 'No. Telepon', border: OutlineInputBorder()), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: 20),
                const Text('Tambahan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                TextFormField(controller: _acaraController, maxLines: 3, decoration: const InputDecoration(hintText: 'Acara Kegiatan', border: OutlineInputBorder()), validator: (v) => v!.isEmpty ? 'Wajib diisi' : null),
                const SizedBox(height: 40),
                
                // Tombol Submit
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF247A75)),
                    onPressed: _isLoading ? null : _submitBooking,
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Konfirmasi Booking', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}