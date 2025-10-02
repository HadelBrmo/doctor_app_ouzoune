// procedure_model.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ImplantKit .dart';
import 'implant_model.dart';
import 'additionalTool_model.dart';
import 'assistant_model.dart';
import 'doctor_model.dart';
import 'kit_model.dart';

class Procedure {
  final int id;
  final String doctorId;
  final int numberOfAssistants;
  final List<String> assistantIds;
  final int categoryId;
    int status;
  final DateTime date;
  final Doctor doctor;
  final List<AdditionalTool> tools;
  final List<Kit> kits;
  final List<ImplantKit> implantKits;
  final List<Assistant> assistants;

  Procedure({
    required this.id,
    required this.doctorId,
    required this.numberOfAssistants,
    required this.assistantIds,
    required this.categoryId,
    required this.status,
    required this.date,
    required this.doctor,
    required this.tools,
    required this.kits,
    required this.implantKits,
    required this.assistants,
  });

  factory Procedure.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('Parsing Procedure JSON - surgicalKits: ${json['surgicalKits']}');
      debugPrint('Parsing Procedure JSON - implantKits: ${json['implantKits']}');
      final surgicalKitsJson = json['surgicalKits'] as List<dynamic>? ?? [];
      final List<Kit> surgicalKits = surgicalKitsJson.map((kitJson) {
        if (kitJson is Map<String, dynamic>) {
          return Kit.fromJson(kitJson);
        } else {
          debugPrint('Invalid surgical kit data: $kitJson');
          return Kit(
            id: 0,
            name: 'Invalid Surgical Kit',
            isMainKit: false,
            implantCount: 0,
            toolCount: 0,
            implants: [],
            tools: [],
          );
        }
      }).toList();

      final implantKitsJson = json['implantKits'] as List<dynamic>? ?? [];
      final List<ImplantKit> implantKits = implantKitsJson.map((implantKitJson) {
        if (implantKitJson is Map<String, dynamic>) {
          return ImplantKit.fromJson(implantKitJson);
        } else {
          debugPrint('Invalid implant kit data: $implantKitJson');
          return ImplantKit(
            implant: Implant(
              id: 0,
              radius: 0,
              width: 0,
              height: 0,
              quantity: 0,
              brand: 'Invalid Implant',
              description: 'Invalid implant data',
              imagePath: null,
              kitId: 0,
            ),
            toolsWithImplant: [],
          );
        }
      }).toList();

      return Procedure(
        id: json['id'] ?? 0,
        doctorId: json['doctorId'] ?? '',
        categoryId: json['categoryId'] ?? 0,
        numberOfAssistants: json['numberOfAsisstants'] ?? 0,
        status: json['status'] ?? 0,
        date: DateTime.parse(json['date'] ?? DateTime.now().toString()),
        doctor: Doctor.fromJson(json['doctor'] ?? {}),
        tools: List<AdditionalTool>.from(
            (json['requiredTools'] ?? []).map((x) {
              if (x is Map<String, dynamic>) {
                return AdditionalTool.fromJson(x);
              } else {
                debugPrint('Invalid tool data: $x');
                return AdditionalTool(
                  id: 0,
                  name: 'Invalid Tool',
                  width: 0,
                  height: 0,
                  thickness: 0,
                  quantity: 0,
                  kitId: 0,
                  categoryId: 0,
                  imagePath: null,
                );
              }
            })),
        kits: surgicalKits,
        implantKits: implantKits,
        assistants: List<Assistant>.from(
            (json['assistants'] ?? []).map((x) {
              if (x is Map<String, dynamic>) {
                return Assistant.fromJson(x);
              } else {
                debugPrint('Invalid assistant data: $x');
                return Assistant(
                  id: '',
                  userName: 'Invalid Assistant',
                  email: '',
                  phoneNumber: null,
                  role: 'User',
                  clinic: null,
                  rate: 0,
                );
              }
            })),
        assistantIds: (json['assistants'] as List<dynamic>?)
            ?.map((a) {
          if (a is Map<String, dynamic>) {
            return a['id'] as String? ?? '';
          }
          return '';
        })
            .where((id) => id.isNotEmpty)
            .toList() ?? [],
      );
    } catch (e) {
      debugPrint('Error parsing Procedure: $e');
      debugPrint('Full JSON: $json');

      return Procedure(
        id: 0,
        doctorId: '',
        numberOfAssistants: 0,
        assistantIds: [],
        categoryId: 0,
        status: 0,
        date: DateTime.now(),
        doctor: Doctor(
          id: '',
          userName: '',
          email: '',
          phoneNumber: '',
          role: 'User',
          clinic: null,
          rate: 0,
          profileImagePath: null,
        ),
        tools: [],
        kits: [],
        implantKits: [],
        assistants: [],
      );
    }
  }

  String get statusText {
    switch (status) {
      case 1: return "Request_Sent";
      case 2: return "In_Progress";
      case 3: return "Done";
      case 4: return "Declined";
      case 5: return "Cancelled";
      default: return "Request_Sent";
    }
  }

  Color get statusColor {
    switch (status) {
      case 1: return Colors.orange;
      case 2: return Colors.blue;
      case 3: return Colors.green;
      case 4: return Colors.red;
      case 5 : return Colors.grey;
      default: return Colors.orange;
    }
  }
}