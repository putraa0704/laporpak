import 'package:flutter/material.dart';
import 'package:flutter_application_1/akun/akun_ketua.dart';
import 'SplashScreen/SplashScreen.dart';
import 'Login/login.dart';
import 'Signup/signup.dart';
import 'Home/home.dart';
import 'rt/rt_home.dart';
import 'package:flutter_application_1/Date/date.dart';
import 'Formulir/tambah.dart';
import 'history/HistoryAdmin.dart';
import 'history/history.dart';
import 'akun/akun.dart';
import 'history/historyrt.dart';
import 'admin/home_admin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lapor Pak',
      theme: ThemeData(primarySwatch: Colors.deepPurple, useMaterial3: true),

      // Halaman pertama yang muncul saat app dijalankan
      home: const SplashScreen(),

      // Rute navigasi utama
      routes: {
        '/login': (context) => const Login(),
        '/signup': (context) => const SignUp(),
        '/home': (context) => const HomeWarga(), // warga
        '/rt_home': (context) => HomeRt(), // RT
        '/home_admin': (context) => HomeAdmin(), // admin
        '/historyrt': (context) => const HistoryRT(),
        '/tambah': (context) => const UploadKeluhan(), // warga
        '/date': (context) => const DatePage(), // warga ✅ (hanya sekali)
        '/history': (context) => const HistoryLaporan(), // warga
        '/HistorAdmin': (context) => const Approvement(), // admin
        '/akun': (context) => Profile(), // warga
        '/akun_ketua': (context) => ProfilKetua(), // RT
      },
    );
  }
}

// 🟣 Tambahan AMAN TANPA UBAH APA PUN DI ATAS
// Fungsi navigasi global agar bisa dipanggil dari semua halaman
void navigateToPage(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushReplacementNamed(context, '/home');
      break;
    case 1:
      Navigator.pushReplacementNamed(context, '/date');
      break;
    case 2:
      Navigator.pushReplacementNamed(context, '/tambah');
      break;
    case 3:
      Navigator.pushReplacementNamed(context, '/history');
      break;
    case 4:
      Navigator.pushReplacementNamed(context, '/admin');
      break;
    case 5:
      Navigator.pushReplacementNamed(context, '/rt');
      break;
    default:
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Menu belum diaktifkan")));
  }
}
