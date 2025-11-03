import 'package:flutter/material.dart';
import '../flutterViz_bottom_navigationBar_model.dart';

// 🔹 Import halaman lain
import '../Home/home.dart';
import '../Date/date.dart';
import '../Formulir/tambah.dart';
import '../akun/akun.dart';

class HistoryLaporan extends StatefulWidget {
  const HistoryLaporan({super.key});

  @override
  State<HistoryLaporan> createState() => _HistoryLaporanPageState();
}

class _HistoryLaporanPageState extends State<HistoryLaporan> {
  int _selectedIndex = 3;
  String selectedFilter = "All";

  final List<Map<String, dynamic>> laporanList = [
    {
      "judul": "Jalan Lubang",
      "lokasi": "Didepan Pos Satpam",
      "jam": "07:00 AM",
      "status": "Dalam Proses",
      "image": "assets/jalan_lubang.png",
    },
    {
      "judul": "Lampu Mati",
      "lokasi": "Disamping Balai RT",
      "jam": "07:00 AM",
      "status": "Terkirim",
      "image": "assets/lampu_mati.png",
    },
    {
      "judul": "Jalan Lampu Mati",
      "lokasi": "Didepan Blok A-2",
      "jam": "07:00 AM",
      "status": "Selesai",
      "image": "assets/lampu_selesai.png",
    },
  ];

  final List<String> filters = ["All", "Terkirim", "Dalam Proses", "Selesai"];

  final List<FlutterVizBottomNavigationBarModel> navItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.add, label: "Tambah"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  // 🔹 Navigasi antar halaman (disamakan dengan semua halaman lain)
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

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
    final filteredList = selectedFilter == "All"
        ? laporanList
        : laporanList.where((item) => item["status"] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      // ========================== APP BAR ==========================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "History Laporan",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.notifications_none, color: Color(0xff5f34e0)),
          ),
        ],
      ),

      // ========================== BODY ==========================
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildFilterBar(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return _buildReportCard(item);
              },
            ),
          ),
        ],
      ),

      // ========================== ✅ BOTTOM NAVBAR (FINAL VERSION) ==========================
      bottomNavigationBar: BottomNavigationBar(
        items: navItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ),
            )
            .toList(),
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        elevation: 8,
        iconSize: 24,
        selectedItemColor: const Color(0xff5f33e2),
        unselectedItemColor: const Color(0xffb5a1f0),
        selectedFontSize: 10,
        unselectedFontSize: 9,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  // ========================== FILTER BAR ==========================
  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => selectedFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xff5f34e0) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? const Color(0xff5f34e0) : Colors.grey.shade300,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xff5f34e0).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ========================== KARTU LAPORAN ==========================
  Widget _buildReportCard(Map<String, dynamic> item) {
    Color statusColor;
    switch (item["status"]) {
      case "Terkirim":
        statusColor = const Color(0xff5f34e0);
        break;
      case "Dalam Proses":
        statusColor = Colors.orangeAccent;
        break;
      case "Selesai":
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              item["image"],
              width: double.infinity,
              height: 170,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["judul"],
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item["lokasi"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 13, color: Color(0xff5f34e0)),
                          const SizedBox(width: 4),
                          Text(
                            item["jam"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    item["status"],
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
