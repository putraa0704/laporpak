// lib/Date/date.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
import '../services/report_service.dart';
import '../models/report_model.dart';
import '../Home/home.dart';
import '../Formulir/tambah.dart';
import '../History/history.dart';
import '../Akun/akun.dart';
import '../widgets/custom_calendar.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  final List<FlutterVizBottomNavigationBarModel>
  flutterVizBottomNavigationBarItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(
      icon: Icons.calendar_today,
      label: "Date",
    ),
    FlutterVizBottomNavigationBarModel(icon: Icons.add, label: "Tambah"),
    FlutterVizBottomNavigationBarModel(
      icon: Icons.description,
      label: "History",
    ),
    FlutterVizBottomNavigationBarModel(
      icon: Icons.account_circle,
      label: "Account",
    ),
  ];

  int _selectedIndex = 1;
  DateTime _selectedDate = DateTime.now();
  String selectedFilter = "all";
  bool isLoading = true;
  List<ReportModel> allReports = [];
  List<ReportModel> filteredReports = [];

  final List<String> filters = ["all", "pending", "in_progress", "done"];
  final Map<String, String> filterLabels = {
    "all": "Semua",
    "pending": "Menunggu",
    "in_progress": "Dalam Proses",
    "done": "Selesai",
  };

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => isLoading = true);

    final result = await ReportService.getReports(
      myReports: true, // hanya laporan user sendiri
    );

    if (result['success']) {
      final data = result['data'];
      final List<dynamic> reportList = data['data'];

      setState(() {
        allReports =
            reportList.map((json) => ReportModel.fromJson(json)).toList();
        _filterReports();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Gagal memuat laporan'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterReports() {
    setState(() {
      // Filter berdasarkan tanggal yang dipilih
      filteredReports =
          allReports.where((report) {
            final reportDate = DateFormat(
              'yyyy-MM-dd',
            ).parse(report.reportDate);
            final isSameDate =
                reportDate.year == _selectedDate.year &&
                reportDate.month == _selectedDate.month &&
                reportDate.day == _selectedDate.day;

            if (selectedFilter == "all") {
              return isSameDate;
            } else {
              return isSameDate && report.status == selectedFilter;
            }
          }).toList();
    });
  }

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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xff5f34e0);
      case 'in_progress':
        return Colors.orangeAccent;
      case 'done':
        return Colors.green;
      case 'on_hold':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
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
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/lapor_pak.png', // Pastikan file logo ada
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadReports,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:
            flutterVizBottomNavigationBarItems
                .map(
                  (e) => BottomNavigationBarItem(
                    icon: Icon(e.icon),
                    label: e.label,
                  ),
                )
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
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                          Icon(
                            Icons.calendar_today,
                            color: Color(0xff5f34e0),
                            size: 18,
                          ),
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

                    CustomCalendar(
                      selectedDate: _selectedDate,
                      onDateChanged: (date) {
                        final oldMonth = _selectedDate.month;
                        final oldYear = _selectedDate.year;

                        setState(() {
                          _selectedDate = date;
                        });

                        if (date.month != oldMonth || date.year != oldYear) {
                          _loadReports();
                        } else {
                          _filterReports();
                        }
                      },
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Tanggal Hari Ini: ${DateFormat('dd-MM-yyyy').format(_selectedDate)}",
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

            // Filter buttons
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children:
                    filters.map((filter) {
                      final isSelected = selectedFilter == filter;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              selectedFilter = filter;
                              _filterReports();
                            });
                          },
                          color:
                              isSelected
                                  ? const Color(0xff5f34e0)
                                  : const Color(0xff5f34e0).withOpacity(0.1),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          child: Text(
                            filterLabels[filter]!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color:
                                  isSelected
                                      ? Colors.white
                                      : const Color(0xff5f34e0),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // List laporan
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(color: Color(0xff5f34e0)),
              )
            else if (filteredReports.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_busy,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tidak ada laporan pada tanggal ini',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              )
            else
              ...filteredReports.map((report) {
                return _buildReportCard(report);
              }).toList(),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(ReportModel report) {
  final statusColor = _getStatusColor(report.status);

  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14.0),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      report.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report.locationDescription,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  report.isDone()
                      ? Icons.check_circle_outline
                      : Icons.access_time_outlined,
                  size: 16,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      report.reportTime,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Color(0xff5f34e0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  report.getStatusLabel(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: statusColor,
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