// controllers/assistant_controller.dart
import 'package:get/get.dart';

class DoctorChoicesController extends GetxController {
  RxInt selectedAssistants = 0.obs;
  RxInt tempSelection = 0.obs;
  RxBool showNextButton = false.obs;
  var withoutAssistantClicked = false.obs;


  void selectAssistants(int number) {
    tempSelection.value = number;
    showNextButton.value = true;
  }

  void confirmSelection() {
    selectedAssistants.value = tempSelection.value;
    tempSelection.value = 0;
  }

  void resetSelection() {
    tempSelection.value = 0;
    showNextButton.value = false;
  }
}