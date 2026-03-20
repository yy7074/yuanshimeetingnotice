import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpeakersScreen extends StatelessWidget {
  const SpeakersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color backgroundColor = Color(0xFFF3FAFF);
    const Color surfaceColor = Color(0xFFDBF1FE);
    const Color accentColor = Color(0xFFFFDEA5);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(primaryColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                children: [
                  _buildTitleSection(primaryColor),
                  const SizedBox(height: 24),
                  _buildSearchBar(primaryColor, surfaceColor),
                  const SizedBox(height: 32),
                  _buildSectionTitle('keynote_speakers'.tr, accentColor, primaryColor),
                  const SizedBox(height: 16),
                  _buildSpeakerCard(
                    primaryColor: primaryColor,
                    surfaceColor: surfaceColor,
                    name: Get.locale?.languageCode == 'zh' ? 'Sarah Chen 博士' : 'Dr. Sarah Chen, PhD',
                    title: Get.locale?.languageCode == 'zh' ? '生物信息学主任' : 'Director of Bio-Informatics',
                    organization: Get.locale?.languageCode == 'zh' ? '斯坦福医学院' : 'Stanford Medicine',
                    avatarUrl: 'https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop',
                    tag: Get.locale?.languageCode == 'zh' ? '主旨演讲' : 'KEYNOTE',
                    tagColor: accentColor,
                  ),
                  const SizedBox(height: 16),
                  _buildSpeakerCard(
                    primaryColor: primaryColor,
                    surfaceColor: surfaceColor,
                    name: Get.locale?.languageCode == 'zh' ? 'Alistair Thorne 博士' : 'Dr. Alistair Thorne',
                    title: Get.locale?.languageCode == 'zh' ? '资深肿瘤学研究员' : 'Senior Oncology Curator',
                    organization: Get.locale?.languageCode == 'zh' ? '圣裘德医学研究中心' : 'St. Jude\'s Medical Research Center',
                    avatarUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=200&auto=format&fit=crop',
                    tag: Get.locale?.languageCode == 'zh' ? '特邀嘉宾' : 'VIP GUEST',
                    tagColor: accentColor,
                  ),
                  const SizedBox(height: 32),
                  _buildSectionTitle('panelists'.tr, primaryColor, primaryColor),
                  const SizedBox(height: 16),
                  _buildSpeakerCard(
                    primaryColor: primaryColor,
                    surfaceColor: surfaceColor,
                    name: Get.locale?.languageCode == 'zh' ? 'James Sterling 教授' : 'Prof. James Sterling',
                    title: Get.locale?.languageCode == 'zh' ? '肿瘤学负责人' : 'Oncology Lead',
                    organization: Get.locale?.languageCode == 'zh' ? '梅奥诊所' : 'Mayo Clinic',
                    avatarUrl: 'https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?q=80&w=200&auto=format&fit=crop',
                    tag: Get.locale?.languageCode == 'zh' ? '学术研究' : 'RESEARCH',
                    tagColor: surfaceColor,
                  ),
                  const SizedBox(height: 16),
                  _buildSpeakerCard(
                    primaryColor: primaryColor,
                    surfaceColor: surfaceColor,
                    name: Get.locale?.languageCode == 'zh' ? 'Elena Rodriguez 博士' : 'Dr. Elena Rodriguez',
                    title: Get.locale?.languageCode == 'zh' ? '高级药理学家' : 'Senior Pharmacologist',
                    organization: Get.locale?.languageCode == 'zh' ? '诺华制药' : 'Novartis',
                    avatarUrl: 'https://images.unsplash.com/photo-1594824461559-67d483b3e32e?q=80&w=200&auto=format&fit=crop',
                    tag: Get.locale?.languageCode == 'zh' ? '工作坊' : 'WORKSHOP',
                    tagColor: surfaceColor,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
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
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: primaryColor,
            letterSpacing: 0.5,
          ),
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
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: primaryColor,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'speakers_desc'.tr,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade600,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color primaryColor, Color surfaceColor) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: surfaceColor, width: 2),
      ),
      child: TextField(
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
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Noto Serif',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakerCard({
    required Color primaryColor,
    required Color surfaceColor,
    required String name,
    required String title,
    required String organization,
    required String avatarUrl,
    required String tag,
    required Color tagColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: surfaceColor.withAlpha((0.5 * 255).round())),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withAlpha((0.05 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
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
              image: DecorationImage(
                image: NetworkImage(avatarUrl),
                fit: BoxFit.cover,
              ),
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
                        name,
                        style: TextStyle(
                          fontFamily: 'Noto Serif',
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: primaryColor,
                          height: 1.1,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: tagColor == primaryColor ? Colors.white : primaryColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: primaryColor.withAlpha((0.5 * 255).round())),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        organization,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: primaryColor.withAlpha((0.7 * 255).round()),
                          letterSpacing: 0.5,
                          height: 1.2,
                        ),
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
