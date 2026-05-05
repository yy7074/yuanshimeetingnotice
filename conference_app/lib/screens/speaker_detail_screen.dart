import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/speaker_model.dart';

class SpeakerDetailScreen extends StatelessWidget {
  const SpeakerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isZh = Get.locale?.languageCode == 'zh';
    const Color primaryColor = Color(0xFF000666);
    const Color surfaceColor = Color(0xFFDBF1FE);
    final speaker = Get.arguments is SpeakerModel ? Get.arguments as SpeakerModel : null;

    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          isZh ? '嘉宾详情' : 'Speaker Profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        centerTitle: true,
      ),
      body: speaker == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    isZh ? '未找到嘉宾信息' : 'Speaker information is unavailable',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
            // Header card
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (speaker.avatarUrl.isNotEmpty) {
                        Get.dialog(
                          Dialog(
                            backgroundColor: Colors.black87,
                            insetPadding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                Center(
                                  child: InteractiveViewer(
                                    minScale: 0.5,
                                    maxScale: 4.0,
                                    child: Image.network(
                                      speaker.avatarUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100, color: Colors.white),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 16,
                                  child: IconButton(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barrierColor: Colors.black87,
                        );
                      }
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: surfaceColor, width: 3),
                        color: Colors.grey.shade100,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: speaker.avatarUrl.isNotEmpty
                          ? Image.network(
                              speaker.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.person, size: 48, color: Colors.grey.shade400),
                            )
                          : Icon(Icons.person, size: 48, color: Colors.grey.shade400),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isZh ? speaker.nameZh : speaker.nameEn,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor),
                    textAlign: TextAlign.center,
                  ),
                  if ((isZh ? speaker.nameEn : speaker.nameZh).isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      isZh ? speaker.nameEn : speaker.nameZh,
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12),
                  Text(
                    isZh ? speaker.titleZh : speaker.titleEn,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isZh ? speaker.organizationZh : speaker.organizationEn,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDEA5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isZh ? speaker.category.labelZh : speaker.category.labelEn,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Bio section
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isZh ? '个人简介' : 'Biography',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    (isZh ? speaker.bioZh : speaker.bioEn).isNotEmpty
                        ? (isZh ? speaker.bioZh : speaker.bioEn)
                        : (isZh ? '暂无简介' : 'No biography available'),
                    style: TextStyle(
                      fontSize: 15,
                      color: (isZh ? speaker.bioZh : speaker.bioEn).isNotEmpty ? Colors.grey.shade800 : Colors.grey.shade400,
                      height: 1.7,
                    ),
                  ),
                  if ((isZh ? speaker.bioEn : speaker.bioZh).isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade200),
                    const SizedBox(height: 16),
                    Text(
                      isZh ? speaker.bioEn : speaker.bioZh,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500, height: 1.7),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Info cards
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isZh ? '详细信息' : 'Details',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(Icons.work_outline, isZh ? '头衔' : 'Title', isZh ? speaker.titleZh : speaker.titleEn, primaryColor),
                  if ((isZh ? speaker.titleEn : speaker.titleZh).isNotEmpty)
                    _buildDetailRow(null, '', isZh ? speaker.titleEn : speaker.titleZh, primaryColor, isSecondary: true),
                  const Divider(height: 24),
                  _buildDetailRow(Icons.business, isZh ? '机构' : 'Organization', isZh ? speaker.organizationZh : speaker.organizationEn, primaryColor),
                  if ((isZh ? speaker.organizationEn : speaker.organizationZh).isNotEmpty)
                    _buildDetailRow(null, '', isZh ? speaker.organizationEn : speaker.organizationZh, primaryColor, isSecondary: true),
                ],
              ),
            ),
            const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(IconData? icon, String label, String value, Color primaryColor, {bool isSecondary = false}) {
    if (isSecondary) {
      return Padding(
        padding: const EdgeInsets.only(left: 40, top: 4),
        child: Text(value, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) Icon(icon, size: 20, color: primaryColor),
        if (icon != null) const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label.isNotEmpty) Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
              if (label.isNotEmpty) const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}
