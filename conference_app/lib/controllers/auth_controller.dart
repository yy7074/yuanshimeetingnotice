import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/data_service.dart';
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
    // Restore saved email if remember me was on
    if (_storage.rememberMe && _storage.savedEmail != null) {
      emailController.text = _storage.savedEmail!;
      rememberMe.value = true;
    }
    // Auto-login if token exists
    if (_storage.authToken != null) {
      currentUser.value = DataService.demoUser;
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

  Future<bool> login() async {
    errorMessage.value = '';
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validation
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

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Demo login - accept any valid email/password combo
    currentUser.value = DataService.demoUser;
    await _storage.saveAuthToken('demo_token_${DateTime.now().millisecondsSinceEpoch}');
    await _storage.saveLoginInfo(email, rememberMe.value);

    isLoading.value = false;
    return true;
  }

  Future<void> logout() async {
    currentUser.value = null;
    passwordController.clear();
    await _storage.clearAuth();
    Get.offAllNamed('/login');
  }
}
