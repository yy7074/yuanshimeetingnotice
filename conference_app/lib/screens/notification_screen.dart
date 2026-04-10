import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<Map<String, dynamic>> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final api = Get.find<ApiService>();
      final res = await api.getNotifications();
      final countRes = await api.getUnreadNotificationCount();
      if (res.statusCode == 200 && res.body is List) {
        _notifications = List<Map<String, dynamic>>.from(res.body);
      } else {
        _notifications = [];
      }
      if (countRes.statusCode == 200) {
        _unreadCount = countRes.body['unreadCount'] ?? 0;
      }
      Get.find<NotificationService>().unreadCount.value = _unreadCount;
    } catch (_) {
      if (mounted) {
        Get.snackbar(
          _isZh ? '加载失败' : 'Load Failed',
          _isZh ? '无法获取消息列表' : 'Unable to load notifications',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  Future<void> _markAsRead(String id) async {
    try {
      final api = Get.find<ApiService>();
      await api.markNotificationAsRead(id);
      setState(() {
        final idx = _notifications.indexWhere((n) => n['id'] == id);
        if (idx >= 0) _notifications[idx]['isRead'] = true;
        _unreadCount = _notifications.where((n) => n['isRead'] == false).length;
      });
      Get.find<NotificationService>().refreshUnreadCount();
    } catch (_) {
      Get.snackbar(
        _isZh ? '操作失败' : 'Action Failed',
        _isZh ? '无法更新已读状态' : 'Unable to update read status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> _markAllAsRead() async {
    try {
      final api = Get.find<ApiService>();
      await api.markAllNotificationsAsRead();
      setState(() {
        for (var n in _notifications) { n['isRead'] = true; }
        _unreadCount = 0;
      });
      Get.find<NotificationService>().refreshUnreadCount();
    } catch (_) {
      Get.snackbar(
        _isZh ? '操作失败' : 'Action Failed',
        _isZh ? '无法全部标记为已读' : 'Unable to mark all as read',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> _openNotification(Map<String, dynamic> notification) async {
    if (notification['isRead'] != true) {
      await _markAsRead(notification['id']);
    }
    if (!mounted) return;
    Get.find<NotificationService>().openNotification(notification);
  }

  bool get _isZh => Get.locale?.languageCode == 'zh';
  static const Color _primaryColor = Color(0xFF196EE6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)), onPressed: () => Get.back()),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_isZh ? '消息中心' : 'Notifications', style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
            if (_unreadCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(12)),
                child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(_isZh ? '全部已读' : 'Read All', style: TextStyle(color: _primaryColor, fontSize: 13)),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text(_isZh ? '暂无消息' : 'No notifications', style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final n = _notifications[index];
                      final isRead = n['isRead'] == true;
                      final typeIcon = _getTypeIcon(n['type'] as String?);
                      return GestureDetector(
                        onTap: () => _openNotification(n),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isRead ? Colors.white : _primaryColor.withAlpha(13),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isRead ? Colors.grey.shade200 : _primaryColor.withAlpha(51)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 40, height: 40,
                                decoration: BoxDecoration(
                                  color: typeIcon.color.withAlpha(26),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(typeIcon.icon, color: typeIcon.color, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            _isZh ? (n['titleZh'] ?? '') : (n['titleEn'] ?? ''),
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                              color: const Color(0xFF0F172A),
                                            ),
                                          ),
                                        ),
                                        if (!isRead)
                                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: _primaryColor, shape: BoxShape.circle)),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _isZh ? (n['bodyZh'] ?? '') : (n['bodyEn'] ?? ''),
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      _formatTime(n['createdAt'] as String?),
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  ({IconData icon, Color color}) _getTypeIcon(String? type) {
    return switch (type) {
      'schedule_reminder' => (icon: Icons.schedule, color: Colors.blue),
      'daily_reminder' => (icon: Icons.calendar_today, color: Colors.indigo),
      'event_update' => (icon: Icons.event, color: Colors.orange),
      'material_update' => (icon: Icons.file_copy, color: Colors.green),
      'check_in_success' => (icon: Icons.check_circle, color: Colors.teal),
      _ => (icon: Icons.notifications, color: _primaryColor),
    };
  }

  String _formatTime(String? isoString) {
    if (isoString == null) return '';
    final dt = DateTime.tryParse(isoString);
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return _isZh ? '刚刚' : 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} ${_isZh ? '分钟前' : 'min ago'}';
    if (diff.inDays < 1) return '${diff.inHours} ${_isZh ? '小时前' : 'hours ago'}';
    return '${diff.inDays} ${_isZh ? '天前' : 'days ago'}';
  }
}
