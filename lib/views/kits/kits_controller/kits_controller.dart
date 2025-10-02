import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/services/api_services.dart';
import '../../../models/Implant_model.dart';
import '../../../models/additionalTool_model.dart';
import '../../../models/kit_model.dart';

class KitsController extends GetxController {
  ApiServices apiServices = ApiServices();
  final List<Map<String, dynamic>> surgicalKits = [
    {
      'name': 'Dental Drill',
      'image': 'assets/images/forceps.png',
      'length': '15 cm',
      'width': '3 cm',
      'thickness': '2 cm',
      'quantity': "0",
    },
    {
      'name': 'Surgical Scissors',
      'image': 'assets/images/mouth-mirror.png',
      'length': '12 cm',
      'width': '4 cm',
      'thickness': '0.5 cm',
      'quantity': "3",
    },
    {
      'name': 'Bone File',
      'image': 'assets/images/probe.png',
      'length': '18 cm',
      'width': '2 cm',
      'thickness': '0.8 cm',
      'quantity': "2",
    },
    {
      'name': 'Retractor',
      'image': 'assets/images/tooth.png',
      'length': '20 cm',
      'width': '5 cm',
      'thickness': '1 cm',
      'quantity': "1",
    },
    {
      'name': 'Dental Drill',
      'image': 'assets/images/forceps.png',
      'length': '15 cm',
      'width': '3 cm',
      'thickness': '2 cm',
      'quantity': "4",
    },
    {
      'name': 'Surgical Scissors',
      'image': 'assets/images/mouth-mirror.png',
      'length': '12 cm',
      'width': '4 cm',
      'thickness': '0.5 cm',
      'quantity': "5",
    },
  ];
  final RxList<Implant> implants = <Implant>[].obs;
  final RxList<Kit> kits = <Kit>[].obs;
  final RxList<AdditionalTool> additionalTools = <AdditionalTool>[].obs;
  final RxList<int> additionalToolQuantities = <int>[].obs;
  final RxList<AdditionalTool> selectedAdditionalTools = <AdditionalTool>[].obs;
  final RxList<int> toolQuantities = <int>[].obs;
  final RxMap<String, bool> tools = <String, bool>{}.obs;
  final RxList<int> surgicalToolQuantities = <int>[].obs;
  final RxList<Map<String, dynamic>> selectedTools = <Map<String, dynamic>>[].obs;
  final RxList<Implant> selectedPartialImplants = <Implant>[].obs;
  final Rx<Kit?> selectedKit = Rx<Kit?>(null);
  final RxBool isLoading = true.obs;
  final RxMap<int, String> implantNames = <int, String>{}.obs;
  final RxMap<int, List<String>> kitToolNames= <int, List<String>>{}.obs;
  final RxMap<String, Implant> selectedImplants = <String, Implant>{}.obs;
  final RxMap<String, List<int>> selectedToolsForImplants = <String, List<int>>{}.obs;
  final RxMap<int, List<AdditionalTool>> kitTools = <int, List<AdditionalTool>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();

  }

  Future<void> fetchAllData() async {
    try {
      isLoading(true);
      await Future.wait([
        fetchImplants(),
        fetchKits(),
        fetchAdditionalTools(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: ${e.toString()}');
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchImplants() async {
    try {
      final data = await ApiServices().getImplants();
      if (data.isEmpty) {
        Get.snackbar('Info', 'No implants found');
      }
      implants.assignAll(data);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load implants: ${e.toString()}',
        duration: Duration(seconds: 5),
      );
      implants.clear();
      rethrow;
    }
  }

  Future<void> fetchKits() async {
    try {
      final List<Kit> kitsData = await ApiServices().getKits();


      kits.assignAll(kitsData);

      for (final kit in kits) {
        debugPrint('Kit ID: ${kit.id} has ${kit.tools.length} tools');
      }
    } catch (e) {
      debugPrint('Error fetching kits: $e');
      Get.snackbar('Error', 'Failed to load kits: ${e.toString()}');
      kits.clear();
    }
  }

  Future<void> fetchAdditionalTools() async {
    try {
      final data = await ApiServices().getAdditionalTools();
      additionalTools.assignAll(data);
      additionalToolQuantities.assignAll(List.filled(data.length, 0));
    } catch (e) {
      Get.snackbar('Error', 'Failed to load tools: ${e.toString()}');
      additionalTools.clear();
    }
  }



  // int getToolIdByName(String toolName) {
  //   if (toolName == 'No tools') return 0;
  //
  //   for (var implant in implants.cast<Map<String, dynamic>>()) {
  //     for (var tool in (implant['tools'] as List).cast<Map<String, dynamic>>()) {
  //       if (tool['name'] == toolName && tool['id'] != null) {
  //         return tool['id'] as int;
  //       }
  //     }
  //   }
  //
  //   for (var tool in [...additionalTools.cast<Map<String, dynamic>>(), ...surgicalKits.cast<Map<String, dynamic>>()]) {
  //     if (tool['name'] == toolName && tool['id'] != null) {
  //       return tool['id'] as int;
  //     }
  //   }
  //
  //   return 0;
  // }

  List<AdditionalTool> getToolsByKitId(int kitId) {
    return kitTools[kitId] ?? [];
  }


  Future<void> fetchKitById(int kitId) async {
    try {
      final Kit kit = await apiServices.getKitById(kitId);
      kitTools[kitId] = kit.tools.cast<AdditionalTool>();
      update();
    } catch (e) {
      throw Exception('Failed to load tools: $e');
    }
  }



  List<int> getSelectedToolsIds() {
    List<int> ids = [];
    for (int i = 0; i < toolQuantities.length; i++) {
      if (toolQuantities[i] > 0) {
        ids.add(i + 1);
      }
    }
    return ids;
  }


  String getImplantNameByKitId(int kitId) {

    if (implantNames.containsKey(kitId)) {
      return implantNames[kitId]!;
    }

    if (selectedKit.value != null && selectedKit.value!.id == kitId) {
      return selectedKit.value!.name;
    }

    try {
      final kit = kits.firstWhere((k) => k.id == kitId);
      return kit.name;
    } catch (e) {
      return 'Loading...';
    }
  }





  //function for additional tools

  void updateAdditionalToolQuantity(int toolIndex, int newQuantity) {
    if (toolIndex >= 0 && toolIndex < additionalTools.length) {
      additionalToolQuantities[toolIndex] = newQuantity;
      updateSelectedAdditionalTools();
    }
  }

  void updateSelectedAdditionalTools() {
    selectedAdditionalTools.clear();
    for (int i = 0; i < additionalToolQuantities.length; i++) {
      if (additionalToolQuantities[i] > 0) {
        selectedAdditionalTools.add(additionalTools[i]);
      }
    }
  }

  void updateSelectedTools() {
    selectedTools.clear();
    for (int i = 0; i < additionalTools.length; i++) {
      if (additionalToolQuantities[i] > 0) {
        selectedTools.add({
          'id': additionalTools[i].id,
          'name': additionalTools[i].name,
          'quantity': additionalToolQuantities[i],
        });
      }
    }
    update();
  }



  // Function For Implants kits

  void toggleImplantSelection(String implantId, Implant implantData) {
    if (selectedImplants.containsKey(implantId)) {
      selectedImplants.remove(implantId);
      selectedToolsForImplants.remove(implantId);
    } else {
      selectedImplants[implantId] = implantData;
    }
    update();
  }

  void toggleToolSelection(String implantId, int toolId) {
    selectedToolsForImplants[implantId] ??= RxList<int>();

    if (selectedToolsForImplants[implantId]!.contains(toolId)) {
      selectedToolsForImplants[implantId]!.remove(toolId);
    } else {
      selectedToolsForImplants[implantId]!.add(toolId);
    }
    update();
  }

  bool isToolSelectedForImplant(String implantId, int toolId) {
    return selectedToolsForImplants[implantId]?.contains(toolId) ?? false;
  }



  // Function For PartialImplants
  void addPartialImplant(Implant implant, {List<int>? tools}) {
    print('======= START addPartialImplant =======');
    print('Implant ID: ${implant.id}');
    print('Implant Brand: ${implant.brand}');
    print('Tools: ${tools?.join(', ') ?? 'No tools'}');

    if (implant.id == null) {
      print('ERROR: Implant ID is null!');
      return;
    }

    try {
      final implantId = implant.id.toString();

      final existingIndex = selectedPartialImplants.indexWhere((i) => i.id == implant.id);

      if (existingIndex != -1) {
        selectedPartialImplants[existingIndex] = implant;
        print('Existing implant updated');
      } else {
        selectedPartialImplants.add(implant);
        print('New implant added to list');
      }

      if (tools != null && tools.isNotEmpty) {
        selectedToolsForImplants[implantId] = tools;
        print('Tools added/updated successfully');
      } else {
        selectedToolsForImplants.remove(implantId);
      }

      print('Current implants count: ${selectedPartialImplants.length}');
      print('Current tools mapping: ${selectedToolsForImplants}');

      update();
      print('UI updated called');
    } catch (e) {
      print('EXCEPTION in addPartialImplant: $e');
    } finally {
      print('======= END addPartialImplant =======');
    }
  }

  void removePartialImplant(String implantId) {
    selectedPartialImplants.removeWhere((implant) => implant.id.toString() == implantId);
    update();
  }

  void clearSelectedImplants() {
    selectedImplants.clear();
  }


















}