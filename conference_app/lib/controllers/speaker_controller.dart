import 'package:get/get.dart';
import '../models/speaker_model.dart';
import '../services/data_service.dart';

class SpeakerController extends GetxController {
  final speakers = <SpeakerModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    speakers.value = DataService.speakers;
  }

  List<SpeakerModel> get filteredSpeakers {
    if (searchQuery.value.isEmpty) return speakers;
    final q = searchQuery.value.toLowerCase();
    return speakers.where((s) =>
      s.nameEn.toLowerCase().contains(q) ||
      s.nameZh.contains(q) ||
      s.organizationEn.toLowerCase().contains(q) ||
      s.organizationZh.contains(q) ||
      s.titleEn.toLowerCase().contains(q) ||
      s.titleZh.contains(q)
    ).toList();
  }

  List<SpeakerModel> get keynoteSpeakers =>
    filteredSpeakers.where((s) => s.category == SpeakerCategory.keynote || s.category == SpeakerCategory.vipGuest).toList();

  List<SpeakerModel> get panelistSpeakers =>
    filteredSpeakers.where((s) => s.category == SpeakerCategory.research || s.category == SpeakerCategory.workshop).toList();
}
