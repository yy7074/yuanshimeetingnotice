import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/auth_controller.dart';
import '../controllers/event_controller.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/speaker_controller.dart';
import '../models/session_model.dart';
import '../models/speaker_model.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class EventAgendaScreen extends StatefulWidget {
  const EventAgendaScreen({super.key});

  @override
  State<EventAgendaScreen> createState() => _EventAgendaScreenState();
}

class _EventAgendaScreenState extends State<EventAgendaScreen>
    with SingleTickerProviderStateMixin {
  static const _officialProgramUrl =
      'https://www.apscvir2026.com/en/minisite/program-view/29839';

  late TabController _tabController;
  int _selectedDay = 0;
  Future<List<Map<String, dynamic>>>? _materialsFuture;
  String _materialsEventId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _initialTabIndex,
    );
    _syncSelectedEventFromArguments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = AppColors.primary;
    const Color backgroundColor = AppColors.background;
    const Color surfaceColor = AppColors.surfaceBlue;
    const Color accentColor = AppColors.accentSoft;
    final eventCtrl = Get.find<EventController>();
    final scheduleCtrl = Get.find<ScheduleController>();
    final isZh = Get.locale?.languageCode == '__zh_disabled__';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: _goBackToMain,
        ),
        title: Obx(() {
          final event = eventCtrl.selectedEvent;
          return Text(
            event != null
                ? event.titleEn
                : (isZh ? 'Event Details' : 'Event Details'),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          tabs: [
            Tab(text: isZh ? 'INFO' : 'INFO'),
            Tab(text: isZh ? 'AGENDA' : 'AGENDA'),
            Tab(text: isZh ? 'Speakers' : 'SPEAKERS'),
            Tab(text: isZh ? 'MATERIALS' : 'MATERIALS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(eventCtrl, primaryColor, surfaceColor),
          _buildAgendaTab(
            eventCtrl,
            scheduleCtrl,
            primaryColor,
            surfaceColor,
            accentColor,
          ),
          _buildSpeakersTab(primaryColor, surfaceColor, accentColor),
          _buildMaterialsTab(primaryColor),
        ],
      ),
      bottomNavigationBar: _buildAgendaBottomBar(
        eventCtrl,
        scheduleCtrl,
        primaryColor,
      ),
    );
  }

  Widget _buildAgendaBottomBar(
    EventController eventCtrl,
    ScheduleController scheduleCtrl,
    Color primaryColor,
  ) {
    return AnimatedBuilder(
      animation: _tabController,
      builder: (context, _) {
        if (_tabController.index != 1) return const SizedBox.shrink();
        return Obx(() {
          if (eventCtrl.sessions.isEmpty) return const SizedBox.shrink();
          final isZh = Get.locale?.languageCode == '__zh_disabled__';
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () async {
                  final eventId = eventCtrl.selectedEventId.value;
                  final success = await scheduleCtrl.addAllSessionsFromEvent(
                    eventId,
                  );
                  if (success) {
                    if (!eventCtrl.subscribedEventIds.contains(eventId)) {
                      eventCtrl.subscribedEventIds.add(eventId);
                    }
                    Get.snackbar(
                      isZh ? 'Added' : 'Added',
                      isZh
                          ? 'All sessions added to My Schedule'
                          : 'All sessions added to My Schedule',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: primaryColor,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                    );
                  } else {
                    Get.snackbar(
                      isZh ? 'No Sessions Available' : 'No Sessions Available',
                      isZh
                          ? 'Please view the official program in Materials'
                          : 'Please view the official program in Materials.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.orange.shade700,
                      colorText: Colors.white,
                      margin: const EdgeInsets.all(16),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isZh ? 'Add to My Schedule' : 'Add to My Schedule',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  int get _initialTabIndex {
    final args = Get.arguments;
    if (args is Map && args['initialTab'] is int) {
      final value = args['initialTab'] as int;
      if (value >= 0 && value < 4) {
        return value;
      }
    }
    return 0;
  }

  void _syncSelectedEventFromArguments() {
    final args = Get.arguments;
    if (args is! Map || args['eventId'] is! String) {
      return;
    }

    final eventId = args['eventId'] as String;
    if (eventId.isEmpty) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final eventCtrl = Get.find<EventController>();
      if (eventCtrl.selectedEventId.value == eventId) {
        return;
      }
      eventCtrl.selectEvent(eventId);
    });
  }

  Widget _buildInfoTab(
    EventController eventCtrl,
    Color primaryColor,
    Color surfaceColor,
  ) {
    return Obx(() {
      final event = eventCtrl.selectedEvent;
      if (event == null) {
        return const Center(child: CircularProgressIndicator());
      }
      final isZh = Get.locale?.languageCode == '__zh_disabled__';

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event banner image
            if (event.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  event.imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Title
            Text(
              event.titleEn,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),

            // Info cards
            _buildInfoRow(
              Icons.calendar_today,
              isZh ? 'Date' : 'Date',
              event.dateRangeStr,
              primaryColor,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on,
              isZh ? 'Location' : 'Location',
              event.locationEn,
              primaryColor,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.business,
              isZh ? 'Organizer' : 'Organizer',
              event.organizerEn,
              primaryColor,
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.people,
              isZh ? 'Attendees' : 'Attendees',
              event.maxAttendees > 0
                  ? '${event.currentAttendees} / ${event.maxAttendees}'
                  : '${event.currentAttendees}',
              primaryColor,
            ),
            const SizedBox(height: 20),

            // Tags
            if (event.tags.isNotEmpty) ...[
              Text(
                isZh ? 'Tags' : 'Tags',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: event.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),
            ],

            // Description
            Text(
              isZh ? 'About' : 'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.descriptionEn,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade800,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      );
    });
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    Color primaryColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: primaryColor.withAlpha((0.1 * 255).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: primaryColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
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

  Widget _buildAgendaTab(
    EventController eventCtrl,
    ScheduleController scheduleCtrl,
    Color primaryColor,
    Color surfaceColor,
    Color accentColor,
  ) {
    return Obx(() {
      final totalDays = eventCtrl.totalDays;
      final sessions = eventCtrl.getSessionsForDay(_selectedDay);
      final isZh = Get.locale?.languageCode == '__zh_disabled__';
      final event = eventCtrl.selectedEvent;

      return Column(
        children: [
          // Day selector
          if (totalDays > 1)
            Container(
              color: Colors.white,
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: totalDays,
                itemBuilder: (context, index) {
                  final isSelected = _selectedDay == index;
                  final dayDate = event?.startDate.add(Duration(days: index));
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDay = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      margin: const EdgeInsets.only(
                        right: 8,
                        top: 6,
                        bottom: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? primaryColor
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        dayDate != null
                            ? (isZh
                                  ? 'Day ${index + 1} (${dayDate.month}/${dayDate.day})'
                                  : 'Day ${index + 1} (${dayDate.month}/${dayDate.day})')
                            : 'Day ${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          // Sessions list
          Expanded(
            child: sessions.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_note_outlined,
                            size: 56,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isZh
                                ? 'No sessions scheduled for this day'
                                : 'No sessions scheduled for this day',
                            style: TextStyle(color: Colors.grey.shade500),
                            textAlign: TextAlign.center,
                          ),
                          if (totalDays == 0) ...[
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                              onPressed: _openOfficialProgram,
                              icon: const Icon(Icons.open_in_new, size: 18),
                              label: Text(
                                isZh
                                    ? 'View Official Program'
                                    : 'View Official Program',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      final isSaved = scheduleCtrl.isSaved(session.id);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border(
                            left: BorderSide(
                              color: session.type == SessionType.keynote
                                  ? accentColor
                                  : primaryColor,
                              width: 4,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(
                                (0.05 * 255).round(),
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: session.type == SessionType.keynote
                                        ? accentColor
                                        : surfaceColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    session.typeLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      session.timeRangeStr,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () async {
                                        await scheduleCtrl.toggleSessionModel(
                                          session,
                                        );
                                        if (!eventCtrl.subscribedEventIds
                                            .contains(session.eventId)) {
                                          eventCtrl.subscribedEventIds.add(
                                            session.eventId,
                                          );
                                        }
                                      },
                                      child: Icon(
                                        isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        size: 22,
                                        color: isSaved
                                            ? primaryColor
                                            : Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              session.titleEn,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 14,
                                  color: Colors.grey.shade500,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  session.roomEn,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.shade200,
                                    ),
                                    color: Colors.grey.shade100,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: session.speakerAvatarUrl.isNotEmpty
                                      ? Image.network(
                                          session.speakerAvatarUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                                    Icons.person,
                                                    size: 20,
                                                    color: Colors.grey.shade400,
                                                  ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 20,
                                          color: Colors.grey.shade400,
                                        ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        session.speakerName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                      Text(
                                        session.speakerTitleEn,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  Future<void> _openOfficialProgram() async {
    final uri = Uri.parse(_officialProgramUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showMaterialMessage(
        'Unable to open the official program link',
        isError: true,
      );
    }
  }

  Widget _buildSpeakersTab(
    Color primaryColor,
    Color surfaceColor,
    Color accentColor,
  ) {
    final eventCtrl = Get.find<EventController>();
    final speakerCtrl = Get.find<SpeakerController>();
    final isZh = Get.locale?.languageCode == '__zh_disabled__';

    return Obx(() {
      final speakers = _speakersForSelectedEvent(eventCtrl, speakerCtrl);
      if (speakers.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.groups_2_outlined,
                size: 64,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 16),
              Text(
                isZh
                    ? 'No speakers available for this event'
                    : 'No speakers available for this event',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: speakers.length,
        itemBuilder: (context, index) {
          final speaker = speakers[index];
          return GestureDetector(
            onTap: () => Get.toNamed('/speaker_detail', arguments: speaker),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: surfaceColor.withAlpha((0.5 * 255).round()),
                ),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (speaker.avatarUrl.isNotEmpty) {
                        Get.dialog(
                          Dialog(
                            backgroundColor: Colors.black87,
                            insetPadding: EdgeInsets.zero,
                            child: Stack(
                              children: [
                                Center(
                                  child: InteractiveViewer(
                                    minScale: 0.5,
                                    maxScale: 4.0,
                                    child: Image.network(
                                      speaker.avatarUrl,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.person,
                                                size: 96,
                                                color: Colors.white,
                                              ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 40,
                                  right: 16,
                                  child: IconButton(
                                    onPressed: () => Get.back(),
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          barrierColor: Colors.black87,
                        );
                      }
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: surfaceColor, width: 2),
                        color: Colors.grey.shade100,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: speaker.avatarUrl.isNotEmpty
                          ? Image.network(
                              speaker.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.person,
                                    size: 28,
                                    color: Colors.grey.shade400,
                                  ),
                            )
                          : Icon(
                              Icons.person,
                              size: 28,
                              color: Colors.grey.shade400,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          speaker.nameEn,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          speaker.titleEn,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          speaker.organizationEn,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      speaker.category.labelEn,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  List<SpeakerModel> _speakersForSelectedEvent(
    EventController eventCtrl,
    SpeakerController speakerCtrl,
  ) {
    final speakerIds = eventCtrl.sessions
        .map((session) => session.speakerId)
        .where((speakerId) => speakerId.isNotEmpty)
        .toSet();

    if (speakerIds.isNotEmpty) {
      return speakerCtrl.speakers
          .where((speaker) => speakerIds.contains(speaker.id))
          .toList();
    }

    final speakerNames = eventCtrl.sessions
        .map((session) => session.speakerName.trim().toLowerCase())
        .where((speakerName) => speakerName.isNotEmpty)
        .toSet();

    return speakerCtrl.speakers
        .where(
          (speaker) =>
              speakerNames.contains(speaker.nameEn.trim().toLowerCase()) ||
              speakerNames.contains(speaker.nameZh.trim().toLowerCase()),
        )
        .toList();
  }

  Widget _buildMaterialsTab(Color primaryColor) {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    final eventCtrl = Get.find<EventController>();
    final authCtrl = Get.find<AuthController>();
    final eventId = eventCtrl.selectedEventId.value;

    if (eventId.isEmpty) {
      return Center(
        child: Text(
          isZh
              ? 'Please select an event first'
              : 'Please select an event first',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
        ),
      );
    }

    _ensureMaterialsFuture(eventId);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _materialsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    isZh
                        ? 'Unable to load materials'
                        : 'Unable to load materials',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _refreshMaterials(eventId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(isZh ? 'Retry' : 'Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        final materials = snapshot.data ?? [];
        if (materials.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                Text(
                  isZh ? 'No materials available' : 'No materials available',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }
        final userRole = authCtrl.currentUser.value?.role ?? UserRole.attendee;
        return Column(
          children: [
            // Role access banner
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getRoleBannerColor(
                  userRole,
                ).withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _getRoleBannerColor(
                    userRole,
                  ).withAlpha((0.3 * 255).round()),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _getRoleIcon(userRole),
                    size: 20,
                    color: _getRoleBannerColor(userRole),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getRoleLabel(userRole, isZh),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _getRoleBannerColor(userRole),
                          ),
                        ),
                        Text(
                          _getRoleAccessDesc(userRole, isZh),
                          style: TextStyle(
                            fontSize: 11,
                            color: _getRoleBannerColor(
                              userRole,
                            ).withAlpha((0.8 * 255).round()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  final m = materials[index];
                  final type = (m['type'] as String? ?? 'other').toUpperCase();
                  final fileSize = m['fileSize'] as int? ?? 0;
                  final sizeStr = _formatFileSize(fileSize);
                  final nameEn = m['nameEn'] as String? ?? '';
                  final fileUrl = m['fileUrl'] as String? ?? '';
                  final downloadCount = m['downloadCount'] as int? ?? 0;
                  final visibleTo =
                      m['visibleTo'] as List? ??
                      ['attendee', 'speaker', 'vip', 'admin'];

                  IconData typeIcon;
                  switch (type) {
                    case 'PDF':
                      typeIcon = Icons.picture_as_pdf;
                      break;
                    case 'PPT':
                      typeIcon = Icons.slideshow;
                      break;
                    case 'IMAGE':
                      typeIcon = Icons.image;
                      break;
                    default:
                      typeIcon = Icons.insert_drive_file;
                  }

                  final accessLabel = _getVisibilityLabel(visibleTo, isZh);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: primaryColor.withAlpha((0.1 * 255).round()),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(typeIcon, color: primaryColor),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameEn,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: primaryColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$type • $sizeStr • ${isZh ? '$downloadCount downloads' : '$downloadCount downloads'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              if (accessLabel.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    accessLabel,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Preview button (for images and PDFs)
                            if (type == 'IMAGE' || type == 'PDF')
                              IconButton(
                                icon: Icon(
                                  Icons.visibility,
                                  color: primaryColor,
                                  size: 22,
                                ),
                                onPressed: () async {
                                  if (fileUrl.isEmpty) {
                                    _showMaterialMessage(
                                      isZh
                                          ? 'Material link is unavailable'
                                          : 'Material link is unavailable',
                                      isError: true,
                                    );
                                    return;
                                  }

                                  if (type == 'IMAGE') {
                                    final resolvedUrl = _resolveMaterialUrl(
                                      fileUrl,
                                    );
                                    // Show image in dialog with zoom
                                    Get.dialog(
                                      Dialog(
                                        backgroundColor: Colors.black87,
                                        insetPadding: EdgeInsets.zero,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: InteractiveViewer(
                                                minScale: 0.5,
                                                maxScale: 4.0,
                                                child: Image.network(
                                                  resolvedUrl,
                                                  fit: BoxFit.contain,
                                                  errorBuilder:
                                                      (
                                                        context,
                                                        error,
                                                        stackTrace,
                                                      ) => const Icon(
                                                        Icons.broken_image,
                                                        size: 96,
                                                        color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 40,
                                              right: 16,
                                              child: IconButton(
                                                onPressed: () => Get.back(),
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      barrierColor: Colors.black87,
                                    );
                                  } else {
                                    // Open PDF in browser for preview
                                    final uri = Uri.tryParse(
                                      _resolveMaterialUrl(fileUrl),
                                    );
                                    if (uri != null &&
                                        await canLaunchUrl(uri)) {
                                      await launchUrl(
                                        uri,
                                        mode: LaunchMode.inAppBrowserView,
                                      );
                                    } else {
                                      _showMaterialMessage(
                                        isZh
                                            ? 'Unable to preview this material'
                                            : 'Unable to preview this material',
                                        isError: true,
                                      );
                                    }
                                  }
                                },
                              ),
                            // Download button (existing)
                            IconButton(
                              icon: Icon(Icons.download, color: primaryColor),
                              onPressed: () async {
                                if (fileUrl.isEmpty) {
                                  _showMaterialMessage(
                                    isZh
                                        ? 'Material link is unavailable'
                                        : 'Material link is unavailable',
                                    isError: true,
                                  );
                                  return;
                                }

                                final eventId = eventCtrl.selectedEventId.value;
                                final materialId = m['id'] as String? ?? '';

                                if (_isProtectedMaterial(fileUrl)) {
                                  await _downloadProtectedMaterial(
                                    eventId: eventId,
                                    materialId: materialId,
                                    displayName: nameEn,
                                    fallbackName: fileUrl.split('/').last,
                                  );
                                  return;
                                }

                                final uri = Uri.tryParse(
                                  _resolveMaterialUrl(fileUrl),
                                );
                                if (uri == null || !await canLaunchUrl(uri)) {
                                  _showMaterialMessage(
                                    isZh
                                        ? 'Unable to open download link'
                                        : 'Unable to open download link',
                                    isError: true,
                                  );
                                  return;
                                }

                                try {
                                  final api = Get.find<ApiService>();
                                  await api.trackDownload(eventId, materialId);
                                } catch (_) {}

                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.externalApplication,
                                );
                                _showMaterialMessage(
                                  isZh
                                      ? 'Downloading $nameEn...'
                                      : '$nameEn downloading...',
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getRoleBannerColor(UserRole role) {
    switch (role) {
      case UserRole.vip:
        return AppColors.accent;
      case UserRole.speaker:
        return AppColors.primaryDark;
      case UserRole.admin:
        return AppColors.danger;
      case UserRole.attendee:
        return AppColors.primary;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.vip:
        return Icons.workspace_premium;
      case UserRole.speaker:
        return Icons.record_voice_over;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.attendee:
        return Icons.person;
    }
  }

  String _getRoleLabel(UserRole role, bool isZh) {
    switch (role) {
      case UserRole.vip:
        return isZh ? 'VIP Full Access' : 'VIP — Full Access';
      case UserRole.speaker:
        return isZh
            ? 'Speaker Public + Exclusive'
            : 'Speaker — Public + Exclusive';
      case UserRole.admin:
        return isZh ? 'Admin Full Access' : 'Admin — Full Access';
      case UserRole.attendee:
        return isZh
            ? 'Attendee Public Materials'
            : 'Attendee — Public Materials';
    }
  }

  String _getRoleAccessDesc(UserRole role, bool isZh) {
    switch (role) {
      case UserRole.vip:
        return isZh
            ? 'You can view and download all conference materials.'
            : 'You can view and download all materials';
      case UserRole.speaker:
        return isZh
            ? 'You can view public materials and speaker-only content.'
            : 'You can access public and speaker-exclusive content';
      case UserRole.admin:
        return isZh
            ? 'You can view and manage all conference materials.'
            : 'You can view and manage all materials';
      case UserRole.attendee:
        return isZh
            ? 'You can view public materials. Some content requires higher access.'
            : 'You can access public materials. Some content requires higher access';
    }
  }

  String _getVisibilityLabel(List visibleTo, bool isZh) {
    if (visibleTo.length >= 4) return '';
    if (visibleTo.contains('vip') && visibleTo.length == 1) {
      return isZh ? 'VIP Only' : 'VIP Only';
    }
    if (visibleTo.contains('speaker') && !visibleTo.contains('attendee')) {
      return isZh ? 'Speaker+' : 'Speaker+';
    }
    return '';
  }

  Future<List<Map<String, dynamic>>> _loadMaterials(String eventId) async {
    if (eventId.isEmpty) return [];
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    try {
      final api = Get.find<ApiService>();
      final res = await api.getMaterials(eventId);
      if (res.statusCode == 200 && res.body is List) {
        return (res.body as List)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
      final message = res.body is Map<String, dynamic>
          ? (res.body['message'] as String?)
          : null;
      throw Exception(
        message ??
            (isZh
                ? 'Server did not return materials data'
                : 'Server did not return materials data'),
      );
    } catch (error) {
      if (error is Exception) {
        rethrow;
      }
      throw Exception(
        isZh
            ? 'Network error. Please try again.'
            : 'Network error. Please try again.',
      );
    }
  }

  void _ensureMaterialsFuture(String eventId) {
    if (_materialsEventId == eventId && _materialsFuture != null) {
      return;
    }
    _materialsEventId = eventId;
    _materialsFuture = _loadMaterials(eventId);
  }

  void _refreshMaterials(String eventId) {
    setState(() {
      _materialsEventId = '';
      _materialsFuture = null;
      _ensureMaterialsFuture(eventId);
    });
  }

  void _showMaterialMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError
          ? (Get.locale?.languageCode == '__zh_disabled__'
                ? 'Action Failed'
                : 'Action Failed')
          : (Get.locale?.languageCode == '__zh_disabled__'
                ? 'Processing'
                : 'Processing'),
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: isError ? Colors.red : AppColors.primary,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _resolveMaterialUrl(String fileUrl) {
    if (fileUrl.startsWith('http://') || fileUrl.startsWith('https://')) {
      return fileUrl;
    }

    final apiBaseUri = Uri.tryParse(ApiService.apiBaseUrl);
    if (apiBaseUri == null || apiBaseUri.host.isEmpty) {
      return fileUrl;
    }

    final normalizedPath = fileUrl.startsWith('/') ? fileUrl : '/$fileUrl';
    final origin =
        '${apiBaseUri.scheme}://${apiBaseUri.host}${apiBaseUri.hasPort ? ':${apiBaseUri.port}' : ''}';
    return '$origin$normalizedPath';
  }

  bool _isProtectedMaterial(String fileUrl) {
    final trimmed = fileUrl.trim().replaceAll(RegExp(r'^/+'), '');
    return trimmed.startsWith('uploads/materials/');
  }

  Future<void> _downloadProtectedMaterial({
    required String eventId,
    required String materialId,
    required String displayName,
    required String fallbackName,
  }) async {
    final isZh = Get.locale?.languageCode == '__zh_disabled__';
    if (eventId.isEmpty || materialId.isEmpty) {
      _showMaterialMessage(
        isZh ? 'Material link is unavailable' : 'Material link is unavailable',
        isError: true,
      );
      return;
    }
    _showMaterialMessage(
      isZh ? 'Preparing download...' : 'Preparing download...',
    );
    try {
      final api = Get.find<ApiService>();
      final suggestedName = displayName.isNotEmpty ? displayName : fallbackName;
      final file = await api.downloadMaterialFile(
        eventId,
        materialId,
        suggestedName,
      );
      try {
        await api.trackDownload(eventId, materialId);
      } catch (_) {}
      await Share.shareXFiles([
        XFile(file.path, name: file.uri.pathSegments.last),
      ], subject: isZh ? 'Conference Material' : 'Conference Material');
    } catch (e) {
      _showMaterialMessage(
        isZh ? 'Download failed: $e' : 'Download failed: $e',
        isError: true,
      );
    }
  }
}

void _goBackToMain() {
  if (Get.key.currentState?.canPop() == true) {
    Get.back();
  } else {
    Get.offAllNamed('/main');
  }
}
