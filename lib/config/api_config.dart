class ApiConfig {
  static const String baseUrl = 'https://coltishly-momentous-gabrielle.ngrok-free.dev/api';
  // 👆 TAMBAHKAN /api di akhir!
  
  // Untuk testing di device: 
  // static const String baseUrl = 'http://192.168.1.100:8000/api';
  
  static const String register = '$baseUrl/register';
  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';
  static const String me = '$baseUrl/me';
  static const String laporans = '$baseUrl/laporans';
  static const String users = '$baseUrl/users';
  static const String notifications = '$baseUrl/notifications';
}