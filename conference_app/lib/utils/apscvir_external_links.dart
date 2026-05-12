import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/site_content_model.dart';

const apscvirVenueExternalUrl =
    'https://en.suzhouexpo.com/index.aspx#section-1';
const apscvirIsmioExternalUrl =
    'https://ismio2026.sciconf.cn/en/web/index/32237';

bool isApscvirVenuePage(SitePage page) {
  return page.id == '1520613' || page.title.trim().toLowerCase() == 'venue';
}

bool isApscvirVenueMenuItem(SiteMenuItem item) {
  return item.id == '1520613' || item.title.trim().toLowerCase() == 'venue';
}

Future<void> openApscvirVenueWebsite() async {
  await _openExternalUrl(
    title: 'Unable to Open Venue',
    url: apscvirVenueExternalUrl,
  );
}

Future<void> openApscvirIsmioWebsite() async {
  await _openExternalUrl(
    title: 'Unable to Open ISMIO',
    url: apscvirIsmioExternalUrl,
  );
}

Future<void> _openExternalUrl({
  required String title,
  required String url,
}) async {
  final uri = Uri.parse(url);
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    Get.snackbar(
      title,
      url,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}
