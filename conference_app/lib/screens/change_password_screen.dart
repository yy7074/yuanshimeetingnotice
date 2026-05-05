import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  static const Color _primary = Color(0xFF196EE6);
  static const Color _bg = Color(0xFFF6F7F8);
  static const Color _text = Color(0xFF0F172A);

  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _submitting = false;
  String _error = '';

  bool get _isZh => Get.locale?.languageCode == 'zh';

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final current = _currentCtrl.text;
    final next = _newCtrl.text;
    final confirm = _confirmCtrl.text;

    if (current.isEmpty || next.isEmpty || confirm.isEmpty) {
      setState(() => _error = _isZh ? '请填写所有字段' : 'Please fill all fields');
      return;
    }
    if (next.length < 8) {
      setState(() => _error = _isZh ? '新密码至少8位' : 'New password must be 8+ chars');
      return;
    }
    if (next != confirm) {
      setState(() => _error = _isZh ? '两次密码不一致' : 'Passwords do not match');
      return;
    }
    if (next == current) {
      setState(() => _error =
          _isZh ? '新密码不能与当前密码相同' : 'New password must differ from current');
      return;
    }

    setState(() {
      _submitting = true;
      _error = '';
    });
    final auth = Get.find<AuthController>();
    final ok = await auth.changePassword(
      currentPassword: current,
      newPassword: next,
    );
    setState(() => _submitting = false);
    if (ok) {
      if (!mounted) return;
      Get.snackbar(
        _isZh ? '密码已更新' : 'Password Updated',
        _isZh ? '请使用新密码重新登录' : 'Please sign in with your new password.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: _primary,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      Get.offAllNamed('/login');
    } else {
      setState(() => _error = auth.errorMessage.value);
    }
  }

  Future<void> _logout() async {
    final auth = Get.find<AuthController>();
    await auth.logout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                _isZh ? '设置新密码' : 'Set a new password',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: _text,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isZh
                    ? '为保障账户安全，请先修改密码后再继续使用。'
                    : 'For your account safety, please change your password before continuing.',
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
              const SizedBox(height: 24),
              _PasswordField(
                label: _isZh ? '当前密码' : 'Current Password',
                controller: _currentCtrl,
                obscure: _obscureCurrent,
                onToggle: () =>
                    setState(() => _obscureCurrent = !_obscureCurrent),
              ),
              const SizedBox(height: 16),
              _PasswordField(
                label: _isZh ? '新密码（至少8位）' : 'New Password (min 8)',
                controller: _newCtrl,
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              const SizedBox(height: 16),
              _PasswordField(
                label: _isZh ? '确认新密码' : 'Confirm New Password',
                controller: _confirmCtrl,
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
              ),
              if (_error.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _error,
                    style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          _isZh ? '更新密码' : 'Update Password',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _submitting ? null : _logout,
                child: Text(
                  _isZh ? '退出登录' : 'Sign out',
                  style: const TextStyle(color: _primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final VoidCallback onToggle;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.obscure,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: onToggle,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}
