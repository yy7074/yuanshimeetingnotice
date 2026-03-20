import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventPortalScreen extends StatefulWidget {
  const EventPortalScreen({super.key});

  @override
  State<EventPortalScreen> createState() => _EventPortalScreenState();
}

class _EventPortalScreenState extends State<EventPortalScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF196EE6);
    const Color backgroundColor = Color(0xFFF6F7F8);
    const Color textColor = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(textColor),
            _buildSearchBar(),
            _buildTabBar(primaryColor),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAllEventsList(primaryColor),
                  const Center(child: Text('MY EVENTS')),
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
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
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
          decoration: InputDecoration(
            hintText: 'search_hint'.tr,
            hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
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

  Widget _buildAllEventsList(Color primaryColor) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        _buildEventCard(
          title: Get.locale?.languageCode == 'zh' ? '2026 全球肿瘤学创新峰会' : 'Global Oncology Summit 2026',
          date: 'Oct 15-17, 2026',
          location: Get.locale?.languageCode == 'zh' ? '旧金山国际会议中心, CA' : 'Convention Center, San Francisco, CA',
          imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?q=80&w=2070&auto=format&fit=crop',
          primaryColor: primaryColor,
          avatars: ['JD', 'AS', '+12'],
        ),
        const SizedBox(height: 24),
        _buildEventCard(
          title: Get.locale?.languageCode == 'zh' ? '未来数字医疗与AI论坛' : 'Future of Digital Healthcare & AI Forum',
          date: 'Nov 02-04, 2026',
          location: Get.locale?.languageCode == 'zh' ? '上海君悦大酒店, CN' : 'Grand Hyatt, Shanghai, CN',
          imageUrl: 'https://images.unsplash.com/photo-1591115765373-5207764f72e7?q=80&w=2070&auto=format&fit=crop',
          primaryColor: primaryColor,
          isFeatured: true,
        ),
        const SizedBox(height: 24),
        _buildEventCard(
          title: Get.locale?.languageCode == 'zh' ? '国际心血管医学博览会' : 'International Cardiovascular Expo',
          date: 'Dec 12, 2026',
          location: Get.locale?.languageCode == 'zh' ? '柏林展览中心, DE' : 'Exhibition Hall, Berlin, DE',
          imageUrl: 'https://images.unsplash.com/photo-1497366216548-37526070297c?q=80&w=2069&auto=format&fit=crop',
          primaryColor: primaryColor,
          footerText: Get.locale?.languageCode == 'zh' ? '仅剩 5 个参会名额' : 'Last 5 tickets left',
        ),
      ],
    );
  }

  Widget _buildEventCard({
    required String title,
    required String date,
    required String location,
    required String imageUrl,
    required Color primaryColor,
    List<String>? avatars,
    bool isFeatured = false,
    String? footerText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade200,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Footer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (avatars != null)
                      Row(
                        children: avatars.asMap().entries.map((entry) {
                          int idx = entry.key;
                          String text = entry.value;
                          return Transform.translate(
                            offset: Offset(idx * -8.0, 0),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: idx == 0
                                    ? Colors.grey.shade200
                                    : idx == 1
                                        ? primaryColor.withAlpha((0.2 * 255).round())
                                        : Colors.grey.shade300,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  text,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: idx == 1 ? primaryColor : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    else if (isFeatured)
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
                            Text(
                              'featured_event'.tr,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (footerText != null)
                      Text(
                        footerText,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      )
                    else
                      const SizedBox(),
                    ElevatedButton(
                      onPressed: () {
                        // Implement join/subscribe logic
                        Get.snackbar(
                          Get.locale?.languageCode == 'zh' ? '成功' : 'Success',
                          Get.locale?.languageCode == 'zh' ? '已成功订阅该会议' : 'Successfully subscribed to event',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: primaryColor,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: primaryColor),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'join_event'.tr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/event_agenda');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        elevation: 0,
                      ),
                      child: Text(
                        'view_details'.tr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
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
