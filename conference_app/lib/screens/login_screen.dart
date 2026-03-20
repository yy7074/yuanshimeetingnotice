import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF196EE6);
    const Color backgroundColor = Color(0xFFF6F7F8);
    const Color textColor = Color(0xFF0F172A); // slate-900
    const Color textLightColor = Color(0xFF64748B); // slate-500
    const Color borderColor = Color(0xFFE2E8F0); // slate-200
    const Color inputBgColor = Color(0xFFF8FAFC); // slate-50

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
                  child: _buildLoginCard(primaryColor, textColor, textLightColor, borderColor, inputBgColor),
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
                    colors: [
                      Color(0xFF438AEE), // Lighter primary
                      Color(0xFF196EE6), // Primary
                      Color(0xFF0F52B2), // Darker primary
                    ],
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
                child: const Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.monitor_heart_rounded, color: Colors.white, size: 28),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'APSCVIR',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: textColor,
                    ),
                  ),
                  Text(
                    'Conference App',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
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
                  const Text(
                    'EN / CN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
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
        style: TextStyle(
          fontSize: 12,
          color: textLightColor,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildLoginCard(Color primaryColor, Color textColor, Color textLightColor, Color borderColor, Color inputBgColor) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 480),
      padding: const EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).round()),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'welcome_back'.tr,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
          ),
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
              decoration: InputDecoration(
                hintText: 'corporate@company.com',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.mail_outline, color: Colors.grey.shade400),
                filled: true,
                fillColor: inputBgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
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
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: '••••••••',
                hintStyle: TextStyle(color: Colors.grey.shade400, letterSpacing: 2),
                prefixIcon: Icon(Icons.lock_outline, color: Colors.grey.shade400),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.grey.shade400,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                filled: true,
                fillColor: inputBgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
              ),
            ),
          ),
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
                      value: _rememberMe,
                      onChanged: (val) {
                        setState(() {
                          _rememberMe = val ?? false;
                        });
                      },
                      activeColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'remember_me'.tr,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF334155)),
                      ),
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
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'forgot_password'.tr,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryColor),
                    ),
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
              onPressed: () {
                Get.offAllNamed('/main');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 4,
                shadowColor: primaryColor.withAlpha((0.4 * 255).round()),
              ),
              child: Row(
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
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFF1F5F9)),
          const SizedBox(height: 24),
          // Authorized Access Only
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
                    Text(
                      'secure'.tr,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5),
                    ),
                    const SizedBox(width: 24),
                    Icon(Icons.verified_user_outlined, size: 16, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      'encrypted'.tr,
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 0.5),
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
