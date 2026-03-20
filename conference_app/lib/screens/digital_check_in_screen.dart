import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class DigitalCheckInScreen extends StatefulWidget {
  const DigitalCheckInScreen({super.key});

  @override
  State<DigitalCheckInScreen> createState() => _DigitalCheckInScreenState();
}

class _DigitalCheckInScreenState extends State<DigitalCheckInScreen> {
  int _secondsRemaining = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _secondsRemaining = 30; // Reset timer
          // In a real app, you would also refresh the QR code data here
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000666);
    const Color backgroundColor = Color(0xFFF3FAFF);
    const Color accentColor = Color(0xFFFFDEA5);
    const Color surfaceContainerColor = Color(0xFFDBF1FE);
    const Color textColor = Color(0xFF071E27);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: primaryColor),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    Get.locale?.languageCode == 'zh' ? '数字通行证' : 'DIGITAL PASS',
                    style: TextStyle(
                      fontFamily: 'Noto Serif',
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: primaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    'EN/ZH',
                    style: TextStyle(
                      fontFamily: 'Noto Serif',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    // Ticket Container
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((0.05 * 255).round()),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // VIP Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'VIP ACCESS',
                                  style: TextStyle(
                                    fontFamily: 'Noto Serif',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                Text(
                                  'ENTRY ID: AE-2024-8892',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white.withAlpha((0.6 * 255).round()),
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                // Profile
                                Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: surfaceContainerColor, width: 3),
                                    image: const DecorationImage(
                                      image: NetworkImage('https://images.unsplash.com/photo-1559839734-2b71ea197ec2?q=80&w=200&auto=format&fit=crop'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  Get.locale?.languageCode == 'zh' ? '埃利斯泰尔·索恩 博士' : 'Dr. Alistair Thorne',
                                  style: TextStyle(
                                    fontFamily: 'Noto Serif',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  Get.locale?.languageCode == 'zh' ? '高级肿瘤学研究员' : 'SENIOR ONCOLOGY CURATOR',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade600,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // QR Code
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [accentColor, const Color(0xFFB6924C)],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.qr_code_2, size: 160, color: textColor),
                                  ),
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Event Details
                                Text(
                                  Get.locale?.languageCode == 'zh' ? '2026 全球肿瘤学创新峰会' : 'Global Oncology Summit 2026',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Noto Serif',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                
                                const SizedBox(height: 24),
                                const Divider(),
                                const SizedBox(height: 24),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'DATE / 日期',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Oct 24 - 26',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'HALL / 会场',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade500,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Grand Atrium',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 32),
                                
                                // Refresh Timer
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F6FF),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.sync, size: 16, color: primaryColor),
                                      const SizedBox(width: 8),
                                      Text(
                                        'CODE REFRESHES IN: ',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      Text(
                                        '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Save to Wallet Button
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.file_download, color: Colors.black87),
                      label: const Text(
                        'Save to Apple Wallet',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        minimumSize: const Size(double.infinity, 56),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
