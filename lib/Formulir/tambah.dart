// lib/Formulir/tambah.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
import '../services/report_service.dart';
import 'package:flutter_application_1/Home/home.dart';
import 'package:flutter_application_1/Date/date.dart';
import 'package:flutter_application_1/history/history.dart';
import 'package:flutter_application_1/akun/akun.dart';

class UploadKeluhan extends StatefulWidget {
  const UploadKeluhan({super.key});

  @override
  State<UploadKeluhan> createState() => _UploadKeluhanPageState();
}

class _UploadKeluhanPageState extends State<UploadKeluhan> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  XFile? _imageFile;
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();
  int selectedIndex = 2;

  final List<FlutterVizBottomNavigationBarModel> navItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.add, label: "Tambah"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imageFile = pickedFile);
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() => selectedTime = picked);
    }
  }

  Future<void> _submitReport() async {
    // Validasi
    if (_judulController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul laporan harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deskripsi keluhan harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_lokasiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lokasi harus diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal laporan harus dipilih'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Waktu laporan harus dipilih'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Format tanggal dan waktu
      final dateFormat = DateFormat('yyyy-MM-dd');
      final timeFormat = '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}';

      File? photoFile;
      if (_imageFile != null && !kIsWeb) {
        photoFile = File(_imageFile!.path);
      }

      final result = await ReportService.createReport(
        title: _judulController.text,
        complaintDescription: _deskripsiController.text,
        locationDescription: _lokasiController.text,
        reportDate: dateFormat.format(selectedDate!),
        reportTime: timeFormat,
        photo: photoFile,
      );

      setState(() => isLoading = false);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Laporan berhasil dibuat!'),
            backgroundColor: Colors.green,
          ),
        );

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HistoryLaporan()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal membuat laporan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onNavItemTapped(int index) {
    if (index == selectedIndex) return;

    Widget? nextPage;
    switch (index) {
      case 0:
        nextPage = const HomeWarga();
        break;
      case 1:
        nextPage = const DatePage();
        break;
      case 2:
        nextPage = const UploadKeluhan();
        break;
      case 3:
        nextPage = const HistoryLaporan();
        break;
      case 4:
        nextPage = Profile();
        break;
    }

    if (nextPage != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Upload Keluhan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Judul Laporan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Judul Laporan",
                  hintText: "Contoh: Jalan Berlubang",
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Upload Foto
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.cloud_upload_outlined,
                            color: Color(0xff5f34e0), size: 24),
                        SizedBox(width: 12),
                        Text(
                          "Upload foto",
                          style: TextStyle(
                            color: Color(0xff5f34e0),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: kIsWeb
                            ? Image.network(
                                _imageFile!.path,
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(_imageFile!.path),
                                width: double.infinity,
                                height: 220,
                                fit: BoxFit.cover,
                              ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Tanggal dan Waktu
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tanggal",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedDate == null
                                ? "Pilih tanggal"
                                : DateFormat('dd/MM/yyyy').format(selectedDate!),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickTime(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Waktu",
                            style: TextStyle(fontSize: 12, color: Colors.black54),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedTime == null
                                ? "Pilih waktu"
                                : selectedTime!.format(context),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Deskripsi Keluhan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Deskripsi Keluhan",
                  hintText: "Jelaskan keluhan Anda...",
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Deskripsi Lokasi
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _lokasiController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: "Deskripsi Lokasi",
                  hintText: "Contoh: Didepan Pos Satpam Blok A",
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Submit
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5f34e0),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Tambah Keluhan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems
            .map((e) => BottomNavigationBarItem(
                  icon: Icon(e.icon),
                  label: e.label,
                ))
            .toList(),
        backgroundColor: Colors.white,
        currentIndex: selectedIndex,
        elevation: 8,
        iconSize: 24,
        selectedItemColor: const Color(0xff5f33e2),
        unselectedItemColor: const Color(0xffb5a1f0),
        selectedFontSize: 10,
        unselectedFontSize: 9,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onNavItemTapped,
      ),
    );
  }
}