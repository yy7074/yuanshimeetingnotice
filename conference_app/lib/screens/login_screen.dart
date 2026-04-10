import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

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
              final storage = Get.find<StorageService>();
              if (Get.locale?.languageCode == 'zh') {
                Get.updateLocale(const Locale('en', 'US'));
                storage.saveLanguage('en');
              } else {
                Get.updateLocale(const Locale('zh', 'CN'));
                storage.saveLanguage('zh');
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
            Get.locale?.languageCode == 'zh' ? '欢迎回来' : 'Welcome Back',
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
            '${'email'.tr} / ${Get.locale?.languageCode == 'zh' ? '邮箱' : 'Email'}',
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
            '${'password'.tr} / ${Get.locale?.languageCode == 'zh' ? '密码' : 'Password'}',
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
                        Get.locale?.languageCode == 'zh' ? '记住我' : 'Remember Me',
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
                    Get.locale?.languageCode == 'zh' ? '忘记密码？' : 'Forgot Password?',
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
    Get.dialog(
      _ForgotPasswordDialog(primaryColor: primaryColor),
      barrierDismissible: false,
    );
  }
}

class _ForgotPasswordDialog extends StatefulWidget {
  final Color primaryColor;
  const _ForgotPasswordDialog({required this.primaryColor});

  @override
  State<_ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<_ForgotPasswordDialog> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _step = 0; // 0=email, 1=code, 2=new password
  bool _isLoading = false;
  String _error = '';
  bool _obscure = true;
  int _countdown = 0;
  int _dailySendCount = 0;

  bool get _isZh => Get.locale?.languageCode == 'zh';

  void _startCountdown() {
    _countdown = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdown--);
      return _countdown > 0;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    if (_countdown > 0) {
      setState(() => _error = _isZh ? '请等待 $_countdown 秒后再试' : 'Please wait $_countdown seconds');
      return;
    }
    if (_dailySendCount >= 5) {
      setState(() => _error = _isZh ? '今日发送次数已达上限(5次)' : 'Daily limit reached (5 requests)');
      return;
    }
    final email = _emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      setState(() => _error = _isZh ? '请输入有效的邮箱地址' : 'Please enter a valid email');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });
    try {
      final api = Get.find<ApiService>();
      final res = await api.forgotPassword(email);
      if (res.statusCode == 200 || res.statusCode == 201) {
        _dailySendCount++;
        _startCountdown();
        setState(() { _step = 1; _isLoading = false; });
      } else {
        setState(() { _error = res.body?['message'] ?? (_isZh ? '发送失败' : 'Failed to send'); _isLoading = false; });
      }
    } catch (_) {
      setState(() {
        _error = _isZh ? '网络错误，请稍后重试' : 'Network error, please try again';
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyAndProceed() async {
    if (_codeController.text.trim().length != 6) {
      setState(() => _error = _isZh ? '请输入6位验证码' : 'Please enter 6-digit code');
      return;
    }
    setState(() { _step = 2; _error = ''; });
  }

  Future<void> _resetPassword() async {
    final password = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    if (password.length < 8) {
      setState(() => _error = _isZh ? '密码长度至少为8位' : 'Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _error = _isZh ? '两次密码输入不一致' : 'Passwords do not match');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });
    try {
      final api = Get.find<ApiService>();
      final res = await api.resetPassword(
        _emailController.text.trim(),
        _codeController.text.trim(),
        password,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        Get.back();
        Get.snackbar(
          _isZh ? '密码已重置' : 'Password Reset',
          _isZh ? '请使用新密码登录' : 'Please sign in with your new password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: widget.primaryColor,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        setState(() { _error = res.body?['message'] ?? (_isZh ? '重置失败' : 'Reset failed'); _isLoading = false; });
      }
    } catch (_) {
      setState(() { _error = _isZh ? '网络错误，请稍后重试' : 'Network error, please try again'; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isZh ? '找回密码' : 'Reset Password'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step indicator
            Row(
              children: List.generate(3, (i) => Expanded(
                child: Container(
                  height: 3,
                  margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: i <= _step ? widget.primaryColor : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              )),
            ),
            const SizedBox(height: 16),
            if (_error.isNotEmpty) ...[
              Text(_error, style: TextStyle(fontSize: 13, color: Colors.red.shade600)),
              const SizedBox(height: 12),
            ],
            if (_step == 0) ...[
              Text(
                _isZh ? '请输入您的注册邮箱' : 'Enter your registered email',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'your@email.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
            if (_step == 1) ...[
              Text(
                '${_isZh ? '验证码已发送至' : 'Code sent to'} ${_emailController.text.trim()}',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: const TextStyle(fontSize: 20, letterSpacing: 6, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: '000000',
                  counterText: '',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
            if (_step == 2) ...[
              Text(
                _isZh ? '设置新密码' : 'Set your new password',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _newPasswordController,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: _isZh ? '新密码（至少8位）' : 'New Password (min 8 chars)',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: _isZh ? '确认新密码' : 'Confirm New Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(_isZh ? '取消' : 'Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading || (_step == 0 && _countdown > 0)
              ? null
              : () {
                  if (_step == 0) {
                    _sendCode();
                  } else if (_step == 1) {
                    _verifyAndProceed();
                  } else {
                    _resetPassword();
                  }
                },
          style: ElevatedButton.styleFrom(backgroundColor: widget.primaryColor, foregroundColor: Colors.white),
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(
                  _step == 0
                    ? (_countdown > 0
                        ? '${_isZh ? '等待' : 'Wait'} ${_countdown}s'
                        : (_isZh ? '发送验证码' : 'Send Code'))
                    : _step == 1 ? (_isZh ? '下一步' : 'Next')
                    : (_isZh ? '重置密码' : 'Reset Password'),
                ),
        ),
      ],
    );
  }
}
