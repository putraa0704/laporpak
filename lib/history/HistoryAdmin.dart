import 'package:flutter/material.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
import 'package:flutter_application_1/akun/akun_admin.dart';
import 'package:flutter_application_1/admin/home_admin.dart';
import 'package:flutter_application_1/Date/dateadmin.dart';
import '../services/admin_rt_service.dart';
import '../models/report_model.dart';

class Approvement extends StatefulWidget {
  const Approvement({super.key});

  @override
  State<Approvement> createState() => _ApprovementPageState();
}

class _ApprovementPageState extends State<Approvement> {
  String selectedTab = 'laporan';
  bool isLoading = true;
  List<ReportModel> reports = [];
  
  final TextEditingController reasonController = TextEditingController();

  final List<String> tabs = [
    "semua",
    "laporan",
    "dalam_proses",
    "selesai",
  ];

  final Map<String, String> tabLabels = {
    "semua": "Semua",
    "laporan": "Laporan",
    "dalam_proses": "Dalam Proses",
    "selesai": "Selesai",
  };

  int selectedIndex = 2;

  final List<FlutterVizBottomNavigationBarModel> navItems = [
    FlutterVizBottomNavigationBarModel(icon: Icons.home, label: "Home"),
    FlutterVizBottomNavigationBarModel(icon: Icons.calendar_today, label: "Date"),
    FlutterVizBottomNavigationBarModel(icon: Icons.description, label: "History"),
    FlutterVizBottomNavigationBarModel(icon: Icons.account_circle, label: "Account"),
  ];

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void dispose() {
    reasonController.dispose();
    super.dispose();
  }

  Future<void> _loadReports() async {
    setState(() => isLoading = true);

    final result = await AdminRTService.getNeedApproval(
      tab: selectedTab,
    );

    if (result['success']) {
      final data = result['data'];
      final List<dynamic> reportList = data['data'];
      
      setState(() {
        reports = reportList.map((json) => ReportModel.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal memuat laporan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleApprove(ReportModel report, bool approved) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xff6f3dee)),
      ),
    );

    final result = await AdminRTService.approveReport(
      id: report.id,
      approved: approved,
      reason: approved ? null : reasonController.text,
    );

    if (mounted) {
      Navigator.pop(context); // Close loading dialog

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Berhasil memproses laporan'),
            backgroundColor: const Color(0xff6f3dee),
          ),
        );
        reasonController.clear();
        _loadReports(); // Reload data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal memproses laporan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showApprovalDialog(ReportModel report) {
    String? selectedValidation;
    
    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            "Validasi Laporan",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Judul: ${report.title}"),
                const SizedBox(height: 8),
                Text("Lokasi: ${report.locationDescription}"),
                const SizedBox(height: 16),
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
                      onChanged: (value) {
                        setDialogState(() => selectedValidation = value);
                      },
                    ),
                    const Text("Ya"),
                    Radio<String>(
                      value: 'Tidak',
                      groupValue: selectedValidation,
                      activeColor: const Color(0xff6f3dee),
                      onChanged: (value) {
                        setDialogState(() => selectedValidation = value);
                      },
                    ),
                    const Text("Tidak"),
                  ],
                ),
                if (selectedValidation == 'Tidak') ...[
                  const SizedBox(height: 10),
                  const Text(
                    "Alasan penolakan:",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: reasonController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Tulis alasan di sini...",
                      hintStyle: const TextStyle(color: Colors.black38),
                      filled: true,
                      fillColor: const Color(0xfff7f4ff),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xffddd6fe),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                reasonController.clear();
                Navigator.pop(dialogContext);
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: selectedValidation == null
                  ? null
                  : () {
                      Navigator.pop(dialogContext);
                      _handleApprove(
                        report,
                        selectedValidation == 'Ya',
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff6f3dee),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Kirim"),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeAdmin()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DateAdmin()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Approvement()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileAdmin()),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return const Color(0xff6f3dee);
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: _loadReports,
          ),
        ],
      ),

      body: Column(
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
                    onTap: () {
                      setState(() => selectedTab = tab);
                      _loadReports();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xff6f3dee)
                            : const Color(0xffebe7ff),
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
                        tabLabels[tab]!,
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

          // List Laporan
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xff6f3dee)),
                  )
                : reports.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 80,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Tidak ada laporan',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadReports,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: reports.length,
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            final statusColor = _getStatusColor(report.status);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
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
                                  if (report.hasPhoto())
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        report.getPhotoUrl('http://127.0.0.1:8000'),
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 200,
                                            color: Colors.grey.shade200,
                                            child: const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                report.title,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
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
                                        const SizedBox(height: 4),
                                        Text(
                                          report.locationDescription,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Dilaporkan oleh: ${report.getReporterName()}',
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              color: Color(0xff6f3dee),
                                              size: 16,
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              report.reportTime,
                                              style: const TextStyle(
                                                color: Color(0xff6f3dee),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (report.isPending()) ...[
                                          const SizedBox(height: 18),
                                          Center(
                                            child: ElevatedButton(
                                              onPressed: () =>
                                                  _showApprovalDialog(report),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xff6f3dee),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 50,
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                elevation: 3,
                                              ),
                                              child: const Text(
                                                "Proses Laporan",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),

          const SizedBox(height: 20),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: navItems
            .map((item) => BottomNavigationBarItem(
                  icon: Icon(item.icon),
                  label: item.label,
                ))
            .toList(),
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        elevation: 8,
        iconSize: 26,
        selectedItemColor: const Color(0xff5f33e2),
        unselectedItemColor: const Color(0xffb5a1f0),
        selectedFontSize: 11,
        unselectedFontSize: 10,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}