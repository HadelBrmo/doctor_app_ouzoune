// doctor_model.dart
import 'clinic_model.dart';

class Doctor {
  final String? id;
  final String? userName;
  final String? email;
  final String? phoneNumber;
  final String? role;
  final Clinic? clinic;
  final double? rate;
  final String? profileImagePath;

  Doctor({
    required this.id,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.clinic,
    this.rate,
    this.profileImagePath,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      role: json['role'] as String? ?? 'User',
      clinic: json['clinic'] != null ? Clinic.fromJson(json['clinic'] as Map<String, dynamic>) : null,
      rate: (json['rate'] as num?)?.toDouble(),
      profileImagePath: json['profileImagePath'] as String?,
    );
  }
}