import 'package:flutter/material.dart';
import '../flutterViz_bottom_navigationBar_model.dart';

class Approvement extends StatefulWidget {
  const Approvement({super.key});

  @override
  State<Approvement> createState() => _ApprovementPageState();
}

class _ApprovementPageState extends State<Approvement> {
  String selectedTab = 'Dalam Proses';
  String? selectedValidation = 'Tidak';
  final TextEditingController reasonController = TextEditingController();

  final List<String> tabs = ["Semua", "Laporan", "Dalam Proses", "Selesai", "Dibatalkan"];

  int selectedIndex = 1; // posisi default

  final List<FlutterVizBottomNavigationBarModel> navItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.add, label: "Tambah"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f6ff),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Approvement",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none, color: Colors.black87),
          ),
        ],
      ),

      // 🔹 BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // 🔹 Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: tabs.map((tab) {
                  final bool isActive = selectedTab == tab;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTab = tab),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xff6f3dee) : const Color(0xffebe7ff),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: const Color(0xff6f3dee).withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ]
                              : [],
                        ),
                        child: Text(
                          tab,
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Card Laporan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        'assets/illustration2.png',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Jalan Lubang",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Didepan Pos Satpam",
                            style: TextStyle(color: Colors.black54, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: const [
                              Icon(Icons.access_time, color: Color(0xff6f3dee), size: 16),
                              SizedBox(width: 5),
                              Text(
                                "07:00 AM",
                                style: TextStyle(
                                  color: Color(0xff6f3dee),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),

                          const Text(
                            "Apakah pengajuan tervalidasi?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'Ya',
                                groupValue: selectedValidation,
                                activeColor: const Color(0xff6f3dee),
                                onChanged: (value) => setState(() => selectedValidation = value),
                              ),
                              const Text("Ya"),
                              Radio<String>(
                                value: 'Tidak',
                                groupValue: selectedValidation,
                                activeColor: const Color(0xff6f3dee),
                                onChanged: (value) => setState(() => selectedValidation = value),
                              ),
                              const Text("Tidak"),
                            ],
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            "Alasan harus dilakukan pengerjaan?",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: reasonController,
                            maxLines: 2,
                            decoration: InputDecoration(
                              hintText: "Tulis alasan di sini...",
                              hintStyle: const TextStyle(color: Colors.black38),
                              filled: true,
                              fillColor: const Color(0xfff7f4ff),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Color(0xffddd6fe), width: 1),
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // 🔹 Tombol Kirim
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Laporan berhasil dikirim!"),
                                    backgroundColor: Color(0xff6f3dee),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff6f3dee),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                elevation: 3,
                              ),
                              child: const Text(
                                "Kirim",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),

      // 🔹 NAVIGATION BAR — sama persis kayak di home.dart
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(navItems.length, (index) {
            final item = navItems[index];
            final bool isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                // tambahkan navigasi ke halaman lain kalau perlu
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected ? const Color(0xff6f3dee) : const Color(0xffb8a8f9),
                    size: 26,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? const Color(0xff6f3dee) : const Color(0xffb8a8f9),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
