import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/site_content_model.dart';
import '../services/apscvir_site_service.dart';
import '../theme/app_theme.dart';
import '../utils/apscvir_external_links.dart';
import '../widgets/apscvir_asset_image.dart';
import 'apscvir_content_screen.dart' deferred as apscvir_content_screen;

const _venueMapAsset = 'assets/apscvir2026/images/apscvir-venue-map.png';
const _googleMapPreviewAsset =
    'assets/apscvir2026/images/venue-google-map-preview.jpeg';

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
                      'Venue',
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
                  apscvirVenueAddress,
                  style: const TextStyle(fontSize: 13, color: AppColors.muted),
                ),
                const SizedBox(height: 18),
                _VenueAddressCard(
                  primary: primary,
                  venueName: manifest.conference.venue,
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

Future<void> _openMapPage(SitePage page, SiteManifest manifest) async {
  if (isApscvirVenuePage(page)) {
    openApscvirVenueWebsite();
    return;
  }
  await apscvir_content_screen.loadLibrary();
  Get.to(
    () => apscvir_content_screen.ApscvirContentScreen(
      page: page,
      manifest: manifest,
    ),
  );
}

class _VenueAddressCard extends StatelessWidget {
  final Color primary;
  final String venueName;

  const _VenueAddressCard({required this.primary, required this.venueName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.place, color: primary, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Conference Address',
                  style: TextStyle(
                    color: primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            venueName,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w900,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 6),
          SelectableText(
            apscvirVenueAddress,
            style: const TextStyle(
              color: AppColors.inkSoft,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 214,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ApscvirAssetImage(
                assetPath: _googleMapPreviewAsset,
                width: double.infinity,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: primary.withAlpha(14),
                  alignment: Alignment.center,
                  child: Icon(Icons.map_outlined, color: primary, size: 46),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _VenueActionButton(
                icon: Icons.copy,
                label: 'Copy Address',
                primary: primary,
                filled: true,
                onTap: () => _copyAddress(primary),
              ),
              _VenueActionButton(
                icon: Icons.near_me,
                label: 'Navigation',
                primary: primary,
                onTap: () => showApscvirVenueMapChooser(primary: primary),
              ),
              _VenueActionButton(
                icon: Icons.open_in_new,
                label: 'Official Website',
                primary: primary,
                onTap: openApscvirVenueWebsite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _copyAddress(Color primary) async {
    await Clipboard.setData(const ClipboardData(text: apscvirVenueAddress));
    Get.snackbar(
      'Address Copied',
      apscvirVenueAddress,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}

class _VenueActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color primary;
  final VoidCallback onTap;
  final bool filled;

  const _VenueActionButton({
    required this.icon,
    required this.label,
    required this.primary,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? Colors.white : primary;
    return Material(
      color: filled ? primary : primary.withAlpha(12),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: foreground, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
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
                child: ApscvirAssetImage(
                  assetPath: _venueMapAsset,
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
      final remoteUrl = ApscvirSiteService.remoteAssetUrl(_venueMapAsset);
      if (remoteUrl != null) {
        final uri = Uri.tryParse(remoteUrl);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
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
