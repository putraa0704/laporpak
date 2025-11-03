// lib/config/api_config.dart
class ApiConfig {
  // 🔥 GANTI URL INI dengan URL Laravel Anda
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // 👇 Untuk testing di device fisik menggunakan IP lokal:
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  // 👇 Untuk testing di emulator Android:
  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  // Base URL untuk storage (foto)
  static const String storageUrl = 'http://127.0.0.1:8000';
  
  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';
  static const String logout = '$baseUrl/auth/logout';
  static const String me = '$baseUrl/auth/me';
  static const String updateProfile = '$baseUrl/auth/update-profile';
  
  // Report endpoints
  static const String reports = '$baseUrl/reports';
  static const String reportStatistics = '$baseUrl/reports/statistics';
  
  // Admin endpoints
  static const String adminReports = '$baseUrl/admin/reports';
  static const String adminStats = '$baseUrl/admin/reports/dashboard-stats';
  static const String adminNeedApproval = '$baseUrl/admin/reports/need-approval';
  static const String adminPetugas = '$baseUrl/admin/petugas';
  static const String adminWarga = '$baseUrl/admin/warga';
  
  // RT endpoints
  static const String rtReports = '$baseUrl/rt/reports';
  static const String rtStats = '$baseUrl/rt/reports/dashboard-stats';
  static const String rtApproval = '$baseUrl/rt/reports/approval';
}