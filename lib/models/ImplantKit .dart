import 'implant_model.dart';
import 'additionalTool_model.dart';

class ImplantKit {
  final Implant implant;
  final List<AdditionalTool> toolsWithImplant;

  ImplantKit({
    required this.implant,
    required this.toolsWithImplant,
  });

  factory ImplantKit.fromJson(Map<String, dynamic> json) {
    return ImplantKit(
      implant: Implant.fromJson(json['implant'] ?? {}),
      toolsWithImplant: (json['toolsWithImplant'] as List<dynamic>?)
          ?.map((e) => AdditionalTool.fromJson(e ?? {}))
          .toList() ?? [],
    );
  }
}