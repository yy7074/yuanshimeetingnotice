import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/site_content_model.dart';
import '../services/apscvir_site_service.dart';
import '../theme/app_theme.dart';
import '../utils/apscvir_external_links.dart';
import 'apscvir_content_screen.dart';

class ApscvirSearchScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const ApscvirSearchScreen({super.key, this.onBackToHome});

  @override
  State<ApscvirSearchScreen> createState() => _ApscvirSearchScreenState();
}

class _ApscvirSearchScreenState extends State<ApscvirSearchScreen> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SiteManifest>(
      future: ApscvirSiteService.loadManifest(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final manifest = snapshot.data!;
        const primary = AppColors.primary;
        final hideLogin =
            Get.isRegistered<AuthController>() &&
            Get.find<AuthController>().isLoggedIn;
        final results = _results(manifest, hideLogin: hideLogin);
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  color: primary,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (widget.onBackToHome == null) ...[
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: _goBack,
                              tooltip: 'Back',
                            ),
                            const SizedBox(width: 4),
                          ],
                          const Text(
                            'Search',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        onChanged: (value) => setState(() => _query = value),
                        decoration: InputDecoration(
                          hintText:
                              'Search program, venue, faculty, registration...',
                          prefixIcon: Icon(Icons.search, color: primary),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() => _query = '');
                                  },
                                ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: results.isEmpty
                      ? _SearchEmptyState(query: _query)
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: results.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            final page = results[index];
                            return ListTile(
                              tileColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: primary.withAlpha(32)),
                              ),
                              leading: Icon(Icons.search, color: primary),
                              title: Text(
                                page.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              subtitle: Text(
                                _snippet(page),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Icon(
                                isApscvirVenuePage(page)
                                    ? Icons.open_in_new
                                    : Icons.chevron_right,
                              ),
                              onTap: () => _openSearchResult(page, manifest),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<SitePage> _results(SiteManifest manifest, {required bool hideLogin}) {
    final q = _query.trim().toLowerCase();
    final pages = hideLogin
        ? manifest.pages.where((page) => !_isLoginPage(page)).toList()
        : manifest.pages;
    if (q.isEmpty) return pages;
    return pages.where((page) {
      return page.title.toLowerCase().contains(q) ||
          page.plainText.toLowerCase().contains(q);
    }).toList();
  }

  bool _isLoginPage(SitePage page) {
    return page.title.trim().toLowerCase() == 'log in';
  }

  String _snippet(SitePage page) {
    final text = page.plainText.trim();
    if (text.isEmpty) {
      return 'Saved locally from the official APSCVIR 2026 site.';
    }
    return text.length > 140 ? '${text.substring(0, 140)}...' : text;
  }

  void _goBack() {
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      Get.offAllNamed('/main');
    }
  }
}

void _openSearchResult(SitePage page, SiteManifest manifest) {
  if (isApscvirVenuePage(page)) {
    openApscvirVenueWebsite();
    return;
  }
  Get.to(() => ApscvirContentScreen(page: page, manifest: manifest));
}

class _SearchEmptyState extends StatelessWidget {
  final String query;

  const _SearchEmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.trim().isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 14),
            Text(
              hasQuery ? 'No matching content' : 'No local content available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              hasQuery
                  ? 'Try another APSCVIR 2026 keyword.'
                  : 'The local APSCVIR 2026 content could not be loaded.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
