import 'package:get/get.dart';
import '../models/speaker_model.dart';
import '../services/api_service.dart';
import '../services/data_service.dart';

class SpeakerController extends GetxController {
  final speakers = <SpeakerModel>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSpeakers();
  }

  Future<void> loadSpeakers() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getSpeakers();
      if (res.statusCode == 200 && res.body is List) {
        speakers.value = (res.body as List).map((s) => _parseSpeaker(s)).toList();
        return;
      }
    } catch (_) {}
    // Fallback
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

  SpeakerModel _parseSpeaker(Map<String, dynamic> json) {
    return SpeakerModel(
      id: json['id'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameZh: json['nameZh'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      organizationEn: json['organizationEn'] ?? '',
      organizationZh: json['organizationZh'] ?? '',
      bioEn: json['bioEn'] ?? '',
      bioZh: json['bioZh'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      category: _parseCategory(json['category'] as String?),
    );
  }

  SpeakerCategory _parseCategory(String? cat) {
    switch (cat) {
      case 'keynote': return SpeakerCategory.keynote;
      case 'vip_guest': return SpeakerCategory.vipGuest;
      case 'research': return SpeakerCategory.research;
      case 'workshop': return SpeakerCategory.workshop;
      default: return SpeakerCategory.keynote;
    }
  }
}
