// kit_model.dart
import 'package:flutter/cupertino.dart';
import 'additionalTool_model.dart';
import 'implant_model.dart';
class Kit {
  final int id;
  final String name;
  final bool isMainKit;
  final int implantCount;
  final int toolCount;
  final List<Implant> implants;
  final List<AdditionalTool> tools;

  Kit({
    required this.id,
    required this.name,
    required this.isMainKit,
    required this.implantCount,
    required this.toolCount,
    required this.implants,
    required this.tools,
  });

  factory Kit.fromJson(Map<String, dynamic> json) {
    try {
      debugPrint('Parsing Kit JSON: $json');

      // معالجة implants
      final implantsJson = json['implants'] as List<dynamic>? ?? [];
      final implants = implantsJson.map((e) {
        if (e is Map<String, dynamic>) {
          return Implant.fromJson(e);
        } else {
          debugPrint('Invalid implant data: $e');
          return Implant(
            id: 0,
            radius: 0,
            width: 0,
            height: 0,
            quantity: 0,
            brand: 'Invalid',
            description: 'Invalid implant data',
            imagePath: null,
            kitId: 0,
          );
        }
      }).toList();

      // معالجة tools
      final toolsJson = json['tools'] as List<dynamic>? ?? [];
      final tools = toolsJson.map((e) {
        if (e is Map<String, dynamic>) {
          return AdditionalTool.fromJson(e);
        } else {
          debugPrint('Invalid tool data: $e');
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
      }).toList();

      return Kit(
        id: json['id'] ?? json['kitId'] ?? 0,
        name: (json['name'] ?? 'Unnamed Kit').toString(),
        isMainKit: json['isMainKit'] ?? false,
        implantCount: implants.length,
        toolCount: tools.length,
        implants: implants,
        tools: tools,
      );
    } catch (e) {
      debugPrint('Error parsing Kit: $e');
      debugPrint('Problematic JSON: $json');

      // إرجاع kit افتراضي في حالة الخطأ
      return Kit(
        id: 0,
        name: 'Error Kit',
        isMainKit: false,
        implantCount: 0,
        toolCount: 0,
        implants: [],
        tools: [],
      );
    }
  }
}