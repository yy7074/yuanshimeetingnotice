import 'package:flutter/material.dart';

class SiteManifest {
  final ConferenceInfo conference;
  final List<SiteImage> homeImages;
  final List<SiteMenuItem> menu;
  final List<SitePage> pages;

  SiteManifest({
    required this.conference,
    required this.homeImages,
    required this.menu,
    required this.pages,
  });

  factory SiteManifest.fromJson(Map<String, dynamic> json) {
    return SiteManifest(
      conference: ConferenceInfo.fromJson(json['conference'] ?? {}),
      homeImages: ((json['homeImages'] as List?) ?? [])
          .map((item) => SiteImage.fromJson(item))
          .toList(),
      menu: ((json['menu'] as List?) ?? [])
          .map((item) => SiteMenuItem.fromJson(item))
          .toList(),
      pages: ((json['pages'] as List?) ?? [])
          .map((item) => SitePage.fromJson(item))
          .toList(),
    );
  }

  Map<String, SitePage> get pageById => {
    for (final page in pages) page.id: page,
  };

  List<SiteMenuItem> get flattenedMenu {
    final result = <SiteMenuItem>[];
    for (final item in menu) {
      if (pageById.containsKey(item.id)) {
        result.add(item);
      }
      result.addAll(
        item.children.where((child) => pageById.containsKey(child.id)),
      );
    }
    return result;
  }
}

class ConferenceInfo {
  final String title;
  final String shortTitle;
  final String date;
  final String venue;
  final String location;
  final String sourceUrl;
  final SiteTheme theme;

  ConferenceInfo({
    required this.title,
    required this.shortTitle,
    required this.date,
    required this.venue,
    required this.location,
    required this.sourceUrl,
    required this.theme,
  });

  factory ConferenceInfo.fromJson(Map<String, dynamic> json) {
    return ConferenceInfo(
      title: json['title'] ?? '',
      shortTitle: json['shortTitle'] ?? '',
      date: json['date'] ?? '',
      venue: json['venue'] ?? '',
      location: json['location'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      theme: SiteTheme.fromJson(json['theme'] ?? {}),
    );
  }
}

class SiteTheme {
  final Color primary;
  final Color primaryDark;
  final Color background;

  SiteTheme({
    required this.primary,
    required this.primaryDark,
    required this.background,
  });

  factory SiteTheme.fromJson(Map<String, dynamic> json) {
    return SiteTheme(
      primary: colorFromHex(json['primary'] ?? '#0A92A2'),
      primaryDark: colorFromHex(json['primaryDark'] ?? '#0D6F7D'),
      background: colorFromHex(json['background'] ?? '#EAF7FF'),
    );
  }
}

class SiteMenuItem {
  final String id;
  final String title;
  final String url;
  final String iconClass;
  final Color color;
  final List<SiteMenuItem> children;

  SiteMenuItem({
    required this.id,
    required this.title,
    required this.url,
    required this.iconClass,
    required this.color,
    required this.children,
  });

  factory SiteMenuItem.fromJson(Map<String, dynamic> json) {
    return SiteMenuItem(
      id: '${json['id'] ?? ''}',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      iconClass: json['iconClass'] ?? '',
      color: colorFromHex(json['color'] ?? '#0A92A2'),
      children: ((json['children'] as List?) ?? [])
          .map((item) => SiteMenuItem.fromJson(item))
          .toList(),
    );
  }
}

class SitePage {
  final String id;
  final String title;
  final String url;
  final String htmlAsset;
  final Color color;
  final List<SiteImage> images;
  final List<SiteDownload> downloads;
  final List<SiteBlock> blocks;
  final String plainText;

  SitePage({
    required this.id,
    required this.title,
    required this.url,
    required this.htmlAsset,
    required this.color,
    required this.images,
    required this.downloads,
    required this.blocks,
    required this.plainText,
  });

  factory SitePage.fromJson(Map<String, dynamic> json) {
    return SitePage(
      id: '${json['id'] ?? ''}',
      title: json['title'] ?? '',
      url: json['url'] ?? '',
      htmlAsset: json['htmlAsset'] ?? '',
      color: colorFromHex(json['color'] ?? '#0A92A2'),
      images: ((json['images'] as List?) ?? [])
          .map((item) => SiteImage.fromJson(item))
          .toList(),
      downloads: ((json['downloads'] as List?) ?? [])
          .map((item) => SiteDownload.fromJson(item))
          .toList(),
      blocks: ((json['blocks'] as List?) ?? [])
          .map((item) => SiteBlock.fromJson(item))
          .toList(),
      plainText: json['plainText'] ?? '',
    );
  }
}

class SiteImage {
  final String asset;
  final String source;
  final String alt;
  final String error;

  SiteImage({
    required this.asset,
    required this.source,
    required this.alt,
    required this.error,
  });

  factory SiteImage.fromJson(Map<String, dynamic> json) {
    return SiteImage(
      asset: json['asset'] ?? '',
      source: json['source'] ?? '',
      alt: json['alt'] ?? '',
      error: json['error'] ?? '',
    );
  }
}

class SiteDownload {
  final String asset;
  final String source;
  final String label;

  SiteDownload({
    required this.asset,
    required this.source,
    required this.label,
  });

  factory SiteDownload.fromJson(Map<String, dynamic> json) {
    return SiteDownload(
      asset: json['asset'] ?? '',
      source: json['source'] ?? '',
      label: json['label'] ?? 'Download',
    );
  }
}

class SiteBlock {
  final String type;
  final String text;
  final String asset;
  final String alt;
  final List<List<String>> rows;

  SiteBlock({
    required this.type,
    required this.text,
    required this.asset,
    required this.alt,
    required this.rows,
  });

  factory SiteBlock.fromJson(Map<String, dynamic> json) {
    return SiteBlock(
      type: json['type'] ?? 'paragraph',
      text: json['text'] ?? '',
      asset: json['asset'] ?? '',
      alt: json['alt'] ?? '',
      rows: ((json['rows'] as List?) ?? [])
          .map((row) => ((row as List?) ?? []).map((cell) => '$cell').toList())
          .toList(),
    );
  }
}

Color colorFromHex(String value) {
  final normalized = value.replaceAll('#', '').trim();
  final parsed = int.tryParse(
    normalized.length == 6 ? 'FF$normalized' : normalized,
    radix: 16,
  );
  return Color(parsed ?? 0xFF0A92A2);
}
