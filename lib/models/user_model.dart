// lib/models/user_model.dart
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? address;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.address,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      address: json['address'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Helper methods untuk check role
  bool isWarga() => role == 'warga';
  bool isRT() => role == 'rt';
  bool isAdmin() => role == 'admin';
  bool isPetugas() => role == 'petugas';

  // Get role label
  String getRoleLabel() {
    switch (role) {
      case 'warga':
        return 'Warga';
      case 'rt':
        return 'Ketua RT';
      case 'admin':
        return 'Admin';
      case 'petugas':
        return 'Petugas';
      default:
        return role;
    }
  }

  // Check if user has phone
  bool hasPhone() => phone != null && phone!.isNotEmpty;

  // Check if user has address
  bool hasAddress() => address != null && address!.isNotEmpty;

  // Check if email is verified
  bool isEmailVerified() => emailVerifiedAt != null;

  // Get initials for avatar
  String getInitials() {
    List<String> names = name.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  // Copy with method untuk update
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? phone,
    String? address,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}