import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/data_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();
    if (_storage.rememberMe && _storage.savedEmail != null) {
      emailController.text = _storage.savedEmail!;
      rememberMe.value = true;
    }
    if (_storage.authToken != null) {
      _loadProfile();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  bool get isLoggedIn => currentUser.value != null;

  Future<void> _loadProfile() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getProfile();
      if (res.statusCode == 200 && res.body != null) {
        currentUser.value = _parseUser(res.body);
      } else {
        // Token expired, use fallback
        currentUser.value = DataService.demoUser;
      }
    } catch (_) {
      currentUser.value = DataService.demoUser;
    }
  }

  Future<bool> login() async {
    errorMessage.value = '';
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      errorMessage.value = Get.locale?.languageCode == 'zh' ? '请输入邮箱地址' : 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage.value = Get.locale?.languageCode == 'zh' ? '请输入有效的邮箱地址' : 'Please enter a valid email';
      return false;
    }
    if (password.isEmpty) {
      errorMessage.value = Get.locale?.languageCode == 'zh' ? '请输入密码' : 'Please enter your password';
      return false;
    }
    if (password.length < 8) {
      errorMessage.value = Get.locale?.languageCode == 'zh' ? '密码长度至少为8位' : 'Password must be at least 8 characters';
      return false;
    }

    isLoading.value = true;

    try {
      final api = Get.find<ApiService>();
      final res = await api.login(email, password);

      if (res.statusCode == 201 || res.statusCode == 200) {
        final body = res.body;
        final token = body['token'] as String;
        await _storage.saveAuthToken(token);
        await _storage.saveLoginInfo(email, rememberMe.value);
        currentUser.value = _parseUser(body['user']);
        // Set JPush alias for targeted push
        try { Get.find<NotificationService>().setAlias(body['user']['id']); } catch (_) {}
        isLoading.value = false;
        return true;
      } else {
        final msg = res.body?['message'] ?? 'Login failed';
        errorMessage.value = msg;
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      // Fallback to offline mode
      currentUser.value = DataService.demoUser;
      await _storage.saveAuthToken('offline_token');
      await _storage.saveLoginInfo(email, rememberMe.value);
      isLoading.value = false;
      return true;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    passwordController.clear();
    await _storage.clearAuth();
    Get.offAllNamed('/login');
  }

  UserModel _parseUser(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nameEn: json['nameEn'] ?? '',
      nameZh: json['nameZh'] ?? '',
      titleEn: json['titleEn'] ?? '',
      titleZh: json['titleZh'] ?? '',
      organizationEn: json['organizationEn'] ?? '',
      organizationZh: json['organizationZh'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.attendee,
      ),
    );
  }
}
