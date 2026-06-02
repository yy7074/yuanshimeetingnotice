import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/auth_controller.dart';
import '../models/home_banner_model.dart';
import '../models/site_content_model.dart';
import '../services/api_service.dart';
import '../services/apscvir_site_service.dart';
import '../theme/app_theme.dart';
import '../utils/apscvir_external_links.dart';
import '../widgets/apscvir_asset_image.dart';
import 'apscvir_content_screen.dart' deferred as apscvir_content_screen;
import 'apscvir_maps_screen.dart' deferred as apscvir_maps_screen;
import 'event_portal_screen.dart' deferred as event_portal_screen;
import 'speakers_screen.dart' deferred as speakers_screen;

final SiteMenuItem _ismioHomeMenuItem = SiteMenuItem(
  id: '__ismio_external__',
  title: 'ISMIO',
  url: apscvirIsmioExternalUrl,
  iconClass: '',
  color: AppColors.primary,
  children: const [],
);

class ApscvirHomeScreen extends StatelessWidget {
  const ApscvirHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SiteManifest>(
      future: ApscvirSiteService.loadManifest(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final manifest = snapshot.data!;
        return _HomeContent(manifest: manifest);
      },
    );
  }
}

class _HomeContent extends StatelessWidget {
  final SiteManifest manifest;

  const _HomeContent({required this.manifest});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _TopBar(manifest: manifest),
            Expanded(
              child: Obx(() {
                final menu = _visibleMenuItems(manifest, auth.isLoggedIn);
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _HeroBanner(manifest: manifest)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: const _MyScheduleTile(),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 22),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 2.06,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final item = menu[index];
                          return _MenuTile(
                            item: item,
                            manifest: manifest,
                            index: index,
                          );
                        }, childCount: menu.length),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final SiteManifest manifest;

  const _TopBar({required this.manifest});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Text(
            'APSCVIR 2026',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => _showSiteMenu(context, manifest),
            tooltip: 'Menu',
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatefulWidget {
  final SiteManifest manifest;

  const _HeroBanner({required this.manifest});

  @override
  State<_HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<_HeroBanner> {
  final PageController _pageController = PageController();
  List<HomeBannerModel> _banners = const [];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadBanners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadBanners() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getHomeBanners();
      if (res.statusCode == 200 && res.body is List) {
        final banners =
            (res.body as List)
                .whereType<Map>()
                .map(
                  (item) =>
                      HomeBannerModel.fromJson(Map<String, dynamic>.from(item)),
                )
                .where((banner) => banner.imageUrl.trim().isNotEmpty)
                .toList()
              ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        if (!mounted) return;
        setState(() => _banners = banners);
        _startAutoPlay();
      }
    } catch (_) {}
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (_banners.length < 2) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final next = (_currentIndex + 1) % _banners.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_banners.isNotEmpty) {
      return ColoredBox(
        color: AppColors.primaryDark,
        child: AspectRatio(
          aspectRatio: 3600 / 1998,
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _banners.length,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) {
                  final banner = _banners[index];
                  return _NetworkBannerSlide(banner: banner);
                },
              ),
              if (_banners.length > 1)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_banners.length, (index) {
                      final selected = index == _currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: selected ? 18 : 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white
                              : Colors.white.withAlpha(150),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final image = widget.manifest.homeImages.isNotEmpty
        ? widget.manifest.homeImages.first.asset
        : '';
    if (image.isEmpty) {
      return SizedBox(
        height: 132,
        child: ColoredBox(
          color: AppColors.primaryDark,
          child: _BannerFallback(manifest: widget.manifest),
        ),
      );
    }
    return ColoredBox(
      color: AppColors.primaryDark,
      child: AspectRatio(
        aspectRatio: 3600 / 1998,
        child: ApscvirAssetImage(
          assetPath: image,
          width: double.infinity,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) =>
              _BannerFallback(manifest: widget.manifest),
        ),
      ),
    );
  }
}

class _NetworkBannerSlide extends StatelessWidget {
  final HomeBannerModel banner;

