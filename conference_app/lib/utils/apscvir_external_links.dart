import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/site_content_model.dart';

const apscvirVenueExternalUrl =
    'https://en.suzhouexpo.com/index.aspx#section-1';
const apscvirVenueGoogleMapsUrl =
    'https://www.google.com/maps/search/?api=1&query=Suzhou%20International%20Expo%20Centre%2C%20688%20E.%20Suzhou%20Avenue%2C%20Suzhou%20Industrial%20Park%2C%20Suzhou%2C%20Jiangsu%20Province%2C%20China';
const apscvirVenueNameEn = 'Suzhou International Expo Centre';
const apscvirVenueAddress =
    '688 E. Suzhou Avenue, Suzhou Industrial Park, Suzhou, Jiangsu Province, China';
const apscvirVenueLongitude = '120.7059';
const apscvirVenueLatitude = '31.3238';
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

Future<void> openApscvirVenueGoogleMaps() async {
  await _openExternalUrl(
    title: 'Unable to Open Google Maps',
    url: apscvirVenueGoogleMapsUrl,
  );
}

Future<void> showApscvirVenueMapChooser({Color? primary}) async {
  final accent = primary ?? Colors.teal;
  await Get.bottomSheet<void>(
    SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            Text(
              'Choose Map',
              style: TextStyle(
                color: accent,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              apscvirVenueNameEn,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            _MapChoiceTile(
              icon: Icons.near_me,
              title: 'Amap',
              subtitle: 'Recommended in mainland China',
              color: accent,
              onTap: openApscvirVenueAmap,
            ),
            if (Platform.isIOS)
              _MapChoiceTile(
                icon: Icons.map_outlined,
                title: 'Apple Maps',
                subtitle: 'Open with iOS Maps',
                color: accent,
                onTap: openApscvirVenueAppleMaps,
              ),
            _MapChoiceTile(
              icon: Icons.public,
              title: 'Google Maps',
              subtitle: 'Open with Google Maps',
              color: accent,
              onTap: () async {
                _closeMapChooser();
                await openApscvirVenueGoogleMaps();
              },
            ),
            _MapChoiceTile(
              icon: Icons.copy,
              title: 'Copy Address',
              subtitle: apscvirVenueAddress,
              color: accent,
              onTap: copyApscvirVenueAddress,
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

Future<void> openApscvirVenueAmap() async {
  _closeMapChooser();
  final appUri = Platform.isIOS
      ? Uri(
          scheme: 'iosamap',
          host: 'path',
          queryParameters: {
            'sourceApplication': 'APSCVIR',
            'dlat': apscvirVenueLatitude,
            'dlon': apscvirVenueLongitude,
            'dname': apscvirVenueNameEn,
            'dev': '0',
            't': '0',
          },
        )
      : Uri(
          scheme: 'androidamap',
          host: 'route',
          path: '/plan/',
          queryParameters: {
            'sourceApplication': 'APSCVIR',
            'dlat': apscvirVenueLatitude,
            'dlon': apscvirVenueLongitude,
            'dname': apscvirVenueNameEn,
            'dev': '0',
            't': '0',
          },
        );
  final launched = await launchUrl(
    appUri,
    mode: LaunchMode.externalApplication,
  );
  if (launched) return;

  final webUri = Uri.https('uri.amap.com', '/navigation', {
    'to': '$apscvirVenueLongitude,$apscvirVenueLatitude,$apscvirVenueNameEn',
    'mode': 'car',
    'policy': '1',
    'src': 'APSCVIR',
    'coordinate': 'gaode',
    'callnative': '1',
  });
  await launchUrl(webUri, mode: LaunchMode.externalApplication);
}

Future<void> openApscvirVenueAppleMaps() async {
  _closeMapChooser();
  final uri = Uri.https('maps.apple.com', '/', {
    'daddr': '$apscvirVenueLatitude,$apscvirVenueLongitude',
    'q': apscvirVenueNameEn,
    'dirflg': 'd',
  });
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

Future<void> copyApscvirVenueAddress() async {
  _closeMapChooser();
  await Clipboard.setData(const ClipboardData(text: apscvirVenueAddress));
  Get.snackbar(
    'Address Copied',
    apscvirVenueAddress,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.teal.shade700,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
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

void _closeMapChooser() {
  if (Get.isBottomSheetOpen == true) {
    Get.back<void>();
  }
}

class _MapChoiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Future<void> Function() onTap;

  const _MapChoiceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: color.withAlpha(20),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
      ),
      subtitle: Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
