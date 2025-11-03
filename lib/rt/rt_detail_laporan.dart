// proses yh dik
import 'package:flutter/material.dart';

class RTDetailLaporanPage extends StatelessWidget {
  final Map<String, dynamic> laporan;

  const RTDetailLaporanPage({super.key, required this.laporan});

  void _showPopupSelesai(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Laporan Diselesaikan",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff5f34e0)),
        ),
        content: const Text(
          "Terima kasih! Laporan warga telah dikonfirmasi sebagai selesai.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tutup", style: TextStyle(color: Color(0xff5f34e0))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
        backgroundColor: const Color(0xff5f34e0),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Judul:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(laporan['judul'] ?? '-'),
            const SizedBox(height: 8),
            Text("Tanggal:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(laporan['tanggal'] ?? '-'),
            const SizedBox(height: 8),
            Text("Deskripsi:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(laporan['deskripsi'] ?? '-'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showPopupSelesai(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff5f34e0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Selesaikan / Konfirmasi",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
