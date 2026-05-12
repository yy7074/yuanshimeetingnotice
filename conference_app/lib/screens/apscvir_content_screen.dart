import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/event_controller.dart';
import '../controllers/schedule_controller.dart';
import '../models/session_model.dart';
import '../models/site_content_model.dart';
import '../services/data_service.dart';
import '../theme/app_theme.dart';

class ApscvirContentScreen extends StatelessWidget {
  final SitePage page;
  final SiteManifest manifest;

  const ApscvirContentScreen({
    super.key,
    required this.page,
    required this.manifest,
  });

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary;
    final blocks = _contentBlocksFor(page);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goBack,
          tooltip: 'Back',
        ),
        title: Text(
          page.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _PageHeader(page: page, primary: primary),
          if (_canAddPageToSchedule(page) && page.id != '1814796') ...[
            const SizedBox(height: 12),
            _AddProgramToScheduleCard(primary: primary),
          ],
          const SizedBox(height: 16),
          if (page.id == '1411159')
            _OrganizingCommitteeContent(primary: primary)
          else if (page.id == '1814796')
            _ProgramAtGlanceContent(primary: primary)
          else if (page.id == '1411179')
            _FacultyContent(page: page, primary: primary)
          else if (page.id == '1411162')
            _HotelReservationContent(page: page, primary: primary)
          else if (page.id == '1411158')
            _VisaContent(primary: primary)
          else if (page.id == '1411172')
            _DownloadCenterContent(primary: primary)
          else if (blocks.isEmpty)
            _EmptyPageCard(primary: primary)
          else
            ...blocks.map(
              (block) => _ContentBlock(block: block, primary: primary),
            ),
          if (page.downloads.isNotEmpty) ...[
            const SizedBox(height: 12),
            _DownloadsCard(downloads: page.downloads, primary: primary),
          ],
        ],
      ),
    );
  }
}

bool _canAddPageToSchedule(SitePage page) {
  final title = page.title.toLowerCase();
  return title.contains('program') || title.contains('schedule');
}

List<SiteBlock> _contentBlocksFor(SitePage page) {
  final blockImageAssets = {
    for (final block in page.blocks)
      if (block.type == 'image' && block.asset.isNotEmpty) block.asset,
  };
  final missingImageBlocks = page.images
      .where(
        (image) =>
            image.asset.isNotEmpty && !blockImageAssets.contains(image.asset),
      )
      .map(
        (image) => SiteBlock(
          type: 'image',
          text: '',
          asset: image.asset,
          alt: image.alt,
          rows: const [],
        ),
      );

  return [...missingImageBlocks, ...page.blocks];
}

void _goBack() {
  if (Get.key.currentState?.canPop() == true) {
    Get.back();
  } else {
    Get.offAllNamed('/main');
  }
}

class _PageHeader extends StatelessWidget {
  final SitePage page;
  final Color primary;

