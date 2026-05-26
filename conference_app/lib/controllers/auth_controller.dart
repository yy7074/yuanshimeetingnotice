import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final obscurePassword = true.obs;
  final rememberMe = true.obs;
  final isLoading = false.obs;
  final isReady = false.obs;
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
      loadProfile();
    } else {
      isReady.value = true;
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

  Future<void> loadProfile() async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.getProfile();
      if (res.statusCode == 200 && res.body != null) {
        currentUser.value = _parseUser(res.body);
      } else {
        currentUser.value = null;
        await _storage.clearAuth();
      }
    } catch (_) {
      currentUser.value = null;
    } finally {
      isReady.value = true;
    }
  }

  Future<bool> login() async {
    errorMessage.value = '';
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      errorMessage.value = 'Please enter your email';
      return false;
    }
    if (!GetUtils.isEmail(email)) {
      errorMessage.value = 'Please enter a valid email';
      return false;
    }
    if (password.isEmpty) {
      errorMessage.value = 'Please enter your password';
      return false;
    }
    if (password.length < 8) {
      errorMessage.value = 'Password must be at least 8 characters';
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
        try {
          final notificationService = Get.find<NotificationService>();
          await notificationService.setAlias(body['user']['id']);
          await notificationService.registerCurrentPushToken();
        } catch (_) {}
        isLoading.value = false;
        return true;
      } else {
        final msg = res.body?['message'] ?? 'Login failed';
        errorMessage.value = msg;
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      errorMessage.value =
          'Network error. Please check your connection and try again';
      isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    isReady.value = true;
    passwordController.clear();
    await _storage.clearAuth();
    Get.offAllNamed('/login');
  }

  bool get mustChangePassword => currentUser.value?.mustChangePassword == true;

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final api = Get.find<ApiService>();
      final res = await api.changePassword(currentPassword, newPassword);
      if (res.statusCode == 200 || res.statusCode == 201) {
        // Backend bumped tokenVersion — old token is now invalid.
        await _storage.clearAuth();
        currentUser.value = null;
        return true;
      }
      errorMessage.value =
          res.body?['message'] ??
          (Get.locale?.languageCode == '__zh_disabled__'
              ? 'Failed to change password'
              : 'Failed to change password');
      return false;
    } catch (_) {
      errorMessage.value = 'Network error. Please try again.';
      return false;
    }
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
      mustChangePassword: json['mustChangePassword'] == true,
    );
  }
}
