import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
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
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  DateTime? selectedDate;
  XFile? _imageFile;

  final ImagePicker _picker = ImagePicker();
  int selectedIndex = 2; // posisi default: Tambah

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

  // Navigasi antar halaman
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
    final screenWidth = MediaQuery.of(context).size.width;

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

            GestureDetector(
              onTap: () => _pickDate(context),
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
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: Color(0xff5f34e0), size: 22),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "Tanggal - Bulan - Tahun"
                            : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_rounded,
                        color: Colors.black45),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

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
                  hintText: "Isi Deskripsi Keluhan...",
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 18),

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
                  hintText: "Isi Lokasi...",
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 13),
                ),
              ),
            ),

            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
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
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('assets/illustration2.png'),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Pak Udin",
                    style: TextStyle(
                      color: const Color(0xff5f34e0),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth < 400 ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Tombol Tambah Keluhan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Keluhan berhasil ditambahkan!")),
                  );
                  Future.delayed(const Duration(milliseconds: 800), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HistoryLaporan()),
                    );
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5f34e0),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                child: const Text(
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

      // =====================================================
      // ✅ Bottom Navigation (sama persis seperti DatePage)
      // =====================================================
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
