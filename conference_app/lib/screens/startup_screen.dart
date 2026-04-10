import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/storage_service.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final auth = Get.find<AuthController>();
    final storage = Get.find<StorageService>();

    if (storage.authToken != null) {
      while (!auth.isReady.value) {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
    }

    if (!mounted) return;

    if (auth.currentUser.value != null) {
      Get.offAllNamed('/main');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF196EE6);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF438AEE), Color(0xFF196EE6), Color(0xFF0F52B2)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.monitor_heart_rounded, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'APSCVIR',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              Get.locale?.languageCode == 'zh' ? '正在检查登录状态...' : 'Checking your session...',
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
