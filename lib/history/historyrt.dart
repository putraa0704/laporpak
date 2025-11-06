import 'package:flutter/material.dart';
import '../flutterViz_bottom_navigationBar_model.dart';
import '../rt/rt_home.dart';
import '../Date/datert.dart';
import '../akun/akun_ketua.dart';
import '../services/admin_rt_service.dart';
import '../models/report_model.dart';

class HistoryRT extends StatefulWidget {  
  const HistoryRT({super.key});

  @override
  State<HistoryRT> createState() => _HistoryRTState();
}

class _HistoryRTState extends State<HistoryRT> {  
  String selectedTab = 'laporan';
  int selectedIndex = 2;
  bool isLoading = true;
  List<ReportModel> reports = [];

  final List<String> tabs = ["semua", "laporan", "dalam_proses", "selesai"];
  
  final Map<String, String> tabLabels = {
    "semua": "Semua",
    "laporan": "Laporan Baru",
    "dalam_proses": "Dalam Proses",
    "selesai": "Selesai",
  };

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

  Future<void> _loadReports() async {
    setState(() => isLoading = true);

    final result = await AdminRTService.getRTApprovalReports(
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

  void _showPopupKonfirmasi(BuildContext context, ReportModel report) {
    final TextEditingController notesController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi & Rekomendasikan',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Apakah Anda yakin ingin mengkonfirmasi laporan \"${report.title}\"?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Laporan akan direkomendasikan ke Admin untuk ditindaklanjuti",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Catatan (opsional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleConfirm(report, notesController.text);
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

  void _showPopupTolak(BuildContext context, ReportModel report) {
    final TextEditingController reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Tolak Laporan',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Apakah Anda yakin ingin menolak laporan \"${report.title}\"?",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Alasan penolakan (wajib)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alasan penolakan harus diisi'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              Navigator.pop(context);
              await _handleReject(report, reasonController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Ya, Tolak"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleConfirm(ReportModel report, String notes) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xff6f3dee)),
      ),
    );

    final result = await AdminRTService.confirmAndRecommend(
      id: report.id,
      notes: notes.isNotEmpty ? notes : null,
    );

    if (mounted) {
      Navigator.pop(context); // Close loading

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Laporan berhasil direkomendasikan ke Admin!"),
            backgroundColor: Color(0xff6f3dee),
          ),
        );
        _loadReports(); // Reload data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal konfirmasi laporan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleReject(ReportModel report, String reason) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
    );

    final result = await AdminRTService.rejectReport(
      id: report.id,
      reason: reason,
    );

    if (mounted) {
      Navigator.pop(context); // Close loading

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Laporan berhasil ditolak"),
            backgroundColor: Colors.red,
          ),
        );
        _loadReports(); // Reload data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Gagal menolak laporan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    if (index == selectedIndex) return;

    Widget? nextPage;
    switch (index) {
      case 0:
        nextPage = const HomeRt();
        break;
      case 1:
        nextPage = const DateRT();
        break;
      case 2:
        nextPage = const HistoryRT();
        break;
      case 3:
        nextPage = ProfilKetua();
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
          "Approvement - RT",
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
                                  // Foto laporan
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
                                                borderRadius:
                                                    BorderRadius.circular(10),
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

                                        // Action Buttons - HANYA untuk laporan baru (pending & belum direkomendasi)
                                        if (report.isPending() && selectedTab == 'laporan') ...[
                                          const SizedBox(height: 18),
                                          Row(
                                            children: [
                                              // Tombol Tolak
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      _showPopupTolak(context, report),
                                                  icon: const Icon(Icons.close, size: 18),
                                                  label: const Text("Tolak"),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(25),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              // Tombol Konfirmasi
                                              Expanded(
                                                child: ElevatedButton.icon(
                                                  onPressed: () =>
                                                      _showPopupKonfirmasi(
                                                          context, report),
                                                  icon: const Icon(Icons.check, size: 18),
                                                  label: const Text("Konfirmasi"),
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xff6f3dee),
                                                    foregroundColor: Colors.white,
                                                    padding: const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(25),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
              onTap: () => _onItemTapped(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item.icon,
                    color: isSelected
                        ? const Color(0xff6f3dee)
                        : const Color(0xffb8a8f9),
                    size: 26,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xff6f3dee)
                          : const Color(0xffb8a8f9),
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