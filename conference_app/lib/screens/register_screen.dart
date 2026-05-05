import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _nameZhController = TextEditingController();

  int _step = 0; // 0=email, 1=verify code, 2=set password
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreedToTerms = false;
  String _error = '';
  int _countdown = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _nameEnController.dispose();
    _nameZhController.dispose();
    super.dispose();
  }

  Future<void> _sendCode() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      setState(() => _error = _isZh ? '请输入有效的邮箱地址' : 'Please enter a valid email');
      return;
    }
    setState(() { _isLoading = true; _error = ''; });

    try {
      final api = Get.find<ApiService>();
      final res = await api.post('/auth/send-code', {'email': email});
      if (res.statusCode == 201 || res.statusCode == 200) {
        setState(() { _step = 1; _isLoading = false; });
        _startCountdown();
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

  void _startCountdown() {
    _countdown = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _countdown--);
      return _countdown > 0;
    });
  }

  bool _isValidVerificationCode(String code) {
    final trimmed = code.trim();
    return trimmed.length == 4 || trimmed.length == 6;
  }

  Future<void> _verifyCode() async {
    if (!_isValidVerificationCode(_codeController.text)) {
      setState(() => _error = _isZh ? '请输入4位或6位验证码' : 'Please enter a 4-digit or 6-digit code');
      return;
    }
    setState(() { _step = 2; _error = ''; });
  }

  // Password strength: 0=weak, 1=medium, 2=strong
  int get _passwordStrength {
    final p = _passwordController.text;
    if (p.length < 8) return 0;
    int score = 0;
    if (p.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(p)) score++;
    if (RegExp(r'[a-z]').hasMatch(p)) score++;
    if (RegExp(r'[0-9]').hasMatch(p)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(p)) score++;
    if (score <= 2) return 0;
    if (score <= 3) return 1;
    return 2;
  }

  String get _strengthLabel {
    switch (_passwordStrength) {
      case 0: return _isZh ? '弱' : 'Weak';
      case 1: return _isZh ? '中' : 'Medium';
      default: return _isZh ? '强' : 'Strong';
    }
  }

  Color get _strengthColor {
    switch (_passwordStrength) {
      case 0: return Colors.red;
      case 1: return Colors.orange;
      default: return Colors.green;
    }
  }

  Future<void> _register() async {
    final password = _passwordController.text;
    final confirm = _confirmController.text;

    if (password.length < 8) {
      setState(() => _error = _isZh ? '密码长度至少为8位' : 'Password must be at least 8 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _error = _isZh ? '两次密码输入不一致' : 'Passwords do not match');
      return;
    }
    if (!_agreedToTerms) {
      setState(() => _error = _isZh ? '请同意服务条款和隐私政策' : 'Please agree to the Terms of Service');
      return;
    }

    setState(() { _isLoading = true; _error = ''; });

    try {
      final api = Get.find<ApiService>();
      final res = await api.register(
        _emailController.text.trim(),
        password,
        code: _codeController.text.trim().isNotEmpty ? _codeController.text.trim() : null,
        nameEn: _nameEnController.text.trim().isNotEmpty ? _nameEnController.text.trim() : null,
        nameZh: _nameZhController.text.trim().isNotEmpty ? _nameZhController.text.trim() : null,
      );

      if (res.statusCode == 201 || res.statusCode == 200) {
        final token = res.body['token'];
        final storage = Get.find<StorageService>();
        await storage.saveAuthToken(token);
        await storage.saveLoginInfo(_emailController.text.trim(), true);
        await Get.find<AuthController>().loadProfile();
        Get.offAllNamed('/main');
      } else {
        setState(() { _error = res.body?['message'] ?? (_isZh ? '注册失败' : 'Registration failed'); _isLoading = false; });
      }
    } catch (_) {
      setState(() { _error = _isZh ? '注册失败，请稍后重试' : 'Registration failed, please try again'; _isLoading = false; });
    }
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
        title: Text(_isZh ? '注册账号' : 'Create Account', style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Step indicator
                Row(
                  children: List.generate(3, (i) => Expanded(
                    child: Container(
                      height: 4,
                      margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: i <= _step ? _primaryColor : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )),
                ),
                const SizedBox(height: 8),
                // Step labels
                Row(
                  children: [
                    Expanded(child: Text(_isZh ? '邮箱' : 'Email', textAlign: TextAlign.left, style: TextStyle(fontSize: 10, color: _step >= 0 ? _primaryColor : Colors.grey.shade400))),
                    Expanded(child: Text(_isZh ? '验证' : 'Verify', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: _step >= 1 ? _primaryColor : Colors.grey.shade400))),
                    Expanded(child: Text(_isZh ? '完成' : 'Complete', textAlign: TextAlign.right, style: TextStyle(fontSize: 10, color: _step >= 2 ? _primaryColor : Colors.grey.shade400))),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  _step == 0 ? (_isZh ? '输入邮箱' : 'Enter Email')
                    : _step == 1 ? (_isZh ? '验证邮箱' : 'Verify Email')
                    : (_isZh ? '完善信息' : 'Complete Profile'),
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                Text(
                  _step == 0 ? (_isZh ? '我们将发送验证码到您的邮箱' : 'We will send a verification code')
                    : _step == 1 ? (_isZh ? '请输入邮箱收到的4位或6位验证码' : 'Enter the 4-digit or 6-digit code from your email')
                    : (_isZh ? '设置密码并完善个人信息' : 'Set your password and profile info'),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),
                if (_error.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Row(children: [
                      Icon(Icons.error_outline, size: 18, color: Colors.red.shade600),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_error, style: TextStyle(fontSize: 13, color: Colors.red.shade700))),
                    ]),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_step == 0) ..._buildEmailStep(),
                if (_step == 1) ..._buildCodeStep(),
                if (_step == 2) ..._buildPasswordStep(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEmailStep() => [
    TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: _isZh ? '邮箱地址' : 'Email Address',
        hintText: _isZh ? '请输入您的邮箱' : 'Enter your email address',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    const SizedBox(height: 24),
    SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _sendCode,
        style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(_isZh ? '发送验证码' : 'Send Code', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    ),
    const SizedBox(height: 16),
    Center(
      child: TextButton(
        onPressed: () => Get.back(),
        child: Text.rich(
          TextSpan(
            text: _isZh ? '已有账号？' : 'Already have an account? ',
            style: TextStyle(color: Colors.grey.shade600),
            children: [
              TextSpan(text: _isZh ? '去登录' : 'Sign In', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    ),
  ];

  List<Widget> _buildCodeStep() => [
    Text(
      '${_isZh ? '验证码已发送至' : 'Code sent to'} ${_emailController.text.trim()}',
      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
    ),
    const SizedBox(height: 16),
    TextField(
      controller: _codeController,
      keyboardType: TextInputType.number,
      maxLength: 6,
      style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: '000000',
        counterText: '',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    const SizedBox(height: 16),
    Center(
      child: _countdown > 0
          ? Text('${_isZh ? '重新发送' : 'Resend in'} ${_countdown}s', style: TextStyle(color: Colors.grey.shade500))
          : TextButton(onPressed: _sendCode, child: Text(_isZh ? '重新发送验证码' : 'Resend Code', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold))),
    ),
    const SizedBox(height: 24),
    SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: _verifyCode,
        style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: Text(_isZh ? '验证' : 'Verify', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    ),
  ];

  List<Widget> _buildPasswordStep() => [
    // Password field
    TextField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: _isZh ? '设置密码' : 'Password',
        hintText: _isZh ? '至少8位字符' : 'At least 8 characters',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // Password strength indicator
    if (_passwordController.text.isNotEmpty) ...[
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (_passwordStrength + 1) / 3,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(_strengthLabel, style: TextStyle(fontSize: 12, color: _strengthColor, fontWeight: FontWeight.bold)),
        ],
      ),
    ],
    const SizedBox(height: 16),
    // Confirm password
    TextField(
      controller: _confirmController,
      obscureText: _obscureConfirm,
      decoration: InputDecoration(
        labelText: _isZh ? '确认密码' : 'Confirm Password',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    const SizedBox(height: 24),
    // Divider with label
    Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(_isZh ? '个人信息（选填）' : 'Profile (Optional)', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    ),
    const SizedBox(height: 16),
    // Name EN
    TextField(
      controller: _nameEnController,
      decoration: InputDecoration(
        labelText: 'Name (English)',
        hintText: 'e.g. John Doe',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    const SizedBox(height: 16),
    // Name ZH
    TextField(
      controller: _nameZhController,
      decoration: InputDecoration(
        labelText: '姓名（中文）',
        hintText: '例如：张三',
        prefixIcon: const Icon(Icons.person_outline),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    const SizedBox(height: 20),
    // Terms agreement
    Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24, height: 24,
          child: Checkbox(
            value: _agreedToTerms,
            onChanged: (v) => setState(() => _agreedToTerms = v ?? false),
            activeColor: _primaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
            child: Text.rich(
              TextSpan(
                text: _isZh ? '我已阅读并同意' : 'I agree to the ',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                children: [
                  TextSpan(text: _isZh ? '服务条款' : 'Terms of Service', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600)),
                  TextSpan(text: _isZh ? '和' : ' and '),
                  TextSpan(text: _isZh ? '隐私政策' : 'Privacy Policy', style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 24),
    // Register button
    SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _register,
        style: ElevatedButton.styleFrom(backgroundColor: _primaryColor, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        child: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(_isZh ? '完成注册' : 'Create Account', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    ),
  ];
}
