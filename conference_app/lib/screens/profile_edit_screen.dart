import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/api_service.dart';
import '../theme/app_theme.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _nameEnController = TextEditingController();
  final _nameZhController = TextEditingController();
  final _titleEnController = TextEditingController();
  final _titleZhController = TextEditingController();
  final _orgEnController = TextEditingController();
  final _orgZhController = TextEditingController();
  final _avatarUrlController = TextEditingController();

  bool _isLoading = false;
  bool _hasChanges = false;

  bool get _isZh => Get.locale?.languageCode == '__zh_disabled__';
  static const Color _primaryColor = AppColors.primary;

  @override
  void initState() {
    super.initState();
    final auth = Get.find<AuthController>();
    final user = auth.currentUser.value;
    if (user != null) {
      _nameEnController.text = user.nameEn;
      _nameZhController.text = user.nameEn;
      _titleEnController.text = user.titleEn;
      _titleZhController.text = user.titleEn;
      _orgEnController.text = user.organizationEn;
      _orgZhController.text = user.organizationEn;
      _avatarUrlController.text = user.avatarUrl;
    }
    // Listen for changes
    for (final c in [
      _nameEnController,
      _nameZhController,
      _titleEnController,
      _titleZhController,
      _orgEnController,
      _orgZhController,
      _avatarUrlController,
    ]) {
      c.addListener(() {
        if (!_hasChanges) setState(() => _hasChanges = true);
      });
    }
  }

  @override
  void dispose() {
    _nameEnController.dispose();
    _nameZhController.dispose();
    _titleEnController.dispose();
    _titleZhController.dispose();
    _orgEnController.dispose();
    _orgZhController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final api = Get.find<ApiService>();
      final data = {
        'nameEn': _nameEnController.text.trim(),
        'nameZh': _nameEnController.text.trim(),
        'titleEn': _titleEnController.text.trim(),
        'titleZh': _titleEnController.text.trim(),
        'organizationEn': _orgEnController.text.trim(),
        'organizationZh': _orgEnController.text.trim(),
        'avatarUrl': _avatarUrlController.text.trim(),
      };
      final res = await api.updateProfile(data);
      if (res.statusCode == 200) {
        // Refresh profile
        final auth = Get.find<AuthController>();
        await auth.loadProfile();
        Get.back();
        Get.snackbar(
          _isZh ? 'Saved' : 'Saved',
          _isZh
              ? 'Profile updated successfully'
              : 'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: _primaryColor,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          _isZh ? 'Error' : 'Error',
          res.body?['message'] ??
              (_isZh ? 'Please try again' : 'Please try again'),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (_) {
      Get.snackbar(
        _isZh ? 'Network Error' : 'Network Error',
        _isZh ? 'Unable to connect to server' : 'Unable to connect to server',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _primaryColor),
          onPressed: () {
            if (_hasChanges) {
              Get.dialog(
                AlertDialog(
                  title: Text(_isZh ? 'Discard Changes?' : 'Discard Changes?'),
                  content: Text(
                    _isZh
                        ? 'You have unsaved changes'
                        : 'You have unsaved changes',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(_isZh ? 'Keep Editing' : 'Keep Editing'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_isZh ? 'Discard' : 'Discard'),
                    ),
                  ],
                ),
              );
            } else {
              Get.back();
            }
          },
        ),
        title: Text(
          _isZh ? 'Edit Profile' : 'Edit Profile',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _primaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: (_isLoading || !_hasChanges) ? null : _save,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _isZh ? 'Save' : 'Save',
                    style: TextStyle(
                      color: _hasChanges ? _primaryColor : Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar preview
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _primaryColor.withAlpha(50),
                        width: 3,
                      ),
                      color: Colors.grey.shade100,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _avatarUrlController.text.isNotEmpty
                        ? Image.network(
                            _avatarUrlController.text,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 48,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isZh ? 'Avatar' : 'Avatar',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Avatar URL
            _buildField(
              controller: _avatarUrlController,
              label: _isZh ? 'Avatar URL' : 'Avatar URL',
              hint: 'https://example.com/avatar.jpg',
              icon: Icons.link,
            ),
            const SizedBox(height: 32),
            _buildSectionLabel(_isZh ? 'Name' : 'Name'),
            const SizedBox(height: 12),
            _buildField(
              controller: _nameEnController,
              label: 'Name (English)',
              hint: 'John Doe',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 32),
            _buildSectionLabel(_isZh ? 'Title' : 'Title'),
            const SizedBox(height: 12),
            _buildField(
              controller: _titleEnController,
              label: 'Title (English)',
              hint: 'Professor / Director',
              icon: Icons.badge_outlined,
            ),
            const SizedBox(height: 32),
            _buildSectionLabel(_isZh ? 'Organization' : 'Organization'),
            const SizedBox(height: 12),
            _buildField(
              controller: _orgEnController,
              label: 'Organization (English)',
              hint: 'University / Hospital',
              icon: Icons.business_outlined,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: _primaryColor,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
      ),
    );
  }
}
