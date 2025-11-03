// lib/services/admin_rt_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class AdminRTService {
  // ========================================
  // ADMIN FUNCTIONS
  // ========================================
  
  // Get dashboard stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/admin/reports/dashboard-stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil statistik'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get reports that need approval
  static Future<Map<String, dynamic>> getNeedApproval({
    String? tab,
    int? page,
    int? perPage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      Map<String, String> queryParams = {};
      if (tab != null) queryParams['tab'] = tab;
      if (page != null) queryParams['page'] = page.toString();
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final uri = Uri.parse('${ApiConfig.baseUrl}/admin/reports/need-approval')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Approve or reject report
  static Future<Map<String, dynamic>> approveReport({
    required int id,
    required bool approved,
    String? reason,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/admin/reports/$id/approve'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'approved': approved,
          'reason': reason,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal approve laporan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Assign report to petugas
  static Future<Map<String, dynamic>> assignToPetugas({
    required int reportId,
    required int petugasId,
    String? notes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/admin/reports/$reportId/assign'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'petugas_id': petugasId,
          'notes': notes,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal assign petugas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get available petugas
  static Future<Map<String, dynamic>> getAvailablePetugas() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/admin/petugas/available'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil data petugas'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ========================================
  // RT FUNCTIONS
  // ========================================

  // Get RT dashboard stats
  static Future<Map<String, dynamic>> getRTDashboardStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/rt/reports/dashboard-stats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil statistik'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get RT approval reports
  static Future<Map<String, dynamic>> getRTApprovalReports({
    String? tab,
    int? page,
    int? perPage,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      Map<String, String> queryParams = {};
      if (tab != null) queryParams['tab'] = tab;
      if (page != null) queryParams['page'] = page.toString();
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final uri = Uri.parse('${ApiConfig.baseUrl}/rt/reports/approval')
          .replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // RT Confirm Report (pending -> in_progress)
  static Future<Map<String, dynamic>> confirmReport(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/rt/reports/$id/confirm'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal konfirmasi laporan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // RT Complete Report (any status -> done)
  static Future<Map<String, dynamic>> completeReport({
    required int id,
    String? notes,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/rt/reports/$id/complete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'notes': notes,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menyelesaikan laporan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get reports by date (for calendar)
  static Future<Map<String, dynamic>> getReportsByDate({
    required int month,
    required int year,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final uri = Uri.parse('${ApiConfig.baseUrl}/rt/reports/by-date').replace(
        queryParameters: {
          'month': month.toString(),
          'year': year.toString(),
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil data'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}