  const _NetworkBannerSlide({required this.banner});

  @override
  Widget build(BuildContext context) {
    final imageUrl = _absoluteImageUrl(banner.imageUrl);
    final title = banner.title.trim();
    final subtitle = banner.subtitle.trim();
    final slide = Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          imageUrl,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) =>
              const ColoredBox(color: AppColors.primaryDark),
        ),
        if (title.isNotEmpty || subtitle.isNotEmpty)
          Positioned(
            left: 18,
            right: 18,
            bottom: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title.isNotEmpty)
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      letterSpacing: 0,
                    ),
                  ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );

    if (banner.linkUrl.trim().isEmpty) return slide;
    return InkWell(onTap: () => _openBannerLink(banner.linkUrl), child: slide);
  }
}

String _absoluteImageUrl(String url) {
  final trimmed = url.trim();
  if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
    return trimmed;
  }
  if (!trimmed.startsWith('/')) return trimmed;
  final base = ApiService.apiBaseUrl.replaceFirst(RegExp(r'/api/v1/?$'), '');
  return '$base$trimmed';
}

Future<void> _openBannerLink(String url) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null || !uri.hasScheme) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class _BannerFallback extends StatelessWidget {
  final SiteManifest manifest;

  const _BannerFallback({required this.manifest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            manifest.conference.shortTitle,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          Text(
            '${manifest.conference.date} · ${manifest.conference.location}',
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MyScheduleTile extends StatelessWidget {
  const _MyScheduleTile();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed('/my_schedule'),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const CustomPaint(
              painter: _TilePatternPainter(dark: false, warm: true),
            ),
            Positioned(
              right: 20,
              top: 18,
              child: Icon(
                Icons.play_arrow_rounded,
                color: Colors.white.withAlpha(38),
                size: 70,
              ),
            ),
            const Center(
              child: Text(
                'My Schedule',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final SiteMenuItem item;
  final SiteManifest manifest;
  final int index;

  const _MenuTile({
    required this.item,
    required this.manifest,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    const background = AppColors.primary;
    const foreground = Colors.white;

    return InkWell(
      onTap: () => _openMenuItem(item, manifest),
      child: Container(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _TilePatternPainter(dark: true)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                children: [
                  _WebsiteMenuIcon(
                    iconClass: item.iconClass,
                    title: item.title,
                    size: 28,
                    color: foreground,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MenuTileTitle(title: item.title, color: foreground),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTileTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _MenuTileTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final displayTitle = _keepMenuWordsTogether(title);
        final fontSize = _fittingFontSize(
          context: context,
          title: displayTitle,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
        );
        return Text(
          displayTitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            height: 1.05,
            letterSpacing: 0,
          ),
        );
      },
    );
  }
}

class _TilePatternPainter extends CustomPainter {
  final bool dark;
  final bool warm;

  const _TilePatternPainter({required this.dark, this.warm = false});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeColor = warm
        ? Colors.white.withAlpha(30)
        : dark
        ? Colors.white.withAlpha(30)
        : AppColors.patternGold.withAlpha(46);
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.save();
    canvas.clipRect(Offset.zero & size);
    _drawLoop(
      canvas,
      paint,
      Offset(-22, size.height * 0.42),
      size.width * 0.55,
    );
    _drawLoop(
      canvas,
      paint,
      Offset(size.width * 0.48, size.height * 0.15),
      size.width * 0.62,
    );

    final diamondPaint = Paint()
      ..color = strokeColor.withAlpha(warm ? 28 : 34)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8;
    for (final y in <double>[-12, 42, 96]) {
      final x = 40.0;
      final path = Path()
        ..moveTo(x, y)
        ..lineTo(x + 26, y + 26)
        ..lineTo(x, y + 52)
        ..lineTo(x - 26, y + 26)
        ..close();
      canvas.drawPath(path, diamondPaint);
    }
    canvas.restore();
  }

  void _drawLoop(Canvas canvas, Paint paint, Offset origin, double width) {
    final height = width * 0.52;
    final path = Path()
      ..moveTo(origin.dx, origin.dy + height * 0.35)
      ..cubicTo(
        origin.dx + width * 0.15,
        origin.dy - height * 0.15,
        origin.dx + width * 0.36,
        origin.dy - height * 0.15,
        origin.dx + width * 0.45,
        origin.dy + height * 0.26,
      )
      ..cubicTo(
        origin.dx + width * 0.58,
        origin.dy + height * 0.88,
        origin.dx + width * 0.78,
        origin.dy + height * 0.9,
        origin.dx + width * 0.88,
        origin.dy + height * 0.48,
      )
      ..cubicTo(
        origin.dx + width * 0.98,
        origin.dy + height * 0.08,
        origin.dx + width * 1.10,
        origin.dy + height * 0.14,
        origin.dx + width * 1.18,
        origin.dy + height * 0.38,
      );
    canvas.drawPath(path, paint);

    canvas.save();
    canvas.translate(6, 7);
    final secondaryPaint = Paint()
      ..color = paint.color.withAlpha(22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, secondaryPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TilePatternPainter oldDelegate) {
    return oldDelegate.dark != dark || oldDelegate.warm != warm;
  }
}

class ApscvirSectionScreen extends StatelessWidget {
  final SiteManifest manifest;
  final SiteMenuItem item;

  const ApscvirSectionScreen({
    super.key,
    required this.manifest,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary;
    final pages = manifest.pageById;
    return Scaffold(
      backgroundColor: AppColors.surfaceBlue,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBackToMain,
          tooltip: 'Back',
        ),
        title: Text(item.title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: item.children.length,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final child = item.children[index];
          final page = pages[child.id];
          return ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: primary.withAlpha(32)),
            ),
            leading: _WebsiteMenuIcon(
              iconClass: child.iconClass,
              title: child.title,
              size: 26,
              color: primary,
            ),
            title: Text(
              child.title,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
            trailing: Icon(
              page != null && isApscvirVenuePage(page)
                  ? Icons.open_in_new
                  : Icons.chevron_right,
            ),
            onTap: page == null ? null : () => _openSitePage(page, manifest),
          );
        },
      ),
    );
  }
}

class _WebsiteMenuIcon extends StatelessWidget {
  final String iconClass;
  final String title;
  final double size;
  final Color color;

  const _WebsiteMenuIcon({
    required this.iconClass,
    required this.title,
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final siteIcon = _siteIconForClass(iconClass);
    if (siteIcon != null) {
      return Icon(siteIcon, size: size, color: color);
    }
    return Icon(_iconForTitle(title), size: size, color: color);
  }
}

void _showSiteMenu(BuildContext context, SiteManifest manifest) {
  const primary = AppColors.primary;
  final auth = Get.find<AuthController>();
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    backgroundColor: Colors.white,
    builder: (_) {
      return SafeArea(
        child: Obx(
          () => ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            children: [
              Text(
                'APSCVIR 2026',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: primary,
                ),
              ),
              const SizedBox(height: 10),
              _ActionRow(
                icon: Icons.event_available_outlined,
                title: 'Conference List',
                onTap: () async {
                  await event_portal_screen.loadLibrary();
                  Get.to(() => event_portal_screen.EventPortalScreen());
                },
              ),
              _ActionRow(
                icon: Icons.groups_outlined,
                title: 'Speaker Directory',
                onTap: () async {
                  await speakers_screen.loadLibrary();
                  Get.to(() => speakers_screen.SpeakersScreen());
                },
              ),
              if (!auth.isLoggedIn)
                _ActionRow(
                  icon: Icons.login,
                  title: 'Log in',
                  onTap: () => Get.toNamed('/login'),
                ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _openMenuItem(SiteMenuItem item, SiteManifest manifest) async {
  if (_isIsmioMenuItem(item)) {
    unawaited(openApscvirIsmioWebsite());
    return;
  }
  if (_isLoginMenuItem(item)) {
    final isLoggedIn =
        Get.isRegistered<AuthController>() &&
        Get.find<AuthController>().isLoggedIn;
    if (!isLoggedIn) {
      Get.toNamed('/login');
    }
    return;
  }
  if (item.children.isNotEmpty) {
    Get.to(() => ApscvirSectionScreen(manifest: manifest, item: item));
    return;
  }
  final page = manifest.pageById[item.id];
  if (page != null) {
    await _openSitePage(page, manifest);
  }
}

Future<void> _openSitePage(SitePage page, SiteManifest manifest) async {
  if (isApscvirVenuePage(page)) {
    await apscvir_maps_screen.loadLibrary();
    Get.to(
      () => apscvir_maps_screen.ApscvirMapsScreen(
        manifestFuture: Future.value(manifest),
      ),
    );
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

List<SiteMenuItem> _visibleMenuItems(SiteManifest manifest, bool isLoggedIn) {
  final menu = manifest.menu
      .where((item) => !_isRegistrationMenuItem(item))
      .where((item) => !_isVisaMenuItem(item))
      .where((item) => !_isLowPriorityHomeItem(item))
      .where((item) => !isLoggedIn || !_isLoginMenuItem(item))
      .toList();
  if (!menu.any(_isIsmioMenuItem)) {
    menu.add(_ismioHomeMenuItem);
  }
  return menu;
}

bool _isIsmioMenuItem(SiteMenuItem item) {
  return item.id == _ismioHomeMenuItem.id ||
      item.title.trim().toLowerCase() == 'ismio';
}

bool _isLoginMenuItem(SiteMenuItem item) {
  return item.title.trim().toLowerCase() == 'log in';
}

bool _isRegistrationMenuItem(SiteMenuItem item) {
  return item.title.trim().toLowerCase() == 'registration';
}

bool _isVisaMenuItem(SiteMenuItem item) {
  return item.title.trim().toLowerCase() == 'visa';
}

bool _isLowPriorityHomeItem(SiteMenuItem item) {
  final title = item.title.trim().toLowerCase();
  return title == 'abstract' ||
      title == 'abstract results' ||
      title == 'grant application';
}

void _goBackToMain() {
  if (Get.key.currentState?.canPop() == true) {
    Get.back();
  } else {
    Get.offAllNamed('/main');
  }
}

double _fittingFontSize({
  required BuildContext context,
  required String title,
  required double maxWidth,
  required double maxHeight,
}) {
  if (maxWidth <= 0 || maxHeight <= 0) return 9;

  const minFontSize = 9.0;
  final maxFontSize = _preferredMenuFontSizeFor(title);
  final textScaler = MediaQuery.textScalerOf(context);
  var low = minFontSize;
  var high = maxFontSize;

  for (var i = 0; i < 8; i += 1) {
    final middle = (low + high) / 2;
    if (_doesMenuTitleFit(
      title: title,
      fontSize: middle,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      textScaler: textScaler,
    )) {
      low = middle;
    } else {
      high = middle;
    }
  }

  return low;
}

double _preferredMenuFontSizeFor(String title) {
  if (title.length > 22) return 15;
  if (title.length > 16) return 16.5;
  return 18;
}

String _keepMenuWordsTogether(String title) {
  return title.replaceAll('-', '\u2011');
}

bool _doesMenuTitleFit({
  required String title,
  required double fontSize,
  required double maxWidth,
  required double maxHeight,
  required TextScaler textScaler,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: title,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: 0,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 2,
    textScaler: textScaler,
  )..layout(maxWidth: maxWidth);

  final lines = painter.computeLineMetrics();
  final lineWidthsFit = lines.every((line) => line.width <= maxWidth + 0.5);
  final wordsFit = title
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .every(
        (word) =>
            _measureMenuTextLine(
              text: word,
              fontSize: fontSize,
              textScaler: textScaler,
            ) <=
            maxWidth + 0.5,
      );
  return !painter.didExceedMaxLines &&
      lineWidthsFit &&
      wordsFit &&
      painter.height <= maxHeight + 0.5;
}

double _measureMenuTextLine({
  required String text,
  required double fontSize,
  required TextScaler textScaler,
}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: 0,
      ),
    ),
    textDirection: TextDirection.ltr,
    maxLines: 1,
    textScaler: textScaler,
  )..layout();
  return painter.width;
}

IconData _iconForTitle(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('ismio')) return Icons.public_outlined;
  if (lower.contains('program')) return Icons.event_note_outlined;
  if (lower.contains('faculty') || lower.contains('committee')) {
    return Icons.groups_outlined;
  }
  if (lower.contains('abstract')) return Icons.article_outlined;
  if (lower.contains('registration')) return Icons.how_to_reg_outlined;
  if (lower.contains('hotel')) return Icons.hotel_outlined;
  if (lower.contains('visa')) return Icons.badge_outlined;
  if (lower.contains('grant')) return Icons.volunteer_activism_outlined;
  if (lower.contains('sponsor')) return Icons.handshake_outlined;
  if (lower.contains('venue') || lower.contains('transport')) {
    return Icons.place_outlined;
  }
  if (lower.contains('suzhou') || lower.contains('tour')) {
    return Icons.travel_explore_outlined;
  }
  if (lower.contains('download')) return Icons.download_outlined;
  if (lower.contains('contact')) return Icons.contact_mail_outlined;
  if (lower.contains('log')) return Icons.login;
  return Icons.info_outline;
}

IconData? _siteIconForClass(String iconClass) {
  final classes = iconClass
      .split(RegExp(r'\s+'))
      .where((item) => item.isNotEmpty);
  for (final className in classes) {
    final medTempIcon = _medTempIcons[className];
    if (medTempIcon != null) {
      return medTempIcon;
    }

    final fontelloIcon = _fontelloIcons[className];
    if (fontelloIcon != null) {
      return fontelloIcon;
    }
  }
  return null;
}

const Map<String, IconData> _medTempIcons = {
  'temp-Beijing01-12': IconData(0xe70b, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-3': IconData(0xe62d, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-5': IconData(0xe62b, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-6': IconData(0xe62a, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-7': IconData(0xe629, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-12': IconData(0xe624, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-29': IconData(0xe613, fontFamily: 'ApscvirMedTemp'),
  'temp-type1-34': IconData(0xe60e, fontFamily: 'ApscvirMedTemp'),
  'temp-type5-3': IconData(0xe6a1, fontFamily: 'ApscvirMedTemp'),
  'temp-type5-22': IconData(0xe69e, fontFamily: 'ApscvirMedTemp'),
  'temp-type5-23': IconData(0xe69f, fontFamily: 'ApscvirMedTemp'),
  'temp-type5-24': IconData(0xe6a0, fontFamily: 'ApscvirMedTemp'),
  'temp-type6-20': IconData(0xe6b9, fontFamily: 'ApscvirMedTemp'),
  'temp-type6-29': IconData(0xe6a4, fontFamily: 'ApscvirMedTemp'),
};

const Map<String, IconData> _fontelloIcons = {
  'icon-fax': IconData(0xe85f, fontFamily: 'ApscvirFontello'),
  'icon-user-2': IconData(0xe8c8, fontFamily: 'ApscvirFontello'),
  'icon-k6': IconData(0xe951, fontFamily: 'ApscvirFontello'),
  'icon-k12': IconData(0xe957, fontFamily: 'ApscvirFontello'),
  'icon-k19': IconData(0xe965, fontFamily: 'ApscvirFontello'),
  'icon-k22': IconData(0xe962, fontFamily: 'ApscvirFontello'),
};

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final FutureOr<void> Function() onTap;

  const _ActionRow({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Get.back();
        onTap();
      },
    );
  }
}
