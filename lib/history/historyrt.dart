import 'package:flutter/material.dart';
import '../flutterViz_bottom_navigationBar_model.dart';

class HistoryRT extends StatefulWidget {  
  const HistoryRT({super.key});

  @override
  State<HistoryRT> createState() => _HistoryRTState();
}

class _HistoryRTState extends State<HistoryRT> {  
  String selectedTab = 'Dalam Proses';
  int selectedIndex = 1;

  final List<String> tabs = ["Semua", "Laporan", "Dalam Proses", "Selesai", "Dibatalkan"];
  final List<FlutterVizBottomNavigationBarModel> navItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  void _showPopupKonfirmasi(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Konfirmasi Validasi",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apakah Anda yakin ingin mengkonfirmasi laporan ini?",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Laporan telah dikonfirmasi!"),
                  backgroundColor: Color(0xff6f3dee),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6f3dee),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Ya, Konfirmasi"),
          ),
        ],
      ),
    );
  }

  void _showPopupSelesai(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Tandai Selesai",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Apakah laporan ini sudah benar-benar selesai?",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Laporan ditandai selesai!"),
                  backgroundColor: Color(0xff6f3dee),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6f3dee),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Ya, Selesai"),
          ),
        ],
      ),
    );
  }

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

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),

            // Filter Tabs
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

            // Card Laporan
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

                          // 🔹 Ganti bagian radio & textfield jadi 2 tombol
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () => _showPopupKonfirmasi(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff6f3dee),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    "Konfirmasi",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => _showPopupSelesai(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: const Text(
                                    "Selesaikan",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
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

      // NAVIGATION BAR
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
