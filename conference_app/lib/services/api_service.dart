import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'storage_service.dart';

class ApiService extends GetConnect {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://admin.apscvir.top/api/v1',
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
  Future<Response> login(String email, String password) {
    if (kIsWeb) {
      return _webJsonPost('/auth/login', {
        'email': email,
        'password': password,
      });
    }
    return post('/auth/login', {'email': email, 'password': password});
  }

  Future<Response> _webJsonPost(String path, Map<String, dynamic> body) async {
    final storage = Get.find<StorageService>();
    final token = storage.authToken;
    final uri = Uri.parse(
      '${apiBaseUrl.endsWith('/') ? apiBaseUrl.substring(0, apiBaseUrl.length - 1) : apiBaseUrl}$path',
    );
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    final res = await http
        .post(uri, headers: headers, body: jsonEncode(body))
        .timeout(httpClient.timeout);
    dynamic decoded;
    try {
      decoded = res.body.isEmpty ? null : jsonDecode(res.body);
    } catch (_) {
      decoded = res.body;
    }
    return Response(
      statusCode: res.statusCode,
      body: decoded,
      bodyString: res.body,
      headers: res.headers,
    );
  }

  Future<Response> register(
    String email,
    String password, {
    String? code,
    String? nameEn,
    String? nameZh,
  }) => () {
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

  Future<Response> resetPassword(
    String email,
    String code,
    String newPassword,
  ) => post('/auth/reset-password', {
    'email': email,
    'code': code,
    'newPassword': newPassword,
  });

  Future<Response> changePassword(String currentPassword, String newPassword) =>
      post('/users/change-password', {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });

  Future<Response> deleteAccount(String password) =>
      post('/users/delete-account', {'password': password});

  Future<Response> getProfile() => get('/auth/profile');

  // Home banners
  Future<Response> getHomeBanners() => get('/home-banners');

  // APSCVIR source-site content
  Future<Response> getApscvirContentManifest() =>
      get('/apscvir-content/manifest');

  Future<Response> getApscvirContentFile(String assetPath) =>
      get('/apscvir-content/file?path=${Uri.encodeQueryComponent(assetPath)}');

  String apscvirContentFileUrl(String assetPath) {
    final base = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;
    return '$base/apscvir-content/file?path=${Uri.encodeQueryComponent(assetPath)}';
  }

  // Events
  Future<Response> getEvents({String? search, String? status}) {
    final params = <String, String>{};
    if (search != null && search.isNotEmpty) params['search'] = search;
    if (status != null) params['status'] = status;
    final query = params.isNotEmpty
        ? '?${params.entries.map((e) => '${e.key}=${e.value}').join('&')}'
        : '';
    return get('/events$query');
  }

  Future<Response> getEvent(String id) => get('/events/$id');
  Future<Response> getMyEvents() => get('/events/my');
  Future<Response> subscribeEvent(String eventId) =>
      post('/events/$eventId/subscribe', {});
  Future<Response> unsubscribeEvent(String eventId) =>
      delete('/events/$eventId/subscribe');

  // Sessions
  Future<Response> getSessions(String eventId) =>
      get('/events/$eventId/sessions');

  // Speakers
  Future<Response> getSpeakers({String? search}) {
    final query = search != null && search.isNotEmpty ? '?search=$search' : '';
    return get('/speakers$query');
  }

  // Materials
  Future<Response> getMaterials(String eventId) =>
      get('/events/$eventId/materials');
  Future<Response> trackDownload(String eventId, String materialId) =>
      post('/events/$eventId/materials/$materialId/download', {});

  /// Download a protected material file (role-gated on the server).
  /// Returns the local path of the saved file.
  Future<File> downloadMaterialFile(
    String eventId,
    String materialId,
    String suggestedName,
  ) async {
    final storage = Get.find<StorageService>();
    final token = storage.authToken;
    if (token == null) {
      throw StateError('Not authenticated');
    }
    final base = apiBaseUrl.endsWith('/')
        ? apiBaseUrl.substring(0, apiBaseUrl.length - 1)
        : apiBaseUrl;
    final uri = Uri.parse('$base/events/$eventId/materials/$materialId/file');
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 30);
    try {
      final req = await httpClient.getUrl(uri);
      req.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
      req.followRedirects = true;
      final res = await req.close();
      if (res.statusCode >= 400) {
        throw HttpException(
          'Download failed: HTTP ${res.statusCode}',
          uri: uri,
        );
      }
      String name = suggestedName.trim();
      final disposition = res.headers.value('content-disposition');
      if (disposition != null) {
        final match = RegExp(
          r'filename\*?=(?:UTF-8'
          ')?"?([^;"\r\n]+)"?',
        ).firstMatch(disposition);
        if (match != null) {
          name = Uri.decodeFull(match.group(1) ?? name);
        }
      }
      if (name.isEmpty) name = 'material-$materialId';
      final safe = name.replaceAll(RegExp(r'[^\w\-. ]'), '_');
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$safe');
      final sink = file.openWrite();
      await res.pipe(sink);
      return file;
    } finally {
      httpClient.close(force: false);
    }
  }

  // Check-in
  Future<Response> generateQr(String eventId) =>
      post('/check-in/generate/$eventId', {});
  Future<Response> getMyCheckIn(String eventId) => get('/check-in/my/$eventId');

  // Notifications
  Future<Response> getNotifications() => get('/notifications');
  Future<Response> getUnreadNotificationCount() =>
      get('/notifications/unread-count');
  Future<Response> markNotificationAsRead(String notificationId) =>
      post('/notifications/$notificationId/read', {});
  Future<Response> markAllNotificationsAsRead() =>
      post('/notifications/read-all', {});
  Future<Response> registerPushToken(String token) =>
      put('/notifications/fcm-token', {'token': token});
  Future<Response> updatePushSettings(bool enabled) =>
      put('/notifications/push-settings', {'enabled': enabled});

  // Profile
  Future<Response> updateProfile(Map<String, dynamic> data) =>
      put('/users/profile', data);
}
