import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';

class EventPortalScreen extends StatefulWidget {
  const EventPortalScreen({super.key});

  @override
  State<EventPortalScreen> createState() => _EventPortalScreenState();
}

class _EventPortalScreenState extends State<EventPortalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF196EE6);
    const Color backgroundColor = Color(0xFFF6F7F8);
    const Color textColor = Color(0xFF0F172A);
    final eventCtrl = Get.find<EventController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(textColor),
            _buildSearchBar(eventCtrl),
            _buildTabBar(primaryColor),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Obx(() => _buildEventsList(eventCtrl.filteredEvents, primaryColor, eventCtrl)),
                  Obx(() {
                    final myEvents = eventCtrl.myEvents;
                    if (myEvents.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.event_busy, size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              Get.locale?.languageCode == 'zh' ? '暂未订阅任何会议' : 'No subscribed events yet',
                              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              Get.locale?.languageCode == 'zh' ? '在"所有会议"中点击"加入会议"即可订阅' : 'Tap "Join Event" in ALL EVENTS to subscribe',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildEventsList(myEvents, primaryColor, eventCtrl);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Center(
        child: Text(
          'global_conferences'.tr,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor, letterSpacing: -0.5),
        ),
      ),
    );
  }

  Widget _buildSearchBar(EventController eventCtrl) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) => eventCtrl.searchQuery.value = value,
          decoration: InputDecoration(
            hintText: 'search_hint'.tr,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
            suffixIcon: Obx(() => eventCtrl.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: () {
                      _searchController.clear();
                      eventCtrl.searchQuery.value = '';
                    },
                  )
                : const SizedBox.shrink()),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(Color primaryColor) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: primaryColor,
        indicatorWeight: 2,
        labelColor: primaryColor,
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.0),
        tabs: [
          Tab(text: 'all_events'.tr),
          Tab(text: 'my_events'.tr),
        ],
      ),
    );
  }

  Widget _buildEventsList(List<EventModel> events, Color primaryColor, EventController eventCtrl) {
    if (events.isEmpty) {
      return Center(
        child: Text(
          Get.locale?.languageCode == 'zh' ? '未找到匹配的会议' : 'No matching events found',
          style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) => _buildEventCard(events[index], primaryColor, eventCtrl),
    );
  }

  Widget _buildEventCard(EventModel event, Color primaryColor, EventController eventCtrl) {
    final isZh = Get.locale?.languageCode == 'zh';
    final isSubscribed = eventCtrl.isSubscribed(event.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha((0.03 * 255).round()), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isZh ? event.titleZh : event.titleEn,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.2),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(event.dateRangeStr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade500)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isZh ? event.locationZh : event.locationEn,
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (event.isFeatured)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: primaryColor.withAlpha((0.1 * 255).round()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.bolt, size: 16, color: primaryColor),
                            const SizedBox(width: 4),
                            Text('featured_event'.tr, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: primaryColor)),
                          ],
                        ),
                      )
                    else if (event.remainingSpots >= 0 && event.remainingSpots <= 10)
                      Text(
                        isZh ? '仅剩 ${event.remainingSpots} 个参会名额' : 'Last ${event.remainingSpots} tickets left',
                        style: TextStyle(fontSize: 12, color: Colors.orange.shade700, fontWeight: FontWeight.w600),
                      )
                    else
                      Text(
                        '${event.currentAttendees} ${isZh ? '人参会' : 'attendees'}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            eventCtrl.toggleSubscription(event.id);
                            if (!isSubscribed) {
                              Get.snackbar(
                                isZh ? '成功' : 'Success',
                                isZh ? '已成功订阅该会议' : 'Successfully subscribed to event',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: primaryColor,
                                colorText: Colors.white,
                                margin: const EdgeInsets.all(16),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSubscribed ? Colors.grey.shade100 : Colors.white,
                            foregroundColor: isSubscribed ? Colors.grey.shade600 : primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: isSubscribed ? Colors.grey.shade300 : primaryColor),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            elevation: 0,
                          ),
                          child: Text(
                            isSubscribed
                                ? (isZh ? '已加入' : 'Joined')
                                : (isZh ? '加入会议' : 'Join'),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            eventCtrl.selectEvent(event.id);
                            Get.toNamed('/event_agenda');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            elevation: 0,
                          ),
                          child: Text('view_details'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
