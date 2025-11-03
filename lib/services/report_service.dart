// lib/services/report_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ReportService {
  // Create Report
  static Future<Map<String, dynamic>> createReport({
    required String title,
    required String complaintDescription,
    required String locationDescription,
    required String reportDate,
    required String reportTime,
    File? photo,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/reports'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['title'] = title;
      request.fields['complaint_description'] = complaintDescription;
      request.fields['location_description'] = locationDescription;
      request.fields['report_date'] = reportDate;
      request.fields['report_time'] = reportTime;

      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photo.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['success']) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal membuat laporan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get Reports
  static Future<Map<String, dynamic>> getReports({
    String? status,
    bool myReports = false,
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
      if (status != null) queryParams['status'] = status;
      if (myReports) queryParams['my_reports'] = '1';
      if (page != null) queryParams['page'] = page.toString();
      if (perPage != null) queryParams['per_page'] = perPage.toString();

      final uri = Uri.parse('${ApiConfig.baseUrl}/reports')
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

  // Get Single Report
  static Future<Map<String, dynamic>> getReport(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/reports/$id'),
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

  // Update Report
  static Future<Map<String, dynamic>> updateReport({
    required int id,
    String? title,
    String? complaintDescription,
    String? locationDescription,
    String? reportDate,
    String? reportTime,
    File? photo,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/reports/$id?_method=PUT'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      if (title != null) request.fields['title'] = title;
      if (complaintDescription != null) {
        request.fields['complaint_description'] = complaintDescription;
      }
      if (locationDescription != null) {
        request.fields['location_description'] = locationDescription;
      }
      if (reportDate != null) request.fields['report_date'] = reportDate;
      if (reportTime != null) request.fields['report_time'] = reportTime;

      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photo.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'data': data['data'], 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal update laporan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Delete Report
  static Future<Map<String, dynamic>> deleteReport(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/reports/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success']) {
        return {'success': true, 'message': data['message']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Gagal menghapus laporan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // Get Statistics
  static Future<Map<String, dynamic>> getStatistics({bool myStats = false}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        return {'success': false, 'message': 'Token tidak ditemukan'};
      }

      Map<String, String> queryParams = {};
      if (myStats) queryParams['my_stats'] = '1';

      final uri = Uri.parse('${ApiConfig.baseUrl}/reports/statistics')
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
        return {'success': false, 'message': data['message'] ?? 'Gagal mengambil statistik'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }
}