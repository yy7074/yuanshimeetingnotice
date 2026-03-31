import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../controllers/schedule_controller.dart';
import '../controllers/speaker_controller.dart';
import '../models/session_model.dart';
import '../models/speaker_model.dart';

class EventAgendaScreen extends StatefulWidget {
  const EventAgendaScreen({super.key});

  @override
  State<EventAgendaScreen> createState() => _EventAgendaScreenState();
}

class _EventAgendaScreenState extends State<EventAgendaScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDay = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color backgroundColor = Color(0xFFF3FAFF);
    const Color surfaceColor = Color(0xFFDBF1FE);
    const Color accentColor = Color(0xFFFFDEA5);
    final eventCtrl = Get.find<EventController>();
    final scheduleCtrl = Get.find<ScheduleController>();
    final isZh = Get.locale?.languageCode == 'zh';

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Get.back(),
        ),
        title: Obx(() {
          final event = eventCtrl.selectedEvent;
          return Text(
            event != null
                ? (isZh ? event.titleZh : event.titleEn)
                : (isZh ? '会议详情' : 'Event Details'),
            style: TextStyle(fontFamily: 'Noto Serif', fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor),
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
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: [
            Tab(text: isZh ? '议程' : 'AGENDA'),
            Tab(text: isZh ? '嘉宾' : 'SPEAKERS'),
            Tab(text: isZh ? '资料' : 'MATERIALS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAgendaTab(eventCtrl, scheduleCtrl, primaryColor, surfaceColor, accentColor),
          _buildSpeakersTab(primaryColor, surfaceColor, accentColor),
          _buildMaterialsTab(primaryColor),
        ],
      ),
      bottomNavigationBar: Obx(() {
        if (_tabController.index != 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            child: ElevatedButton(
              onPressed: () {
                final eventId = eventCtrl.selectedEventId.value;
                scheduleCtrl.addAllSessionsFromEvent(eventId);
                Get.snackbar(
                  isZh ? '已添加' : 'Added',
                  isZh ? '所有议程已添加到我的日程' : 'All sessions added to My Schedule',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: primaryColor,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                isZh ? '添加到我的日程' : 'Add to My Schedule',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAgendaTab(EventController eventCtrl, ScheduleController scheduleCtrl, Color primaryColor, Color surfaceColor, Color accentColor) {
    return Obx(() {
      final totalDays = eventCtrl.totalDays;
      final sessions = eventCtrl.getSessionsForDay(_selectedDay);
      final isZh = Get.locale?.languageCode == 'zh';
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      margin: const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade300),
                      ),
                      child: Text(
                        dayDate != null
                            ? (isZh ? '第${index + 1}天 (${dayDate.month}/${dayDate.day})' : 'Day ${index + 1} (${dayDate.month}/${dayDate.day})')
                            : 'Day ${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
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
                    child: Text(
                      isZh ? '该日暂无议程安排' : 'No sessions scheduled for this day',
                      style: TextStyle(color: Colors.grey.shade500),
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
                          border: Border(left: BorderSide(color: session.type == SessionType.keynote ? accentColor : primaryColor, width: 4)),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 10, offset: const Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: session.type == SessionType.keynote ? accentColor : surfaceColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(session.typeLabel, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor)),
                                ),
                                Row(
                                  children: [
                                    Text(session.timeRangeStr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () {
                                        scheduleCtrl.toggleSession(session.id);
                                      },
                                      child: Icon(
                                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                                        size: 22,
                                        color: isSaved ? primaryColor : Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              isZh ? session.titleZh : session.titleEn,
                              style: TextStyle(fontFamily: 'Noto Serif', fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isZh ? session.titleEn : session.titleZh,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.location_on, size: 14, color: Colors.grey.shade500),
                                const SizedBox(width: 4),
                                Text(isZh ? session.roomZh : session.roomEn, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
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
                                    border: Border.all(color: Colors.grey.shade200),
                                    image: session.speakerAvatarUrl.isNotEmpty
                                        ? DecorationImage(image: NetworkImage(session.speakerAvatarUrl), fit: BoxFit.cover)
                                        : null,
                                  ),
                                  child: session.speakerAvatarUrl.isEmpty ? Icon(Icons.person, size: 20, color: Colors.grey.shade400) : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(session.speakerName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: primaryColor)),
                                      Text(
                                        isZh ? session.speakerTitleZh : session.speakerTitleEn,
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
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

  Widget _buildSpeakersTab(Color primaryColor, Color surfaceColor, Color accentColor) {
    final speakerCtrl = Get.find<SpeakerController>();
    final isZh = Get.locale?.languageCode == 'zh';

    return Obx(() {
      final speakers = speakerCtrl.speakers;
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: speakers.length,
        itemBuilder: (context, index) {
          final speaker = speakers[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: surfaceColor.withAlpha((0.5 * 255).round())),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: surfaceColor, width: 2),
                    image: DecorationImage(image: NetworkImage(speaker.avatarUrl), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isZh ? speaker.nameZh : speaker.nameEn, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryColor)),
                      Text(isZh ? speaker.titleZh : speaker.titleEn, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text(isZh ? speaker.organizationZh : speaker.organizationEn, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    isZh ? speaker.category.labelZh : speaker.category.labelEn,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildMaterialsTab(Color primaryColor) {
    final isZh = Get.locale?.languageCode == 'zh';
    final materials = [
      {'nameEn': 'Conference Program Guide', 'nameZh': '大会议程指南', 'type': 'PDF', 'size': '2.4 MB', 'icon': Icons.picture_as_pdf},
      {'nameEn': 'Speaker Abstracts Collection', 'nameZh': '嘉宾摘要合集', 'type': 'PDF', 'size': '5.1 MB', 'icon': Icons.picture_as_pdf},
      {'nameEn': 'Workshop Preparation Materials', 'nameZh': '研讨会准备材料', 'type': 'PPT', 'size': '12.8 MB', 'icon': Icons.slideshow},
      {'nameEn': 'Venue Map & Floor Plan', 'nameZh': '场馆地图与平面图', 'type': 'PDF', 'size': '1.2 MB', 'icon': Icons.map},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: materials.length,
      itemBuilder: (context, index) {
        final m = materials[index];
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
                child: Icon(m['icon'] as IconData, color: primaryColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isZh ? m['nameZh'] as String : m['nameEn'] as String, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: primaryColor)),
                    const SizedBox(height: 4),
                    Text('${m['type']} • ${m['size']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.download, color: primaryColor),
                onPressed: () {
                  Get.snackbar(
                    isZh ? '下载中' : 'Downloading',
                    isZh ? '${m['nameZh']} 正在下载...' : '${m['nameEn']} downloading...',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: primaryColor,
                    colorText: Colors.white,
                    margin: const EdgeInsets.all(16),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
