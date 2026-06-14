// lib/pages/review_page.dart
import 'package:flutter/material.dart';
import 'booking_saya_page.dart';

class ReviewPage extends StatefulWidget {
  final String roomName;
  final String selectedDay;
  final String selectedDate;
  final String selectedTime;

  const ReviewPage({
    super.key,
    required this.roomName,
    required this.selectedDay,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  // 1. Kunci global untuk memvalidasi Form
  final _formKey = GlobalKey<FormState>();

  // 2. Controller untuk mengambil teks (Opsional, berguna saat submit data)
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _acaraController = TextEditingController();

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
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          // 3. Bungkus seluruh konten dengan widget Form
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER (Tombol Back, Search, Favorite)
                _buildHeader(context),

                const SizedBox(height: 24),

                // 2. JUDUL UTAMA
                const Text(
                  'Review & Konfirmasi',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 28),

                // 3. SEKSI DETAIL RINGKASAN JADWAL
                _buildReviewSummary(),

                const SizedBox(height: 16),

                // INDIKATOR TITIK-TITIK SLIDER (Carousel Dots)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index == 0 ? 10 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: index == 0 ? Colors.black45 : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // 4. SEKSI DETAIL PEMBOOKING
                const Text(
                  'Detail Pembooking',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                _buildPembookingForm(),

                const SizedBox(height: 24),

                // 5. SEKSI TAMBAHAN (ACARA KEGIATAN)
                const Text(
                  'Tambahan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 3, 3),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTambahanForm(),

                const SizedBox(height: 40),

                // 6. TOMBOL SUBMIT (Lanjutkan Ke Pembayaran)
                _buildSubmitButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET SUB-KOMPONEN ---

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.search, color: Colors.black, size: 26),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: Colors.black,
                size: 26,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewSummary() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Table(
        columnWidths: const {0: FlexColumnWidth(1.1), 1: FlexColumnWidth(1.9)},
        children: [
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  'Ruangan',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  widget
                      .roomName, // Menggunakan widget. karena sudah jadi StatefulWidget
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          TableRow(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  'Tanggal & Waktu',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  '${widget.selectedDay}, ${widget.selectedDate} Juni,\n${widget.selectedTime} - 12.00',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPembookingForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54),
      ),
      child: Column(
        children: [
          // Ganti ke TextFormField + tambah Validator Nama
          TextFormField(
            controller: _namaController,
            decoration: const InputDecoration(
              hintText: 'Nama',
              hintStyle: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black54),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              errorStyle: TextStyle(
                height: 0.5,
              ), // Agar layout error tidak terlalu memakan tempat
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nama wajib diisi';
              }
              return null;
            },
          ),
          // Ganti ke TextFormField + tambah Validator Telephone
          TextFormField(
            controller: _telpController,
            decoration: const InputDecoration(
              hintText: 'Telephone',
              hintStyle: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: InputBorder.none,
              errorStyle: TextStyle(height: 0.5),
            ),
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Nomor telepon wajib diisi';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTambahanForm() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black54),
      ),
      child: TextFormField(
        controller: _acaraController,
        maxLines: null,
        decoration: const InputDecoration(
          hintText: 'Acara Kegiatan',
          hintStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.all(16),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Acara kegiatan wajib diisi';
          }
          return null;
        },
      ),
    );
  }

    Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF247A75),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
        ),
        onPressed: () {
          // Trigger validasi saat tombol ditekan
          if (_formKey.currentState!.validate()) {
            // Jika validasi sukses, kode di bawah ini akan dijalankan:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menuju ke Halaman booking...')),
            );

            // PERBAIKAN DI SINI: Menggunakan BookingSayaPage() dengan PascalCase
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BookingSayaPage(), 
              ),
            );
          }
        },
        child: const Text(
          'Booking',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
