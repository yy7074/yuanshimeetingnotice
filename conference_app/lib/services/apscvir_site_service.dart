import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/site_content_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class ApscvirSiteService {
  static const _manifestAsset = 'assets/apscvir2026/data/site_manifest.json';
  static const detailedProgramAsset =
      'assets/apscvir2026/site/pages/1814797-detailed-program.html';
  static SiteManifest? _cachedManifest;
  static bool _usingRemoteContent = false;
  static final Map<String, String> _assetStringCache = {};

  static bool get usingRemoteContent => _usingRemoteContent;

  static Future<SiteManifest> loadManifest({bool forceRefresh = false}) async {
    final cached = _cachedManifest;
    if (cached != null && !forceRefresh) return cached;

    final raw = await _loadRemoteManifestRaw();
    if (raw != null) {
      await _saveManifestCache(raw);
      final manifest = SiteManifest.fromJson(jsonDecode(raw));
      _cachedManifest = manifest;
      _usingRemoteContent = true;
      return manifest;
    }

    final cachedRaw = _readManifestCache();
    if (cachedRaw != null) {
      final manifest = SiteManifest.fromJson(jsonDecode(cachedRaw));
      _cachedManifest = manifest;
      _usingRemoteContent = true;
      return manifest;
    }

    final bundledRaw = await rootBundle.loadString(_manifestAsset);
    final manifest = SiteManifest.fromJson(jsonDecode(bundledRaw));
    _cachedManifest = manifest;
    _usingRemoteContent = false;
    return manifest;
  }

  static Future<void> refreshRemoteContent() async {
    final raw = await _loadRemoteManifestRaw();
    if (raw == null) return;
    await _saveManifestCache(raw);
    final manifest = SiteManifest.fromJson(jsonDecode(raw));
    _cachedManifest = manifest;
    _usingRemoteContent = true;
    final detailedHtml = await _loadRemoteAssetString(detailedProgramAsset);
    if (detailedHtml != null) {
      await _saveAssetStringCache(detailedProgramAsset, detailedHtml);
    }
  }

  static Future<String> loadAssetString(
    String assetPath, {
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _assetStringCache.containsKey(assetPath)) {
      return _assetStringCache[assetPath]!;
    }

    final remote = await _loadRemoteAssetString(assetPath);
    if (remote != null) {
      await _saveAssetStringCache(assetPath, remote);
      _usingRemoteContent = true;
      return remote;
    }

    if (!forceRefresh) {
      final cached = _readAssetStringCache(assetPath);
      if (cached != null) {
        _assetStringCache[assetPath] = cached;
        _usingRemoteContent = true;
        return cached;
      }
    }

    final bundled = await rootBundle.loadString(assetPath);
    _assetStringCache[assetPath] = bundled;
    return bundled;
  }

  static String? remoteAssetUrl(String assetPath) {
    if (!_usingRemoteContent || assetPath.trim().isEmpty) return null;
    if (!Get.isRegistered<ApiService>()) return null;
    return Get.find<ApiService>().apscvirContentFileUrl(assetPath);
  }

  static Future<String?> _loadRemoteManifestRaw() async {
    if (!Get.isRegistered<ApiService>()) return null;
    try {
      final response = await Get.find<ApiService>().getApscvirContentManifest();
      if (response.statusCode != 200) return null;
      if (response.body is Map) {
        return jsonEncode(response.body);
      }
      final raw = response.bodyString;
      return raw?.trim().isEmpty == true ? null : raw;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> _loadRemoteAssetString(String assetPath) async {
    if (!Get.isRegistered<ApiService>()) return null;
    try {
      final response = await Get.find<ApiService>().getApscvirContentFile(
        assetPath,
      );
      if (response.statusCode != 200) return null;
      final raw = response.bodyString ?? response.body?.toString();
      return raw?.trim().isEmpty == true ? null : raw;
    } catch (_) {
      return null;
    }
  }

  static String? _readManifestCache() {
    if (!Get.isRegistered<StorageService>()) return null;
    final raw = Get.find<StorageService>().apscvirManifestCache;
    return raw?.trim().isEmpty == true ? null : raw;
  }

  static Future<void> _saveManifestCache(String raw) async {
    if (!Get.isRegistered<StorageService>()) return;
    await Get.find<StorageService>().saveApscvirManifestCache(raw);
  }

  static String? _readAssetStringCache(String assetPath) {
    if (!Get.isRegistered<StorageService>()) return null;
    final raw = Get.find<StorageService>().apscvirHtmlCache(assetPath);
    return raw?.trim().isEmpty == true ? null : raw;
  }

  static Future<void> _saveAssetStringCache(
    String assetPath,
    String raw,
  ) async {
    _assetStringCache[assetPath] = raw;
    if (!Get.isRegistered<StorageService>()) return;
    await Get.find<StorageService>().saveApscvirHtmlCache(assetPath, raw);
  }
}
