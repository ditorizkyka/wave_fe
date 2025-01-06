import 'package:get/get.dart';

class QuestionController extends GetxController {
  final Rx<String> selectedSingleAnswer = ''.obs;
  final RxList<String> selectedMultipleValues = <String>[].obs;

  final RxMap singleAnswerObject = {}.obs;
  final RxList<Map> multipleAnswerObject = <Map>[].obs;

  bool isOptionSelected(String option) {
    return selectedMultipleValues.contains(option);
  }

  void updateMultipleSelection(
      int optionId, String optionText, bool isSelected) {
    if (isSelected && !selectedMultipleValues.contains(optionText)) {
      selectedMultipleValues.add(optionText);
      multipleAnswerObject.add({'optionId': optionId, 'options': optionText});
    } else if (!isSelected && selectedMultipleValues.contains(optionText)) {
      selectedMultipleValues.remove(optionText);
    }
    update();
  }

  void clearSelections() {
    selectedMultipleValues.clear();
    update();
  }

  int get selectedCount => selectedMultipleValues.length;
}
