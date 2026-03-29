import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    const Color primaryColor = Color(0xFF196EE6);
    const Color backgroundColor = Color(0xFFF6F7F8);
    const Color textColor = Color(0xFF0F172A);
    const Color textLightColor = Color(0xFF64748B);
    const Color borderColor = Color(0xFFE2E8F0);
    const Color inputBgColor = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(primaryColor, textColor),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: _buildLoginCard(auth, primaryColor, textColor, textLightColor, borderColor, inputBgColor),
                ),
              ),
            ),
            _buildFooter(textLightColor),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color primaryColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF438AEE), Color(0xFF196EE6), Color(0xFF0F52B2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withAlpha((0.3 * 255).round()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.monitor_heart_rounded, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('APSCVIR', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5, color: textColor)),
                  Text('Conference App', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: primaryColor, letterSpacing: 0.5)),
                ],
              ),
            ],
          ),
          InkWell(
            onTap: () {
              if (Get.locale?.languageCode == 'zh') {
                Get.updateLocale(const Locale('en', 'US'));
              } else {
                Get.updateLocale(const Locale('zh', 'CN'));
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.language, size: 16, color: primaryColor),
                  const SizedBox(width: 4),
                  const Text('EN / CN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(Color textLightColor) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        '© 2026 APSCVIR Conference. All rights reserved.\n© 2026 APSCVIR 大会。保留所有权利。',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: textLightColor, height: 1.5),
      ),
    );
  }

  Widget _buildLoginCard(AuthController auth, Color primaryColor, Color textColor, Color textLightColor, Color borderColor, Color inputBgColor) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha((0.05 * 255).round()), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('welcome_back'.tr, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(
            Get.locale?.languageCode == 'zh' ? 'Welcome Back' : '欢迎回来',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: textLightColor),
          ),
          const SizedBox(height: 16),
          Text(
            '${'sign_in_desc'.tr}\n${Get.locale?.languageCode == 'zh' ? '请登录您的企业账户' : 'Please sign in to your corporate account'}',
            style: TextStyle(fontSize: 14, color: textLightColor, height: 1.5),
          ),
          const SizedBox(height: 32),
          // Email Field
          Text(
            '${'email'.tr} / ${Get.locale?.languageCode == 'zh' ? 'Email' : '邮箱'}',
            style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: TextField(
              controller: auth.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'corporate@company.com',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.mail_outline, color: Colors.grey.shade400),
                filled: true,
                fillColor: inputBgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Password Field
          Text(
            '${'password'.tr} / ${Get.locale?.languageCode == 'zh' ? 'Password' : '密码'}',
            style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 56,
            child: TextField(
              controller: auth.passwordController,
              obscureText: auth.obscurePassword.value,
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
                prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
                suffixIcon: IconButton(
                  icon: Icon(
                    auth.obscurePassword.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: auth.togglePasswordVisibility,
                ),
                filled: true,
                fillColor: inputBgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: borderColor)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: primaryColor, width: 2)),
              ),
            ),
          ),
          // Error message
          if (auth.errorMessage.value.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, size: 18, color: Colors.red.shade600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      auth.errorMessage.value,
                      style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: auth.rememberMe.value,
                      onChanged: (val) => auth.rememberMe.value = val ?? false,
                      activeColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('remember_me'.tr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155))),
                      Text(
                        Get.locale?.languageCode == 'zh' ? 'Remember Me' : '记住我',
                        style: TextStyle(fontSize: 12, color: textLightColor),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordDialog(primaryColor);
                    },
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: Text('forgot_password'.tr, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor)),
                  ),
                  Text(
                    Get.locale?.languageCode == 'zh' ? 'Forgot Password?' : '忘记密码？',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Sign In Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: auth.isLoading.value ? null : () async {
                final success = await auth.login();
                if (success) {
                  Get.offAllNamed('/main');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                shadowColor: primaryColor.withAlpha((0.4 * 255).round()),
              ),
              child: auth.isLoading.value
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'sign_in_btn'.tr} / ${Get.locale?.languageCode == 'zh' ? 'Sign In' : '登录'}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.login),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 16),
          // Register link
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Get.locale?.languageCode == 'zh' ? '还没有账号？' : "Don't have an account? ",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/register'),
                  child: Text(
                    Get.locale?.languageCode == 'zh' ? '立即注册' : 'Register Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Text(
                  'authorized_access'.tr,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1.5),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_outlined, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text('secure'.tr, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5)),
                    const SizedBox(width: 24),
                    Icon(Icons.verified_user_outlined, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text('encrypted'.tr, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5)),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  void _showForgotPasswordDialog(Color primaryColor) {
    final emailController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text(Get.locale?.languageCode == 'zh' ? '找回密码' : 'Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              Get.locale?.languageCode == 'zh'
                  ? '请输入您的注册邮箱，我们将发送验证码到您的邮箱。'
                  : 'Enter your registered email and we will send you a verification code.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'your@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(Get.locale?.languageCode == 'zh' ? '取消' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                Get.locale?.languageCode == 'zh' ? '已发送' : 'Sent',
                Get.locale?.languageCode == 'zh' ? '验证码已发送到您的邮箱' : 'Verification code has been sent to your email',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: primaryColor,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white),
            child: Text(Get.locale?.languageCode == 'zh' ? '发送验证码' : 'Send Code'),
          ),
        ],
      ),
    );
  }
}
