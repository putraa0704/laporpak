import 'package:flutter/material.dart';
import 'package:flutter_application_1/history/HistoryAdmin.dart';
import 'package:flutter_application_1/akun/akun_admin.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
import '../admin/home_admin.dart';

class DateAdmin extends StatefulWidget {
  const DateAdmin({super.key});

  @override
  State<DateAdmin> createState() => _DateAdminState();
}

class _DateAdminState extends State<DateAdmin> {
  final List<FlutterVizBottomNavigationBarModel> flutterVizBottomNavigationBarItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  int _selectedIndex = 1;
  DateTime _selectedDate = DateTime.now();

  final List<Map<String, dynamic>> _reports = [
    {
      'title': 'Lampu Jalan Mati',
      'location': 'Didepan Blok A-2',
      'time': '18.00 PM',
      'status': 'In Progress',
      'statusColor': const Color(0xff8c6bed),
      'icon': Icons.shopping_bag_outlined,
      'iconColor': const Color(0xff5f34e0),
    },
    {
      'title': 'Jalan Lubang',
      'location': 'Didepan Pos Satpam',
      'time': '07:00 AM',
      'status': 'On Hold',
      'statusColor': const Color(0xfff7c3c3),
      'icon': Icons.access_time_outlined,
      'iconColor': Colors.red,
    },
    {
      'title': 'Lampu Pos Satpam Mati',
      'location': 'Disamping pos satpam',
      'time': '07:00 PM',
      'status': 'Selesai',
      'statusColor': const Color(0xffc3f7d1),
      'icon': Icons.check_circle_outline,
      'iconColor': Colors.green,
    },
  ];

  // 🧭 Navigasi antar halaman
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeAdmin()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DateAdmin()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Approvement()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileAdmin()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff5f34e0),
        title: const Text(
          "Lapor Pak",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        leading: const Icon(Icons.menu, color: Colors.white, size: 24),
        actions: const [
          Icon(Icons.notifications, color: Colors.white, size: 24),
        ],
      ),

      // 🔽 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        items: flutterVizBottomNavigationBarItems
            .map((e) => BottomNavigationBarItem(icon: Icon(e.icon), label: e.label))
            .toList(),
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
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

      // 🧾 Body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🗓️ Kalender Pengaduan
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today, color: Color(0xff5f34e0), size: 18),
                          SizedBox(width: 6),
                          Text(
                            "Kalender Pengaduan",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xff5f34e0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    CalendarDatePicker(
                      initialDate: _selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                      onDateChanged: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Tanggal Hari Ini: ${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff5f34e0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 🔘 Filter tombol
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  _buildFilterButton(label: "All", isSelected: true),
                  _buildFilterButton(label: "On Hold", isSelected: false),
                  _buildFilterButton(label: "In Progress", isSelected: false),
                  _buildFilterButton(label: "Done", isSelected: false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🧾 List laporan
            ..._reports.map((report) {
              return _buildReportCard(
                screenWidth,
                report['title'],
                report['location'],
                report['time'],
                report['status'],
                report['statusColor'],
                report['icon'],
                report['iconColor'],
              );
            }).toList(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // 🔹 Widget filter button
  Widget _buildFilterButton({required String label, required bool isSelected}) {
    const Color purple = Color(0xff5f34e0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: MaterialButton(
        onPressed: () {},
        color: isSelected ? purple : purple.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : purple,
          ),
        ),
      ),
    );
  }

  // 🔹 Widget card laporan
  Widget _buildReportCard(
    double screenWidth,
    String title,
    String location,
    String time,
    String status,
    Color statusColor,
    IconData icon,
    Color iconColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: iconColor),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xff5f34e0),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                      color: (status == 'On Hold' || status == 'Selesai')
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
