import 'package:get/get.dart';
import 'storage_service.dart';

class ApiService extends GetConnect {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/api/v1',
  );
  // Override with --dart-define=API_BASE_URL=... for device/prod builds.

  @override
  void onInit() {
    httpClient.baseUrl = apiBaseUrl;
    httpClient.timeout = const Duration(seconds: 15);

    // Add auth token to requests
    httpClient.addRequestModifier<dynamic>((request) {
      final storage = Get.find<StorageService>();
      final token = storage.authToken;
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      request.headers['Content-Type'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier<dynamic>((request, response) {
      if (response.statusCode == 401) {
        final storage = Get.find<StorageService>();
        final currentRoute = Get.currentRoute;
        Future<void>(() async {
          await storage.clearAuth();
          if (currentRoute != '/login' && currentRoute != '/startup') {
            Get.offAllNamed('/login');
          }
        });
      }
      return response;
    });

    super.onInit();
  }

  // Auth
  Future<Response> login(String email, String password) =>
      post('/auth/login', {'email': email, 'password': password});

  Future<Response> register(String email, String password, {String? code, String? nameEn, String? nameZh}) =>
      () {
        final body = <String, dynamic>{
          'email': email,
          'password': password,
          'nameEn': nameEn,
          'nameZh': nameZh,
        };
        if (code != null) {
          body['code'] = code;
        }
        return post('/auth/register', body);
      }();

  Future<Response> forgotPassword(String email) =>
      post('/auth/forgot-password', {'email': email});

  Future<Response> resetPassword(String email, String code, String newPassword) =>
      post('/auth/reset-password', {'email': email, 'code': code, 'newPassword': newPassword});

  Future<Response> getProfile() => get('/auth/profile');

  // Events
  Future<Response> getEvents({String? search, String? status}) {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (status != null) params['status'] = status;
    final query = params.isNotEmpty ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}' : '';
    return get('/events$query');
  }

  Future<Response> getEvent(String id) => get('/events/$id');
  Future<Response> getMyEvents() => get('/events/my');
  Future<Response> subscribeEvent(String eventId) => post('/events/$eventId/subscribe', {});
  Future<Response> unsubscribeEvent(String eventId) => delete('/events/$eventId/subscribe');

  // Sessions
  Future<Response> getSessions(String eventId) => get('/events/$eventId/sessions');

  // Speakers
  Future<Response> getSpeakers({String? search}) {
    final query = search != null && search.isNotEmpty ? '?search=$search' : '';
    return get('/speakers$query');
  }

  // Materials
  Future<Response> getMaterials(String eventId) => get('/events/$eventId/materials');
  Future<Response> trackDownload(String eventId, String materialId) =>
      post('/events/$eventId/materials/$materialId/download', {});

  // Check-in
  Future<Response> generateQr(String eventId) => post('/check-in/generate/$eventId', {});
  Future<Response> getMyCheckIn(String eventId) => get('/check-in/my/$eventId');

  // Notifications
  Future<Response> getNotifications() => get('/notifications');
  Future<Response> getUnreadNotificationCount() => get('/notifications/unread-count');
  Future<Response> markNotificationAsRead(String notificationId) =>
      post('/notifications/$notificationId/read', {});
  Future<Response> markAllNotificationsAsRead() => post('/notifications/read-all', {});
  Future<Response> registerPushToken(String token) =>
      put('/notifications/fcm-token', {'token': token});
  Future<Response> updatePushSettings(bool enabled) =>
      put('/notifications/push-settings', {'enabled': enabled});

  // Profile
  Future<Response> updateProfile(Map<String, dynamic> data) => put('/users/profile', data);
}
