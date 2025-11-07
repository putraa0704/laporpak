// lib/models/report_model.dart
class ReportModel {
  final int id;
  final int userId;
  final String title;
  final String complaintDescription;
  final String locationDescription;
  final String reportDate;
  final String reportTime;
  final String status;
  final String? photo;
  final String? rejectionReason;
  final int? petugasId;
  final String? petugasNotes;
  final String? completionNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Relasi
  final UserRelation? user;
  final UserRelation? petugas;

  ReportModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.complaintDescription,
    required this.locationDescription,
    required this.reportDate,
    required this.reportTime,
    required this.status,
    this.photo,
    this.rejectionReason,
    this.petugasId,
    this.petugasNotes,
    this.completionNotes,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.petugas,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      complaintDescription: json['complaint_description'],
      locationDescription: json['location_description'],
      reportDate: json['report_date'],
      reportTime: json['report_time'],
      status: json['status'],
      photo: json['photo'],
      rejectionReason: json['rejection_reason'],
      petugasId: json['petugas_id'],
      petugasNotes: json['petugas_notes'],
      completionNotes: json['completion_notes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? UserRelation.fromJson(json['user']) : null,
      petugas: json['petugas'] != null ? UserRelation.fromJson(json['petugas']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'complaint_description': complaintDescription,
      'location_description': locationDescription,
      'report_date': reportDate,
      'report_time': reportTime,
      'status': status,
      'photo': photo,
      'rejection_reason': rejectionReason,
      'petugas_id': petugasId,
      'petugas_notes': petugasNotes,
      'completion_notes': completionNotes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user?.toJson(),
      'petugas': petugas?.toJson(),
    };
  }

  // Helper methods
  String getStatusLabel() {
    switch (status) {
      case 'pending':
        return 'Menunggu';
      case 'on_hold':
        return 'Ditahan';
      case 'in_progress':
        return 'Dalam Proses';
      case 'done':
        return 'Selesai';
      default:
        return status;
    }
  }

  bool isPending() => status == 'pending';
  bool isOnHold() => status == 'on_hold';
  bool isInProgress() => status == 'in_progress';
  bool isDone() => status == 'done';

  // PERBAIKAN: Gunakan StorageUrl dari ApiConfig
  String getPhotoUrl(String baseStorageUrl) {
    if (photo == null || photo!.isEmpty) return '';
    if (photo!.startsWith('http')) return photo!;
    return '$baseStorageUrl/storage/$photo';
  }

  bool hasPhoto() => photo != null && photo!.isNotEmpty;

  String getReporterName() {
    return user?.name ?? 'Unknown';
  }

  String getPetugasName() {
    return petugas?.name ?? '-';
  }
}

// User relation model (untuk relasi user dan petugas)
class UserRelation {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;

  UserRelation({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
  });

  factory UserRelation.fromJson(Map<String, dynamic> json) {
    return UserRelation(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'phone': phone,
      'address': address,
    };
  }
}