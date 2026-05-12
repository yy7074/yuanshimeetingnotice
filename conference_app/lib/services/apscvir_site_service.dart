import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/site_content_model.dart';

class ApscvirSiteService {
  static SiteManifest? _cachedManifest;

  static Future<SiteManifest> loadManifest() async {
    final cached = _cachedManifest;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString(
      'assets/apscvir2026/data/site_manifest.json',
    );
    final manifest = SiteManifest.fromJson(jsonDecode(raw));
    _cachedManifest = manifest;
    return manifest;
  }
}
