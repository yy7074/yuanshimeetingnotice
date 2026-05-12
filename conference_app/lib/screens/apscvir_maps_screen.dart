import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/site_content_model.dart';
import '../services/apscvir_site_service.dart';
import '../theme/app_theme.dart';
import '../utils/apscvir_external_links.dart';
import 'apscvir_content_screen.dart';

const _venueMapAsset = 'assets/apscvir2026/images/apscvir-venue-map.png';

class ApscvirMapsScreen extends StatelessWidget {
  final VoidCallback? onBackToHome;
  final Future<SiteManifest>? manifestFuture;

  const ApscvirMapsScreen({super.key, this.onBackToHome, this.manifestFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SiteManifest>(
      future: manifestFuture ?? ApscvirSiteService.loadManifest(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final manifest = snapshot.data!;
        const primary = AppColors.primary;
        final pages = manifest.pageById;
        final mapPages = [
          pages['1520613'],
          pages['1520615'],
          pages['1520616'],
          pages['1520614'],
        ].whereType<SitePage>().toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              children: [
                Row(
                  children: [
                    if (onBackToHome == null) ...[
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                        ),
                        onPressed: _goBack,
                        tooltip: 'Back',
                      ),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      'Maps',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  manifest.conference.venue,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  manifest.conference.location,
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
                const SizedBox(height: 18),
                _VenueMapCard(primary: primary),
                const SizedBox(height: 18),
                for (final page in mapPages)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: primary.withAlpha(32)),
                      ),
                      leading: Icon(_iconFor(page.title), color: primary),
                      title: Text(
                        page.title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text(_subtitleFor(page.title)),
                      trailing: Icon(
                        isApscvirVenuePage(page)
                            ? Icons.open_in_new
                            : Icons.chevron_right,
                      ),
                      onTap: () => _openMapPage(page, manifest),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void _openMapPage(SitePage page, SiteManifest manifest) {
  if (isApscvirVenuePage(page)) {
    openApscvirVenueWebsite();
    return;
  }
  Get.to(() => ApscvirContentScreen(page: page, manifest: manifest));
}

class _VenueMapCard extends StatelessWidget {
  final Color primary;

  const _VenueMapCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 232,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ColoredBox(
                color: primary.withAlpha(10),
                child: Image.asset(
                  _venueMapAsset,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: primary.withAlpha(20),
                    alignment: Alignment.center,
                    child: Icon(Icons.map_outlined, color: primary, size: 48),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Venue Map Image',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: primary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Semantics(
                button: true,
                child: Material(
                  color: primary,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: _shareMapImage,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.file_download_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Download',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _shareMapImage() async {
    try {
      final data = await rootBundle.load(_venueMapAsset);
      final bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/apscvir-venue-map.png');
      await file.writeAsBytes(bytes, flush: true);
      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'APSCVIR 2026 Venue Map');
    } catch (_) {
      Get.snackbar(
        'Map Unavailable',
        'This map image could not be opened.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade700,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}

void _goBack() {
  if (Get.key.currentState?.canPop() == true) {
    Get.back();
  } else {
    Get.offAllNamed('/main');
  }
}

IconData _iconFor(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('transport')) return Icons.route_outlined;
  if (lower.contains('tour') || lower.contains('suzhou')) {
    return Icons.travel_explore_outlined;
  }
  return Icons.place_outlined;
}

String _subtitleFor(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('transport')) {
    return 'Arrivals, routes, and access information';
  }
  if (lower.contains('tour')) return 'Local touring information';
  if (lower.contains('suzhou')) return 'Destination overview';
  return 'Venue details and address';
}
