import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../models/session_model.dart';
import '../models/site_content_model.dart';
import '../services/apscvir_site_service.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';
import '../utils/apscvir_external_links.dart';
import 'apscvir_content_screen.dart' deferred as apscvir_content_screen;
import 'apscvir_maps_screen.dart' deferred as apscvir_maps_screen;

class ApscvirSearchScreen extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const ApscvirSearchScreen({super.key, this.onBackToHome});

  @override
  State<ApscvirSearchScreen> createState() => _ApscvirSearchScreenState();
}

class _ApscvirSearchScreenState extends State<ApscvirSearchScreen> {
  final _controller = TextEditingController();
  late final Future<_SearchData> _searchDataFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchDataFuture = _loadSearchData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_SearchData>(
      future: _searchDataFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        final manifest = data.manifest;
        const primary = AppColors.primary;
        final hideLogin =
            Get.isRegistered<AuthController>() &&
            Get.find<AuthController>().isLoggedIn;
        final results = _results(data, hideLogin: hideLogin);
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
                          hintText: 'Search program, venue, faculty, room...',
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
                            final result = results[index];
                            return ListTile(
                              tileColor: Colors.white,
                              minLeadingWidth: 28,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: primary.withAlpha(32)),
                              ),
                              leading: Icon(
                                result.icon,
                                color: primary,
                                size: 22,
                              ),
                              title: Text(
                                result.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  height: 1.25,
                                ),
                              ),
                              subtitle: Text(
                                result.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.35,
                                ),
                              ),
                              trailing: Icon(
                                result.opensExternal
                                    ? Icons.open_in_new
                                    : Icons.chevron_right,
                                size: 22,
                              ),
                              onTap: () => _openSearchResult(result, manifest),
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

  Future<_SearchData> _loadSearchData() async {
    final manifest = await ApscvirSiteService.loadManifest();
    final sessions = await DataService.getDetailedSessions(
      DataService.apscvir2026EventId,
    );
    final tasks = await DataService.getProgramTasks(
      DataService.apscvir2026EventId,
    );
    return _SearchData(manifest: manifest, sessions: sessions, tasks: tasks);
  }

  List<_SearchResult> _results(_SearchData data, {required bool hideLogin}) {
    final q = _query.trim().toLowerCase();
    final pages = _visibleSearchPages(data.manifest, hideLogin: hideLogin);
    if (q.isEmpty) {
      return pages.map(_pageResult).toList();
    }

    final results = <_SearchResult>[];
    final seen = <String>{};
    void addResult(_SearchResult result) {
      if (seen.add(result.key)) results.add(result);
    }

    for (final task in data.tasks) {
      if (_matchesSession(task, q)) {
        addResult(_taskResult(task));
      }
      if (results.length >= 80) break;
    }

    for (final session in data.sessions) {
      if (_matchesSession(session, q)) {
        addResult(_sessionResult(session));
      }
      if (results.length >= 100) break;
    }

    for (final page in pages) {
      if (page.title.toLowerCase().contains(q) ||
          page.plainText.toLowerCase().contains(q)) {
        addResult(_pageResult(page));
      }
    }

    return results;
  }

  List<SitePage> _visibleSearchPages(
    SiteManifest manifest, {
    required bool hideLogin,
  }) {
    return manifest.pages.where((page) {
      final title = page.title.trim().toLowerCase();
      if (hideLogin && title == 'log in') return false;
      if (title == 'registration' || title == 'visa') return false;
      if (title == 'abstract' || title == 'abstract results') return false;
      if (title == 'grant application') return false;
      return true;
    }).toList();
  }

  bool _matchesSession(SessionModel session, String query) {
    return [
      session.titleEn,
      session.parentSessionTitle,
      session.descriptionEn,
      session.speakerName,
      session.taskPersonName,
      session.speakerTitleEn,
      session.roomEn,
      session.taskRole,
      session.timeRangeStr,
    ].any((value) => value.toLowerCase().contains(query));
  }

  _SearchResult _pageResult(SitePage page) {
    return _SearchResult(
      key: 'page:${page.id}',
      title: page.title,
      subtitle: _pageSnippet(page),
      icon: isApscvirVenuePage(page) ? Icons.open_in_new : Icons.article,
      page: page,
      opensExternal: isApscvirVenuePage(page),
    );
  }

  _SearchResult _sessionResult(SessionModel session) {
    return _SearchResult(
      key: 'session:${session.id}',
      title: session.titleEn,
      subtitle: [
        session.roomEn,
        session.timeRangeStr,
        if (session.speakerName.isNotEmpty &&
            session.speakerName != 'APSCVIR Faculty')
          session.speakerName,
      ].join(' · '),
      icon: Icons.event_note,
      session: session,
    );
  }

  _SearchResult _taskResult(SessionModel session) {
    final person = session.speakerName.isEmpty ? 'TBD' : session.speakerName;
    return _SearchResult(
      key: 'task:${session.id}',
      title: session.titleEn,
      subtitle: [
        session.timeRangeStr,
        session.roomEn,
        person,
        if (session.taskRole.isNotEmpty) session.taskRole,
        if (session.parentSessionTitle.isNotEmpty) session.parentSessionTitle,
      ].join(' · '),
      icon: Icons.assignment_ind,
      session: session,
    );
  }

  String _pageSnippet(SitePage page) {
    final text = page.plainText.trim();
    if (text.isEmpty) {
      return 'Saved locally from the official APSCVIR 2026 site.';
    }
    return text.length > 80 ? '${text.substring(0, 80)}...' : text;
  }

  void _goBack() {
    if (Get.key.currentState?.canPop() == true) {
      Get.back();
    } else {
      Get.offAllNamed('/main');
    }
  }
}

Future<void> _openSearchResult(
  _SearchResult result,
  SiteManifest manifest,
) async {
  final page = result.page;
  if (page != null && isApscvirVenuePage(page)) {
    await apscvir_maps_screen.loadLibrary();
    Get.to(
      () => apscvir_maps_screen.ApscvirMapsScreen(
        manifestFuture: Future.value(manifest),
      ),
    );
    return;
  }
  final session = result.session;
  if (session != null) {
    await apscvir_content_screen.loadLibrary();
    Get.to(
      () => apscvir_content_screen.ApscvirProgramDetailScreen(
        session: session,
      ),
    );
    return;
  }
  if (page != null) {
    await apscvir_content_screen.loadLibrary();
    Get.to(
      () => apscvir_content_screen.ApscvirContentScreen(
        page: page,
        manifest: manifest,
      ),
    );
  }
}

class _SearchData {
  final SiteManifest manifest;
  final List<SessionModel> sessions;
  final List<SessionModel> tasks;

  const _SearchData({
    required this.manifest,
    required this.sessions,
    required this.tasks,
  });
}

class _SearchResult {
  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  final SitePage? page;
  final SessionModel? session;
  final bool opensExternal;

  const _SearchResult({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.page,
    this.session,
    this.opensExternal = false,
  });
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
