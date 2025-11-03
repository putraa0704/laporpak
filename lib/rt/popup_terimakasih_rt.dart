// proses yh dik
import 'package:flutter/material.dart';

class PopupTerimaKasihRT extends StatelessWidget {
  final String mode; // 'konfirmasi' atau 'selesaikan'
  const PopupTerimaKasihRT({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    final pesan = mode == 'selesaikan'
        ? 'Terima kasih karena telah menyelesaikan laporan warga!'
        : 'Terima kasih karena telah memproses laporan warga!';

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Terima Kasih!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                pesan,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 15),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A4CFF),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // tutup popup
                    Navigator.of(context).pop(); // balik ke halaman sebelumnya
                  },
                  child: const Text(
                    'Selesai',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Kembali',
                  style: TextStyle(color: Color(0xFF6A4CFF), fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
