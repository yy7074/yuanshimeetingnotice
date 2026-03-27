import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/speaker_controller.dart';
import '../models/speaker_model.dart';

class SpeakersScreen extends StatelessWidget {
  const SpeakersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color backgroundColor = Color(0xFFF3FAFF);
    const Color surfaceColor = Color(0xFFDBF1FE);
    const Color accentColor = Color(0xFFFFDEA5);
    final speakerCtrl = Get.find<SpeakerController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(primaryColor),
            Expanded(
              child: Obx(() => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                children: [
                  _buildTitleSection(primaryColor),
                  const SizedBox(height: 24),
                  _buildSearchBar(primaryColor, surfaceColor, speakerCtrl),
                  const SizedBox(height: 32),
                  if (speakerCtrl.keynoteSpeakers.isNotEmpty) ...[
                    _buildSectionTitle('keynote_speakers'.tr, accentColor, primaryColor),
                    const SizedBox(height: 16),
                    ...speakerCtrl.keynoteSpeakers.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSpeakerCard(primaryColor: primaryColor, surfaceColor: surfaceColor, speaker: s, tagColor: accentColor),
                    )),
                  ],
                  if (speakerCtrl.panelistSpeakers.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _buildSectionTitle('panelists'.tr, primaryColor, primaryColor),
                    const SizedBox(height: 16),
                    ...speakerCtrl.panelistSpeakers.map((s) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildSpeakerCard(primaryColor: primaryColor, surfaceColor: surfaceColor, speaker: s, tagColor: surfaceColor),
                    )),
                  ],
                  if (speakerCtrl.filteredSpeakers.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(
                          Get.locale?.languageCode == 'zh' ? '未找到匹配的嘉宾' : 'No matching speakers found',
                          style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Center(
        child: Text(
          Get.locale?.languageCode == 'zh' ? '特邀专家学者' : 'EXPERT SPEAKERS',
          style: TextStyle(fontFamily: 'Noto Serif', fontSize: 16, fontWeight: FontWeight.w900, color: primaryColor, letterSpacing: 0.5),
        ),
      ),
    );
  }

  Widget _buildTitleSection(Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'distinguished_speakers'.tr,
          style: TextStyle(fontFamily: 'Noto Serif', fontSize: 32, fontWeight: FontWeight.w900, color: primaryColor, letterSpacing: -0.5, height: 1.1),
        ),
        const SizedBox(height: 8),
        Text(
          'speakers_desc'.tr,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey.shade600, letterSpacing: 1.0),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color primaryColor, Color surfaceColor, SpeakerController ctrl) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceColor, width: 2),
      ),
      child: TextField(
        onChanged: (value) => ctrl.searchQuery.value = value,
        decoration: InputDecoration(
          hintText: 'search_speaker_hint'.tr,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color dotColor, Color primaryColor) {
    return Row(
      children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontFamily: 'Noto Serif', fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor)),
      ],
    );
  }

  Widget _buildSpeakerCard({
    required Color primaryColor,
    required Color surfaceColor,
    required SpeakerModel speaker,
    required Color tagColor,
  }) {
    final isZh = Get.locale?.languageCode == 'zh';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: surfaceColor.withAlpha((0.5 * 255).round())),
        boxShadow: [BoxShadow(color: primaryColor.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: surfaceColor, width: 2),
              image: DecorationImage(image: NetworkImage(speaker.avatarUrl), fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        isZh ? speaker.nameZh : speaker.nameEn,
                        style: TextStyle(fontFamily: 'Noto Serif', fontSize: 18, fontWeight: FontWeight.w900, color: primaryColor, height: 1.1),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        isZh ? speaker.category.labelZh : speaker.category.labelEn,
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: primaryColor, letterSpacing: 0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isZh ? speaker.titleZh : speaker.titleEn,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: primaryColor.withAlpha((0.5 * 255).round())),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        isZh ? speaker.organizationZh : speaker.organizationEn,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: primaryColor.withAlpha((0.7 * 255).round()), letterSpacing: 0.5, height: 1.2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