  const _PageHeader({required this.page, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(45)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary.withAlpha(20),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_iconForTitle(page.title), color: primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'APSCVIR 2026',
                  style: TextStyle(
                    fontSize: 12,
                    color: primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContentBlock extends StatelessWidget {
  final SiteBlock block;
  final Color primary;

  const _ContentBlock({required this.block, required this.primary});

  @override
  Widget build(BuildContext context) {
    switch (block.type) {
      case 'heading':
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 18, 4, 8),
          child: Text(
            block.text,
            style: TextStyle(
              fontSize: 19,
              height: 1.25,
              fontWeight: FontWeight.w900,
              color: primary,
            ),
          ),
        );
      case 'image':
        if (block.asset.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ColoredBox(
              color: Colors.white,
              child: Image.asset(
                block.asset,
                fit: BoxFit.contain,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    _ImageFallback(primary: primary),
              ),
            ),
          ),
        );
      case 'table':
        return _TableBlock(rows: block.rows, primary: primary);
      default:
        if (block.text.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 4, 8),
          child: Text(
            block.text,
            style: const TextStyle(
              fontSize: 15,
              height: 1.55,
              color: AppColors.inkSoft,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    }
  }
}

class _TableBlock extends StatelessWidget {
  final List<List<String>> rows;
  final Color primary;

  const _TableBlock({required this.rows, required this.primary});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStatePropertyAll(primary.withAlpha(18)),
          columns: [
            for (var i = 0; i < rows.first.length; i++)
              DataColumn(
                label: Text(
                  rows.first[i],
                  style: TextStyle(color: primary, fontWeight: FontWeight.w800),
                ),
              ),
          ],
          rows: [
            for (final row in rows.skip(1))
              DataRow(
                cells: [
                  for (var i = 0; i < rows.first.length; i++)
                    DataCell(Text(i < row.length ? row[i] : '')),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _OrganizingCommitteeContent extends StatelessWidget {
  final Color primary;

  const _OrganizingCommitteeContent({required this.primary});

  static const _portraitAsset =
      'assets/apscvir2026/images/organizing-committee-01-20240110230430-15331-276a808372.png';
  static const _bulletAsset =
      'assets/apscvir2026/images/organizing-committee-02-20250624171034-49945-380e68e5bb.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CommitteeInfoSection(
          primary: primary,
          title: 'Organization',
          lines: const [
            'International Society of Multidisciplinary Interventional Oncology (ISMIO)',
            'Beijing Research Association for Chronic Diseases Control and Health Education',
            'Asia-Pacific Society of Cardiovascular and Interventional Radiology (APSCVIR)',
          ],
          lineColor: const Color(0xFF337FE5),
        ),
        const SizedBox(height: 14),
        _CommitteeInfoSection(
          primary: primary,
          title: 'Host Organizational Members',
          lines: const [
            'Chinese Society of Interventional Radiology (CSIR)',
            'Chinese College of Interventionalists (CCI)',
          ],
          lineColor: AppColors.ink,
        ),
        const SizedBox(height: 14),
        _OrganizingChairCard(
          primary: primary,
          portraitAsset: _portraitAsset,
          bulletAsset: _bulletAsset,
        ),
      ],
    );
  }
}

class _FacultyContent extends StatefulWidget {
  final SitePage page;
  final Color primary;

  const _FacultyContent({required this.page, required this.primary});

  @override
  State<_FacultyContent> createState() => _FacultyContentState();
}

class _FacultyContentState extends State<_FacultyContent> {
  late final Future<List<_FacultyMember>> _membersFuture;
  String _query = '';
  String _selectedLetter = '';

  @override
  void initState() {
    super.initState();
    _membersFuture = _loadFacultyMembers(widget.page);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_FacultyMember>>(
      future: _membersFuture,
      builder: (context, snapshot) {
        final members = snapshot.data ?? const <_FacultyMember>[];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _FacultyLoadingCard(primary: widget.primary);
        }
        if (members.isEmpty) {
          return _EmptyPageCard(primary: widget.primary);
        }

        final visibleMembers = _filterMembers(members);
        final letters = _facultyLetters(members);
        final grouped = _groupFacultyByLetter(visibleMembers);
        final rows = _facultyRows(grouped);
        final listHeight = MediaQuery.sizeOf(context).height - 230;

        return SizedBox(
          height: listHeight < 440 ? 440 : listHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _FacultySummaryCard(
                primary: widget.primary,
                total: members.length,
                visible: visibleMembers.length,
              ),
              const SizedBox(height: 12),
              _FacultySearchField(
                primary: widget.primary,
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 12),
              _FacultyLetterStrip(
                primary: widget.primary,
                letters: letters,
                selectedLetter: _selectedLetter,
                onSelected: (letter) =>
                    setState(() => _selectedLetter = letter),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: visibleMembers.isEmpty
                    ? _FacultyNoResultsCard(primary: widget.primary)
                    : ListView.builder(
                        primary: false,
                        itemCount: rows.length,
                        itemBuilder: (context, index) {
                          final row = rows[index];
                          if (row.letter != null) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _FacultyGroupHeader(
                                letter: row.letter!,
                                primary: widget.primary,
                              ),
                            );
                          }
                          return _FacultyMemberCard(
                            member: row.member!,
                            primary: widget.primary,
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_FacultyMember> _filterMembers(List<_FacultyMember> members) {
    final query = _query.trim().toLowerCase();
    return members.where((member) {
      final matchesLetter =
          _selectedLetter.isEmpty || member.letter == _selectedLetter;
      final matchesQuery =
          query.isEmpty ||
          member.name.toLowerCase().contains(query) ||
          member.organization.toLowerCase().contains(query);
      return matchesLetter && matchesQuery;
    }).toList();
  }
}

class _FacultySummaryCard extends StatelessWidget {
  final Color primary;
  final int total;
  final int visible;

  const _FacultySummaryCard({
    required this.primary,
    required this.total,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withAlpha(18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.groups_outlined, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$visible / $total Faculty',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Search or filter by surname initial.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultySearchField extends StatelessWidget {
  final Color primary;
  final ValueChanged<String> onChanged;

  const _FacultySearchField({required this.primary, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search faculty, hospital, country...',
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.muted),
        prefixIcon: Icon(Icons.search, color: primary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 13),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary.withAlpha(45)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}

class _FacultyLetterStrip extends StatelessWidget {
  final Color primary;
  final List<String> letters;
  final String selectedLetter;
  final ValueChanged<String> onSelected;

  const _FacultyLetterStrip({
    required this.primary,
    required this.letters,
    required this.selectedLetter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = ['', ...letters];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(35)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            for (final letter in items)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _FacultyLetterButton(
                  label: letter.isEmpty ? 'All' : letter,
                  selected: letter == selectedLetter,
                  primary: primary,
                  onTap: () => onSelected(letter),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FacultyLetterButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color primary;
  final VoidCallback onTap;

  const _FacultyLetterButton({
    required this.label,
    required this.selected,
    required this.primary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? primary : primary.withAlpha(14),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: SizedBox(
          height: 34,
          width: label == 'All' ? 48 : 34,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : primary,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FacultyGroupHeader extends StatelessWidget {
  final String letter;
  final Color primary;

  const _FacultyGroupHeader({required this.letter, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Divider(color: primary.withAlpha(50))),
      ],
    );
  }
}

class _FacultyMemberCard extends StatelessWidget {
  final _FacultyMember member;
  final Color primary;

  const _FacultyMemberCard({required this.member, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: primary,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () =>
              Get.to(() => _ApscvirFacultyDetailScreen(member: member)),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _FacultyAvatar(member: member, primary: primary, size: 58),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.white.withAlpha(90),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        member.organization,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.white, size: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FacultyAvatar extends StatelessWidget {
  final _FacultyMember member;
  final Color primary;
  final double size;

  const _FacultyAvatar({
    required this.member,
    required this.primary,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: member.avatarAsset.isEmpty
          ? _FacultyInitial(member: member, primary: primary)
          : Image.asset(
              member.avatarAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  _FacultyInitial(member: member, primary: primary),
            ),
    );
  }
}

class _FacultyInitial extends StatelessWidget {
  final _FacultyMember member;
  final Color primary;

  const _FacultyInitial({required this.member, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        member.initial,
        style: TextStyle(
          color: primary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _FacultyLoadingCard extends StatelessWidget {
  final Color primary;

  const _FacultyLoadingCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: primary),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Loading faculty...',
              style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyNoResultsCard extends StatelessWidget {
  final Color primary;

  const _FacultyNoResultsCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: const Text(
        'No matching faculty found.',
        style: TextStyle(
          color: AppColors.inkSoft,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ApscvirFacultyDetailScreen extends StatelessWidget {
  final _FacultyMember member;

  const _ApscvirFacultyDetailScreen({required this.member});

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary;
    final officialUrl =
        'https://www.apscvir2026.com/en/minisite/speaker-detail/29839'
        '?user_id=${member.userId}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Faculty Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primary.withAlpha(45)),
            ),
            child: Column(
              children: [
                _FacultyAvatar(member: member, primary: primary, size: 104),
                const SizedBox(height: 14),
                Text(
                  member.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 24,
                    height: 1.15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  member.organization,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 14,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primary.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProgramDetailInfoRow(
                  icon: Icons.sort_by_alpha,
                  label: 'Index',
                  value: member.letter,
                  primary: primary,
                ),
                if (member.country.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _ProgramDetailInfoRow(
                    icon: Icons.public,
                    label: 'Country / Region',
                    value: member.country,
                    primary: primary,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: primary.withAlpha(12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primary.withAlpha(35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.link, color: primary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: SelectableText(
                    officialUrl,
                    style: const TextStyle(
                      color: AppColors.inkSoft,
                      fontSize: 12,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacultyMember {
  final String userId;
  final String name;
  final String organization;
  final String letter;
  final String avatarAsset;

  const _FacultyMember({
    required this.userId,
    required this.name,
    required this.organization,
    required this.letter,
    required this.avatarAsset,
  });

  String get initial =>
      name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();

  String get country {
    final parts = organization
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.length < 2 ? '' : parts.last;
  }
}

class _FacultyListRow {
  final String? letter;
  final _FacultyMember? member;

  const _FacultyListRow.header(this.letter) : member = null;

  const _FacultyListRow.member(this.member) : letter = null;
}

Future<List<_FacultyMember>> _loadFacultyMembers(SitePage page) async {
  try {
    final html = await rootBundle.loadString(page.htmlAsset);
    return _parseFacultyMembers(html, page.images);
  } catch (_) {
    return const [];
  }
}

List<_FacultyMember> _parseFacultyMembers(String html, List<SiteImage> images) {
  final assetsBySource = {
    for (final image in images)
      _normalizeFacultySource(image.source): image.asset,
  };
  final defaultAsset = images
      .map((image) => image.asset)
      .firstWhere(
        (asset) => asset.contains('person-default'),
        orElse: () => '',
      );
  final items = <_FacultyMember>[];
  final itemPattern = RegExp(
    r'<li\b(?=[^>]*mui-indexed-list-item)([\s\S]*?)</li>',
  );

  for (final match in itemPattern.allMatches(html)) {
    final itemHtml = match.group(0) ?? '';
    final attrs = RegExp(r'<li\b([^>]*)>').firstMatch(itemHtml)?.group(1) ?? '';
    final userId = _htmlAttr(attrs, 'data-user_id');
    final dataValue = _htmlAttr(attrs, 'data-value').toUpperCase();
    final name = _cleanProgramHtmlText(
      RegExp(
            r'<h2\b[^>]*talker-name[^>]*>([\s\S]*?)</h2>',
          ).firstMatch(itemHtml)?.group(1) ??
          '',
    );
    final organization = _cleanProgramHtmlText(
      RegExp(
            r'<p\b[^>]*talker-unit[^>]*>([\s\S]*?)</p\s*>',
          ).firstMatch(itemHtml)?.group(1) ??
          '',
    );
    if (name.isEmpty) continue;

    final imageSource = _htmlAttr(itemHtml, 'data-original').isNotEmpty
        ? _htmlAttr(itemHtml, 'data-original')
        : _htmlAttr(itemHtml, 'src');
    final normalizedSource = _normalizeFacultySource(imageSource);
    final avatarAsset =
        assetsBySource[normalizedSource] ??
        (normalizedSource.contains('person-default') ? defaultAsset : '');
    final letter = dataValue.isNotEmpty
        ? dataValue[0]
        : name.trim().characters.first.toUpperCase();

    items.add(
      _FacultyMember(
        userId: userId,
        name: name,
        organization: organization,
        letter: RegExp(r'^[A-Z]$').hasMatch(letter) ? letter : '#',
        avatarAsset: avatarAsset,
      ),
    );
  }

  items.sort((a, b) {
    final letterCompare = a.letter.compareTo(b.letter);
    if (letterCompare != 0) return letterCompare;
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return items;
}

Map<String, List<_FacultyMember>> _groupFacultyByLetter(
  List<_FacultyMember> members,
) {
  final grouped = <String, List<_FacultyMember>>{};
  for (final member in members) {
    grouped.putIfAbsent(member.letter, () => []).add(member);
  }
  return grouped;
}

List<_FacultyListRow> _facultyRows(Map<String, List<_FacultyMember>> grouped) {
  final rows = <_FacultyListRow>[];
  for (final entry in grouped.entries) {
    rows.add(_FacultyListRow.header(entry.key));
    rows.addAll(entry.value.map(_FacultyListRow.member));
  }
  return rows;
}

List<String> _facultyLetters(List<_FacultyMember> members) {
  final letters = members.map((member) => member.letter).toSet().toList()
    ..sort();
  return letters;
}

String _htmlAttr(String html, String name) {
  final match = RegExp(
    "${RegExp.escape(name)}=[\"']([^\"']*)[\"']",
  ).firstMatch(html);
  return _decodeHtmlEntities(match?.group(1) ?? '');
}

String _normalizeFacultySource(String source) {
  return _decodeHtmlEntities(source).trim();
}

String _decodeHtmlEntities(String value) {
  return value
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'")
      .replaceAll('&rsquo;', "'")
      .replaceAll('&lsquo;', "'")
      .replaceAll('&ldquo;', '"')
      .replaceAll('&rdquo;', '"')
      .replaceAllMapped(RegExp(r'&#(\d+);'), (match) {
        final codePoint = int.tryParse(match.group(1) ?? '');
        return codePoint == null
            ? match.group(0)!
            : String.fromCharCode(codePoint);
      })
      .replaceAllMapped(RegExp(r'&#x([0-9a-fA-F]+);'), (match) {
        final codePoint = int.tryParse(match.group(1) ?? '', radix: 16);
        return codePoint == null
            ? match.group(0)!
            : String.fromCharCode(codePoint);
      });
}

class _HotelReservationContent extends StatelessWidget {
  final SitePage page;
  final Color primary;

  const _HotelReservationContent({required this.page, required this.primary});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_HotelReservation>>(
      future: _loadHotelReservations(page),
      builder: (context, snapshot) {
        final hotels = snapshot.data ?? const <_HotelReservation>[];
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _HotelLoadingCard(primary: primary);
        }
        if (hotels.isEmpty) {
          return _EmptyPageCard(primary: primary);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HotelReservationIntro(primary: primary, hotelCount: hotels.length),
            const SizedBox(height: 12),
            for (final hotel in hotels) ...[
              _HotelReservationCard(hotel: hotel, primary: primary),
              const SizedBox(height: 12),
            ],
          ],
        );
      },
    );
  }
}

class _HotelReservationIntro extends StatelessWidget {
  final Color primary;
  final int hotelCount;

  const _HotelReservationIntro({
    required this.primary,
    required this.hotelCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withAlpha(18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.hotel_outlined, color: primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$hotelCount Partner Hotels',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Book directly through the official third-party hotel links for APSCVIR 2026 rates.',
                  style: TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelReservationCard extends StatelessWidget {
  final _HotelReservation hotel;
  final Color primary;

  const _HotelReservationCard({required this.hotel, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hotel.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.25,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (hotel.brand.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          hotel.brand,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (hotel.stars.isNotEmpty)
                  Text(
                    hotel.stars,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HotelInfoRow(
                  icon: Icons.place_outlined,
                  label: 'Address',
                  value: hotel.address,
                  primary: primary,
                ),
                const SizedBox(height: 12),
                _HotelRateSection(
                  title: 'Room Rates',
                  lines: hotel.roomRates,
                  primary: primary,
                ),
                if (hotel.buffetRates.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _HotelRateSection(
                    title: 'Buffet Rates',
                    lines: hotel.buffetRates,
                    primary: primary,
                  ),
                ],
                if (hotel.distances.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _HotelDistanceSection(
                    distances: hotel.distances,
                    primary: primary,
                  ),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchHotelBooking(hotel),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Book Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color primary;

  const _HotelInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 13,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HotelRateSection extends StatelessWidget {
  final String title;
  final List<_HotelLineItem> lines;
  final Color primary;

  const _HotelRateSection({
    required this.title,
    required this.lines,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: primary, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      line.label,
                      style: const TextStyle(
                        color: AppColors.inkSoft,
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      line.value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.danger,
                        fontSize: 12,
                        height: 1.3,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HotelDistanceSection extends StatelessWidget {
  final List<_HotelLineItem> distances;
  final Color primary;

  const _HotelDistanceSection({required this.distances, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Distance Information',
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          for (final distance in distances)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _HotelInfoRow(
                icon: Icons.route_outlined,
                label: distance.label,
                value: distance.value,
                primary: primary,
              ),
            ),
        ],
      ),
    );
  }
}

class _HotelLoadingCard extends StatelessWidget {
  final Color primary;

  const _HotelLoadingCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: primary),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Loading hotel reservation options...',
              style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelReservation {
  final String name;
  final String brand;
  final String stars;
  final String address;
  final String bookingUrl;
  final List<_HotelLineItem> roomRates;
  final List<_HotelLineItem> buffetRates;
  final List<_HotelLineItem> distances;

  const _HotelReservation({
    required this.name,
    required this.brand,
    required this.stars,
    required this.address,
    required this.bookingUrl,
    required this.roomRates,
    required this.buffetRates,
    required this.distances,
  });
}

class _HotelLineItem {
  final String label;
  final String value;

  const _HotelLineItem({required this.label, required this.value});
}

Future<List<_HotelReservation>> _loadHotelReservations(SitePage page) async {
  try {
    final html = await rootBundle.loadString(page.htmlAsset);
    return _parseHotelReservations(html);
  } catch (_) {
    return const [];
  }
}

List<_HotelReservation> _parseHotelReservations(String html) {
  final starts = RegExp(
    r'<div class="hotel-card">',
  ).allMatches(html).map((match) => match.start).toList();
  if (starts.isEmpty) return const [];

  final styleStart = html.indexOf('<style>', starts.first);
  final cards = <String>[];
  for (var i = 0; i < starts.length; i++) {
    final start = starts[i];
    final end = i + 1 < starts.length
        ? starts[i + 1]
        : (styleStart > start ? styleStart : html.length);
    cards.add(html.substring(start, end));
  }

  final hotels = <_HotelReservation>[];
  for (final card in cards) {
    final name = _classText(card, 'hotel-name');
    final bookingUrl = _normalizedHotelBookingUrl(
      _htmlAttr(_bookButtonTag(card), 'href'),
    );
    if (name.isEmpty || bookingUrl.isEmpty) continue;

    final infoItems = _hotelInfoItems(card);
    final address = infoItems
        .firstWhere(
          (item) => item.label.toLowerCase().startsWith('address'),
          orElse: () => const _HotelLineItem(label: 'Address', value: ''),
        )
        .value;
    final distances = infoItems
        .where((item) => !item.label.toLowerCase().startsWith('address'))
        .toList();
    final priceItems = _hotelPriceItems(card);
    final roomRates = priceItems.take(2).toList();
    final buffetRates = priceItems.skip(2).take(2).toList();

    hotels.add(
      _HotelReservation(
        name: name,
        brand: _classText(card, 'hotel-brand'),
        stars: _classText(card, 'hotel-stars'),
        address: address,
        bookingUrl: bookingUrl,
        roomRates: roomRates,
        buffetRates: buffetRates,
        distances: distances,
      ),
    );
  }
  return hotels;
}

String _classText(String html, String className) {
  final match = RegExp(
    '<div\\b[^>]*class="$className"[^>]*>([\\s\\S]*?)</div>',
  ).firstMatch(html);
  return _cleanProgramHtmlText(match?.group(1) ?? '');
}

String _bookButtonTag(String html) {
  return RegExp(r'<a\b(?=[^>]*book-button)[^>]*>').firstMatch(html)?.group(0) ??
      '';
}

List<_HotelLineItem> _hotelPriceItems(String html) {
  return RegExp(
        r'<div class="price-item">\s*<span>([\s\S]*?)</span>\s*<span class="price-value">([\s\S]*?)</span>',
      )
      .allMatches(html)
      .map((match) {
        return _HotelLineItem(
          label: _cleanHotelLabel(match.group(1) ?? ''),
          value: _cleanProgramHtmlText(match.group(2) ?? ''),
        );
      })
      .where((item) => item.label.isNotEmpty || item.value.isNotEmpty)
      .toList();
}

List<_HotelLineItem> _hotelInfoItems(String html) {
  return RegExp(
        r'<div class="info-item">\s*<span class="info-label">([\s\S]*?)</span>\s*<span\b[^>]*>([\s\S]*?)</span>',
      )
      .allMatches(html)
      .map((match) {
        return _HotelLineItem(
          label: _cleanHotelLabel(match.group(1) ?? ''),
          value: _cleanProgramHtmlText(match.group(2) ?? ''),
        );
      })
      .where((item) => item.label.isNotEmpty || item.value.isNotEmpty)
      .toList();
}

String _cleanHotelLabel(String value) {
  return _cleanProgramHtmlText(
    value,
  ).replaceAll(RegExp(r'\s+'), ' ').replaceAll(':', '').trim();
}

String _normalizedHotelBookingUrl(String url) {
  final decoded = _decodeHtmlEntities(url).trim();
  final uri = Uri.tryParse(decoded);
  if (uri == null) return decoded;
  if (uri.host.contains('safelinks.protection.outlook.com')) {
    final target = uri.queryParameters['url'];
    if (target != null && target.trim().isNotEmpty) {
      return target.trim();
    }
  }
  return decoded;
}

Future<void> _launchHotelBooking(_HotelReservation hotel) async {
  final uri = Uri.tryParse(hotel.bookingUrl);
  if (uri == null || !uri.hasScheme) {
    _showHotelLaunchError(hotel);
    return;
  }

  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    _showHotelLaunchError(hotel);
  }
}

void _showHotelLaunchError(_HotelReservation hotel) {
  Get.snackbar(
    'Unable to Open Booking',
    hotel.name,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.orange.shade700,
    colorText: Colors.white,
    margin: const EdgeInsets.all(16),
  );
}

class _VisaContent extends StatelessWidget {
  final Color primary;

  const _VisaContent({required this.primary});

  static const _regions = [
    _VisaRegion(
      name: 'Europe',
      count: 40,
      countries:
          'Albania, Austria, Belarus, Belgium, Bosnia and Herzegovina, Bulgaria, Croatia, Cyprus, Czech Republic, Denmark, Estonia, Finland, France, Germany, Greece, Hungary, Iceland, Ireland, Italy, Latvia, Lithuania, Luxembourg, Malta, Monaco, Montenegro, the Netherlands, North Macedonia, Norway, Poland, Portugal, Romania, Russia, Serbia, Slovakia, Slovenia, Spain, Sweden, Switzerland, Ukraine, United Kingdom',
    ),
    _VisaRegion(
      name: 'North America',
      count: 2,
      countries: 'Canada, United States',
    ),
    _VisaRegion(
      name: 'South America',
      count: 4,
      countries: 'Argentina, Brazil, Chile, Mexico',
    ),
    _VisaRegion(name: 'Oceania', count: 2, countries: 'Australia, New Zealand'),
    _VisaRegion(
      name: 'Asia',
      count: 7,
      countries:
          'Brunei, Indonesia, Japan, Qatar, Singapore, South Korea, United Arab Emirates',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _VisaSummaryCard(primary: primary),
        const SizedBox(height: 12),
        _VisaRulesCard(primary: primary),
        const SizedBox(height: 12),
        for (final region in _regions) ...[
          _VisaRegionCard(region: region, primary: primary),
          const SizedBox(height: 10),
        ],
        _VisaOfficialLinkCard(primary: primary),
      ],
    );
  }
}

class _VisaSummaryCard extends StatelessWidget {
  final Color primary;

  const _VisaSummaryCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.badge_outlined, color: primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'China’s 240-hour Visa-Free Transit Policy Coverage to 55 Countries',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 18,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Nationals of eligible countries who transit through China to third countries or regions may enter visa-free through designated open ports and stay in permitted areas for no more than 10 days, provided they hold valid international travel documents and onward tickets with confirmed seats and departure dates.',
            style: TextStyle(
              color: AppColors.inkSoft,
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisaRulesCard extends StatelessWidget {
  final Color primary;

  const _VisaRulesCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    final rules = const [
      _VisaRule(
        icon: Icons.public,
        title: '55 countries',
        value: 'Eligible nationalities',
      ),
      _VisaRule(
        icon: Icons.flight_takeoff,
        title: 'Transit only',
        value: 'To third countries or regions',
      ),
      _VisaRule(
        icon: Icons.schedule,
        title: '240 hours',
        value: 'No more than 10 days',
      ),
      _VisaRule(
        icon: Icons.assignment_turned_in_outlined,
        title: 'Visa required',
        value: 'Work, study, and news reporting',
      ),
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final rule in rules) _VisaRuleChip(rule: rule, primary: primary),
        ],
      ),
    );
  }
}

class _VisaRuleChip extends StatelessWidget {
  final _VisaRule rule;
  final Color primary;

  const _VisaRuleChip({required this.rule, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width < 380 ? double.infinity : 170,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlue,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(rule.icon, color: primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: TextStyle(
                    color: primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rule.value,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 11,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisaRegionCard extends StatelessWidget {
  final _VisaRegion region;
  final Color primary;

  const _VisaRegionCard({required this.region, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(38)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(color: primary, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${region.name} (${region.count} countries)',
                  style: TextStyle(
                    color: primary,
                    fontSize: 15,
                    height: 1.25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  region.countries,
                  style: const TextStyle(
                    color: AppColors.inkSoft,
                    fontSize: 13,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisaOfficialLinkCard extends StatelessWidget {
  final Color primary;

  const _VisaOfficialLinkCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    const url = 'https://en.nia.gov.cn/n147418/n147463/c183412/content.html';
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withAlpha(12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'For more details, please refer to the National Immigration Administration page.',
            style: TextStyle(
              color: AppColors.inkSoft,
              fontSize: 13,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () => _launchVisaOfficialPage(url),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open Official Visa Policy'),
              style: OutlinedButton.styleFrom(
                foregroundColor: primary,
                side: BorderSide(color: primary.withAlpha(150)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VisaRegion {
  final String name;
  final int count;
  final String countries;

  const _VisaRegion({
    required this.name,
    required this.count,
    required this.countries,
  });
}

class _VisaRule {
  final IconData icon;
  final String title;
  final String value;

  const _VisaRule({
    required this.icon,
    required this.title,
    required this.value,
  });
}

Future<void> _launchVisaOfficialPage(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    Get.snackbar(
      'Unable to Open Visa Policy',
      url,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}

class _CommitteeInfoSection extends StatelessWidget {
  final Color primary;
  final String title;
  final List<String> lines;
  final Color lineColor;

  const _CommitteeInfoSection({
    required this.primary,
    required this.title,
    required this.lines,
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 3,
              margin: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: primary,
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (final line in lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          line,
                          style: TextStyle(
                            color: lineColor,
                            fontSize: 14,
                            height: 1.45,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrganizingChairCard extends StatelessWidget {
  final Color primary;
  final String portraitAsset;
  final String bulletAsset;

  const _OrganizingChairCard({
    required this.primary,
    required this.portraitAsset,
    required this.bulletAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: primary,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: const Text(
              'Organizing Chair\nGao-Jun Teng, Acad. CAS, FSIR, FCIRSE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image.asset(
                    portraitAsset,
                    width: 106,
                    height: 106,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _ImageFallback(primary: primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CommitteeBullet(
                        bulletAsset: bulletAsset,
                        text: 'Academician of the Chinese Academy of Sciences',
                      ),
                      _CommitteeBullet(
                        bulletAsset: bulletAsset,
                        text:
                            'President of the Chinese College of Interventionalists (CCI)',
                      ),
                      _CommitteeBullet(
                        bulletAsset: bulletAsset,
                        text:
                            'Former President of Chinese Society of Interventional Radiology (CSIR)',
                      ),
                      _CommitteeBullet(
                        bulletAsset: bulletAsset,
                        text:
                            'Former President of Asia-Pacific Society of Cardiovascular and Interventional Radiology (APSCVIR) (2016-2018)',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommitteeBullet extends StatelessWidget {
  final String bulletAsset;
  final String text;

  const _CommitteeBullet({required this.bulletAsset, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Image.asset(
              bulletAsset,
              width: 8,
              height: 8,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Container(width: 8, height: 8, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 13,
                height: 1.45,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramAtGlanceContent extends StatefulWidget {
  final Color primary;

  const _ProgramAtGlanceContent({required this.primary});

  @override
  State<_ProgramAtGlanceContent> createState() =>
      _ProgramAtGlanceContentState();
}

class _ProgramAtGlanceContentState extends State<_ProgramAtGlanceContent> {
  late final Future<List<SessionModel>> _sessionsFuture;
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _sessionsFuture = DataService.getDetailedSessions(
      DataService.apscvir2026EventId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fallbackSessions = DataService.getSessions(
      DataService.apscvir2026EventId,
    );
    return FutureBuilder<List<SessionModel>>(
      future: _sessionsFuture,
      initialData: fallbackSessions,
      builder: (context, snapshot) {
        final allSessions = _mergeProgramAtGlanceMetadata(
          snapshot.data ?? fallbackSessions,
          fallbackSessions,
        );
        final daySessions = allSessions
            .where((session) => session.dayIndex == _selectedDayIndex)
            .toList();
        final rooms = _groupSessionsByRoom(daySessions);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProgramDateStrip(
              primary: widget.primary,
              selectedDayIndex: _selectedDayIndex,
              onSelected: (dayIndex) {
                setState(() => _selectedDayIndex = dayIndex);
              },
            ),
            const SizedBox(height: 14),
            if (rooms.isEmpty)
              _ProgramEmptyDayCard(
                primary: widget.primary,
                isLoading: snapshot.connectionState == ConnectionState.waiting,
              )
            else
              for (final entry in rooms.entries) ...[
                _ProgramRoomCard(
                  primary: widget.primary,
                  room: entry.key,
                  sessions: entry.value,
                ),
                const SizedBox(height: 12),
              ],
          ],
        );
      },
    );
  }

  Map<String, List<SessionModel>> _groupSessionsByRoom(
    List<SessionModel> sessions,
  ) {
    final grouped = <String, List<SessionModel>>{};
    for (final session in sessions) {
      grouped.putIfAbsent(session.roomEn, () => []).add(session);
    }
    for (final roomSessions in grouped.values) {
      roomSessions.sort((a, b) => a.startTime.compareTo(b.startTime));
    }
    return grouped;
  }

  List<SessionModel> _mergeProgramAtGlanceMetadata(
    List<SessionModel> sessions,
    List<SessionModel> programAtGlanceSessions,
  ) {
    final officialSessionsByKey = {
      for (final session in programAtGlanceSessions)
        _programSessionKey(session): session,
    };
    return [
      for (final session in sessions)
        officialSessionsByKey[_programSessionKey(session)] ?? session,
    ];
  }

  String _programSessionKey(SessionModel session) {
    return [
      session.dayIndex,
      session.roomEn.trim().toLowerCase(),
      session.timeRangeStr.replaceAll(' ', ''),
      session.titleEn.trim().toLowerCase(),
    ].join('|');
  }
}

class _ProgramDateStrip extends StatelessWidget {
  final Color primary;
  final int selectedDayIndex;
  final ValueChanged<int> onSelected;

  const _ProgramDateStrip({
    required this.primary,
    required this.selectedDayIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final dates = const [
      _ProgramDate(index: 0, month: 'Jun', day: '11', weekday: 'Thu'),
      _ProgramDate(index: 1, month: 'Jun', day: '12', weekday: 'Fri'),
      _ProgramDate(index: 2, month: 'Jun', day: '13', weekday: 'Sat'),
      _ProgramDate(index: 3, month: 'Jun', day: '14', weekday: 'Sun'),
    ];

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(45)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < dates.length; i++) ...[
            Expanded(
              child: _ProgramDatePill(
                date: dates[i],
                primary: primary,
                selected: dates[i].index == selectedDayIndex,
                onTap: () => onSelected(dates[i].index),
              ),
            ),
            if (i != dates.length - 1) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _ProgramDate {
  final int index;
  final String month;
  final String day;
  final String weekday;

  const _ProgramDate({
    required this.index,
    required this.month,
    required this.day,
    required this.weekday,
  });
}

class _ProgramDatePill extends StatelessWidget {
  final _ProgramDate date;
  final Color primary;
  final bool selected;
  final VoidCallback onTap;

  const _ProgramDatePill({
    required this.date,
    required this.primary,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? Colors.white : primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: selected ? primary : primary.withAlpha(14),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primary.withAlpha(selected ? 0 : 45)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.month,
                style: TextStyle(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date.day,
                style: TextStyle(
                  color: foreground,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date.weekday,
                style: TextStyle(
                  color: selected ? Colors.white70 : AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramEmptyDayCard extends StatelessWidget {
  final Color primary;
  final bool isLoading;

  const _ProgramEmptyDayCard({required this.primary, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          if (isLoading) ...[
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2, color: primary),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              isLoading
                  ? 'Loading sessions for this date...'
                  : 'No sessions are available for this date.',
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 14,
                height: 1.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramRoomCard extends StatelessWidget {
  final Color primary;
  final String room;
  final List<SessionModel> sessions;

  const _ProgramRoomCard({
    required this.primary,
    required this.room,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: primary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: Text(
              room,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
            child: Column(
              children: [
                for (final session in sessions)
                  _ProgramSessionTile(primary: primary, session: session),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramSessionTile extends StatelessWidget {
  final Color primary;
  final SessionModel session;

  const _ProgramSessionTile({required this.primary, required this.session});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surfaceBlue,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.border),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () =>
                Get.to(() => ApscvirProgramDetailScreen(session: session)),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 5,
                    decoration: BoxDecoration(
                      color: primary,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 15, color: primary),
                          const SizedBox(width: 5),
                          Text(
                            session.timeRangeStr,
                            style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: primary.withAlpha(180),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        session.titleEn,
                        style: const TextStyle(
                          color: AppColors.ink,
                          fontSize: 15,
                          height: 1.3,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (session.speakerName.isNotEmpty &&
                          session.speakerName != 'APSCVIR Faculty') ...[
                        const SizedBox(height: 6),
                        Text(
                          session.speakerName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ApscvirProgramDetailScreen extends StatefulWidget {
  final SessionModel session;

  const ApscvirProgramDetailScreen({super.key, required this.session});

  @override
  State<ApscvirProgramDetailScreen> createState() =>
      _ApscvirProgramDetailScreenState();
}

class _ApscvirProgramDetailScreenState
    extends State<ApscvirProgramDetailScreen> {
  late final Future<List<_ProgramDetailAgendaItem>> _agendaFuture;

  @override
  void initState() {
    super.initState();
    _agendaFuture = _loadProgramDetailAgenda(widget.session);
  }

  @override
  Widget build(BuildContext context) {
    const primary = AppColors.primary;
    final session = widget.session;
    final officialUrl = _officialProgramUrl(session);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Session Details',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProgramDetailHeader(session: session, primary: primary),
            const SizedBox(height: 12),
            _ProgramDetailInfoCard(session: session, primary: primary),
            if (_hasFacultyText(session)) ...[
              const SizedBox(height: 12),
              _ProgramDetailFacultyCard(session: session, primary: primary),
            ],
            const SizedBox(height: 12),
            _ProgramDetailScheduleButton(session: session, primary: primary),
            if (officialUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ProgramDetailOfficialCard(url: officialUrl, primary: primary),
            ],
            const SizedBox(height: 12),
            FutureBuilder<List<_ProgramDetailAgendaItem>>(
              future: _agendaFuture,
              builder: (context, snapshot) {
                final agenda =
                    snapshot.data ?? const <_ProgramDetailAgendaItem>[];
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _ProgramDetailLoadingCard(primary: primary);
                }
                if (agenda.isEmpty) {
                  return _ProgramDetailEmptyAgendaCard(primary: primary);
                }
                return _ProgramDetailAgendaCard(
                  agenda: agenda,
                  primary: primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramDetailHeader extends StatelessWidget {
  final SessionModel session;
  final Color primary;

  const _ProgramDetailHeader({required this.session, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: primary.withAlpha(18),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              session.typeLabel,
              style: TextStyle(
                color: primary,
                fontSize: 11,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            session.titleEn,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 21,
              height: 1.25,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramDetailInfoCard extends StatelessWidget {
  final SessionModel session;
  final Color primary;

  const _ProgramDetailInfoCard({required this.session, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        children: [
          _ProgramDetailInfoRow(
            icon: Icons.calendar_today,
            label: 'Date',
            value: _formatSessionDate(session.startTime),
            primary: primary,
          ),
          const SizedBox(height: 12),
          _ProgramDetailInfoRow(
            icon: Icons.schedule,
            label: 'Time',
            value: session.timeRangeStr,
            primary: primary,
          ),
          const SizedBox(height: 12),
          _ProgramDetailInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Room',
            value: session.roomEn,
            primary: primary,
          ),
        ],
      ),
    );
  }
}

class _ProgramDetailInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color primary;

  const _ProgramDetailInfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: primary.withAlpha(16),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primary, size: 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 15,
                  height: 1.3,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgramDetailFacultyCard extends StatelessWidget {
  final SessionModel session;
  final Color primary;

  const _ProgramDetailFacultyCard({
    required this.session,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final names = session.speakerName
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faculty',
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final name in names)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBlue,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgramDetailScheduleButton extends StatelessWidget {
  final SessionModel session;
  final Color primary;

  const _ProgramDetailScheduleButton({
    required this.session,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ScheduleController>()) {
      return const SizedBox.shrink();
    }
    final scheduleCtrl = Get.find<ScheduleController>();
    return Obx(() {
      final saved = scheduleCtrl.isSaved(session.id);
      return SizedBox(
        height: 46,
        child: ElevatedButton.icon(
          onPressed: () async {
            await scheduleCtrl.toggleSessionModel(session);
            final nowSaved = scheduleCtrl.isSaved(session.id);
            Get.snackbar(
              nowSaved ? 'Added to My Schedule' : 'Removed from My Schedule',
              session.titleEn,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: primary,
              colorText: Colors.white,
              margin: const EdgeInsets.all(16),
            );
          },
          icon: Icon(saved ? Icons.bookmark_remove : Icons.bookmark_add),
          label: Text(saved ? 'Remove from My Schedule' : 'Add to My Schedule'),
          style: ElevatedButton.styleFrom(
            backgroundColor: saved ? AppColors.inkSoft : primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      );
    });
  }
}

class _ProgramDetailOfficialCard extends StatelessWidget {
  final String url;
  final Color primary;

  const _ProgramDetailOfficialCard({required this.url, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: primary.withAlpha(12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.link, color: primary, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              url,
              style: const TextStyle(
                color: AppColors.inkSoft,
                fontSize: 12,
                height: 1.35,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramDetailLoadingCard extends StatelessWidget {
  final Color primary;

  const _ProgramDetailLoadingCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2, color: primary),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Loading session agenda...',
              style: TextStyle(
                color: AppColors.inkSoft,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgramDetailEmptyAgendaCard extends StatelessWidget {
  final Color primary;

  const _ProgramDetailEmptyAgendaCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: const Text(
        'No detailed sub-session agenda is available locally yet.',
        style: TextStyle(
          color: AppColors.inkSoft,
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProgramDetailAgendaCard extends StatelessWidget {
  final List<_ProgramDetailAgendaItem> agenda;
  final Color primary;

  const _ProgramDetailAgendaCard({required this.agenda, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Agenda',
            style: TextStyle(
              color: primary,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < agenda.length; i++) ...[
            _ProgramDetailAgendaRow(item: agenda[i], primary: primary),
            if (i != agenda.length - 1)
              Divider(height: 18, color: AppColors.border.withAlpha(120)),
          ],
        ],
      ),
    );
  }
}

class _ProgramDetailAgendaRow extends StatelessWidget {
  final _ProgramDetailAgendaItem item;
  final Color primary;

  const _ProgramDetailAgendaRow({required this.item, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            item.time,
            style: TextStyle(
              color: primary,
              fontSize: 12,
              height: 1.3,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.topic,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 14,
                  height: 1.35,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (item.speaker.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  item.organization.isEmpty
                      ? item.speaker
                      : '${item.speaker}\n${item.organization}',
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 12,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgramDetailAgendaItem {
  final String time;
  final String topic;
  final String speaker;
  final String organization;

  const _ProgramDetailAgendaItem({
    required this.time,
    required this.topic,
    required this.speaker,
    required this.organization,
  });
}

bool _hasFacultyText(SessionModel session) {
  return session.speakerName.isNotEmpty &&
      session.speakerName != 'APSCVIR Faculty';
}

String _formatSessionDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return '${months[date.month - 1]} ${date.day}, ${date.year} '
      '(${weekdays[date.weekday - 1]})';
}

String _officialProgramUrl(SessionModel session) {
  final programId = _officialProgramId(session);
  if (programId.isEmpty) return '';
  return 'https://www.apscvir2026.com/en/minisite/program-detail/29839'
      '?program_id=$programId';
}

String _officialProgramId(SessionModel session) {
  const prefix = 'apscvir-2026-';
  if (!session.id.startsWith(prefix)) return '';
  final programId = session.id.substring(prefix.length);
  return RegExp(r'^\d+$').hasMatch(programId) ? programId : '';
}

Future<List<_ProgramDetailAgendaItem>> _loadProgramDetailAgenda(
  SessionModel session,
) async {
  try {
    final html = await rootBundle.loadString(
      'assets/apscvir2026/site/pages/1814797-detailed-program.html',
    );
    return _parseProgramDetailAgenda(html, session);
  } catch (_) {
    return const [];
  }
}

List<_ProgramDetailAgendaItem> _parseProgramDetailAgenda(
  String html,
  SessionModel session,
) {
  final section = _findProgramDetailSection(html, session);
  if (section.isEmpty) return const [];

  final wrapperStarts = RegExp(
    r'<div class="program-style-content-wrapper">',
  ).allMatches(section).map((match) => match.start).toList();
  if (wrapperStarts.isEmpty) return const [];

  final items = <_ProgramDetailAgendaItem>[];
  for (var i = 0; i < wrapperStarts.length; i++) {
    final start = wrapperStarts[i];
    final end = i + 1 < wrapperStarts.length
        ? wrapperStarts[i + 1]
        : section.length;
    final wrapper = section.substring(start, end);
    final time = _cleanProgramHtmlText(
      RegExp(
            r'<div class="time common">([\s\S]*?)</div>',
          ).firstMatch(wrapper)?.group(1) ??
          '',
    );
    final topic = _cleanProgramHtmlText(
      RegExp(
            r'<div class="type">[\s\S]*?<p>([\s\S]*?)</p>',
          ).firstMatch(wrapper)?.group(1) ??
          '',
    );
    final speaker = _cleanProgramHtmlText(
      RegExp(r'<a\b[^>]*>([\s\S]*?)</a>').firstMatch(wrapper)?.group(1) ?? '',
    );
    final organization = _cleanProgramHtmlText(
      RegExp(
            r'<span class="td-org">([\s\S]*?)</span>',
          ).firstMatch(wrapper)?.group(1) ??
          '',
    );

    if (time.isEmpty && topic.isEmpty && speaker.isEmpty) continue;
    items.add(
      _ProgramDetailAgendaItem(
        time: time,
        topic: topic.isEmpty ? 'TBD' : topic,
        speaker: speaker,
        organization: organization,
      ),
    );
  }

  return items;
}

String _findProgramDetailSection(String html, SessionModel session) {
  final lowerHtml = html.toLowerCase();
  final lowerTitle = session.titleEn.toLowerCase();
  var searchFrom = 0;
  var titleOnlySection = '';

  while (searchFrom < lowerHtml.length) {
    final titleIndex = lowerHtml.indexOf(lowerTitle, searchFrom);
    if (titleIndex < 0) break;

    final sectionStart = lowerHtml.lastIndexOf(
      '<div class="program-style-title',
      titleIndex,
    );
    if (sectionStart < 0) {
      searchFrom = titleIndex + lowerTitle.length;
      continue;
    }

    final sectionEnd = _nextPositiveIndex([
      lowerHtml.indexOf('<div class="program-style-title', sectionStart + 1),
      lowerHtml.indexOf('<div class="program-style-place"', sectionStart + 1),
      lowerHtml.indexOf('<div class="program-style-time"', sectionStart + 1),
    ], html.length);
    final section = html.substring(sectionStart, sectionEnd);
    final sectionText = _compactProgramText(_cleanProgramHtmlText(section));
    if (sectionText.contains(_compactProgramText(session.titleEn))) {
      titleOnlySection = section;
      if (sectionText.contains(_compactProgramText(session.timeRangeStr))) {
        return section;
      }
    }

    searchFrom = titleIndex + lowerTitle.length;
  }

  return titleOnlySection;
}

int _nextPositiveIndex(List<int> indexes, int fallback) {
  final positives = indexes.where((index) => index > 0).toList()..sort();
  return positives.isEmpty ? fallback : positives.first;
}

String _compactProgramText(String value) {
  return value.toLowerCase().replaceAll(RegExp(r'\s+'), '');
}

String _cleanProgramHtmlText(String value) {
  return value
      .replaceAll(RegExp(r'<!--[\s\S]*?-->'), ' ')
      .replaceAll(RegExp(r'<[^>]+>'), ' ')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&rsquo;', "'")
      .replaceAll('&lsquo;', "'")
      .replaceAll('&ldquo;', '"')
      .replaceAll('&rdquo;', '"')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

Future<void> _shareLocalAsset({
  required String assetPath,
  required String label,
}) async {
  try {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    );
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${_safeFileName(assetPath)}');
    await file.writeAsBytes(bytes, flush: true);
    await Share.shareXFiles([XFile(file.path)], text: label);
  } catch (_) {
    Get.snackbar(
      'File Unavailable',
      'This local file could not be opened.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}

String _safeFileName(String assetPath) {
  final raw = assetPath.split('/').last.trim();
  final safe = raw.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
  return safe.isEmpty ? 'apscvir-download' : safe;
}

const _downloadCenterItems = [
  _DownloadCenterFile(
    title: 'Poster Template Download',
    date: '2026/01/21 14:15:06',
    thumbnailAsset:
        'assets/apscvir2026/images/download-center-01-2026012114135281027954163-85d88862d0.png',
    downloadAsset:
        'assets/apscvir2026/files/abstract-results-file-12-2026011612540371016584932-cdb76d459a.pptx',
    label: 'APSCVIR 2026 Poster Template',
  ),
  _DownloadCenterFile(
    title: 'PowerPoint Templates Download',
    date: '2025/09/08 13:43:18',
    thumbnailAsset:
        'assets/apscvir2026/images/download-center-02-2025090813425917869531024-ace71f351d.jpg',
    downloadAsset:
        'assets/apscvir2026/files/abstract-results-file-11-2026011523030913765941028-dd610fbb04.pptx',
    label: 'APSCVIR 2026 PowerPoint Template',
  ),
];

class _DownloadCenterFile {
  final String title;
  final String date;
  final String thumbnailAsset;
  final String downloadAsset;
  final String label;

  const _DownloadCenterFile({
    required this.title,
    required this.date,
    required this.thumbnailAsset,
    required this.downloadAsset,
    required this.label,
  });
}

class _DownloadCenterContent extends StatelessWidget {
  final Color primary;

  const _DownloadCenterContent({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primary.withAlpha(40)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: primary.withAlpha(18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.download_outlined, color: primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Tap a template to download or share the local file.',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final item in _downloadCenterItems)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _DownloadCenterTile(item: item, primary: primary),
          ),
      ],
    );
  }
}

class _DownloadCenterTile extends StatelessWidget {
  final _DownloadCenterFile item;
  final Color primary;

  const _DownloadCenterTile({required this.item, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () =>
            _shareLocalAsset(assetPath: item.downloadAsset, label: item.label),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: primary.withAlpha(40)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.thumbnailAsset,
                  width: 76,
                  height: 76,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 76,
                    height: 76,
                    color: primary.withAlpha(16),
                    child: Icon(Icons.insert_drive_file, color: primary),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 15,
                        height: 1.25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.date,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.file_download_outlined,
                          color: primary,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Download PPTX',
                          style: TextStyle(
                            color: primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadsCard extends StatelessWidget {
  final List<SiteDownload> downloads;
  final Color primary;

  const _DownloadsCard({required this.downloads, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Downloads',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: primary,
            ),
          ),
          const SizedBox(height: 10),
          for (final item in downloads)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.file_download_outlined, color: primary),
              title: Text(
                item.label,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                'Saved locally - ${_safeFileName(item.asset)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () =>
                  _shareLocalAsset(assetPath: item.asset, label: item.label),
            ),
        ],
      ),
    );
  }
}

class _AddProgramToScheduleCard extends StatelessWidget {
  final Color primary;

  const _AddProgramToScheduleCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.accentSoft.withAlpha(90),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.playlist_add_check, color: primary),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Save the APSCVIR 2026 program to My Schedule.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: _addProgram,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addProgram() async {
    final scheduleCtrl = Get.find<ScheduleController>();
    final success = await scheduleCtrl.addAllSessionsFromEvent(
      DataService.apscvir2026EventId,
    );

    if (success && Get.isRegistered<EventController>()) {
      final eventCtrl = Get.find<EventController>();
      if (!eventCtrl.subscribedEventIds.contains(
        DataService.apscvir2026EventId,
      )) {
        eventCtrl.subscribedEventIds.add(DataService.apscvir2026EventId);
      }
    }

    Get.snackbar(
      success ? 'Added' : 'No Sessions Available',
      success
          ? 'APSCVIR 2026 sessions were added to My Schedule.'
          : 'The local APSCVIR program could not be loaded.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: success ? primary : Colors.orange.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }
}

class _EmptyPageCard extends StatelessWidget {
  final Color primary;

  const _EmptyPageCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primary.withAlpha(40)),
      ),
      child: Text(
        'This page is saved locally. Structured content was not available from the source page.',
        style: TextStyle(color: Colors.grey.shade700, height: 1.5),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  final Color primary;

  const _ImageFallback({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      color: primary.withAlpha(18),
      alignment: Alignment.center,
      child: Icon(Icons.image_not_supported_outlined, color: primary),
    );
  }
}

IconData _iconForTitle(String title) {
  final lower = title.toLowerCase();
  if (lower.contains('schedule') || lower.contains('program')) {
    return Icons.event_note_outlined;
  }
  if (lower.contains('faculty') || lower.contains('committee')) {
    return Icons.groups_outlined;
  }
  if (lower.contains('registration')) return Icons.how_to_reg_outlined;
  if (lower.contains('hotel')) return Icons.hotel_outlined;
  if (lower.contains('visa')) return Icons.badge_outlined;
  if (lower.contains('venue') || lower.contains('transport')) {
    return Icons.place_outlined;
  }
  if (lower.contains('download')) return Icons.download_outlined;
  if (lower.contains('contact')) return Icons.contact_mail_outlined;
  if (lower.contains('sponsor')) return Icons.handshake_outlined;
  if (lower.contains('abstract')) return Icons.article_outlined;
  return Icons.info_outline;
}
