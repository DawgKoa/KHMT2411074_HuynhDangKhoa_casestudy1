import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Widget tự vẽ icon cái ví kẹp tiền y chang mẫu
              SizedBox(
                width: 150,
                height: 130,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    // Tiền màu xanh lá nhô lên phía sau
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 95,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF66BB6A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      child: Container(
                        width: 105,
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    // Thân ví màu xanh dương bo tròn
                    Container(
                      width: 145,
                      height: 95,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1976D2),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    // Nắp gập có khuy bấm bên phải
                    Positioned(
                      right: 0,
                      bottom: 24,
                      child: Container(
                        width: 54,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),                              offset: const Offset(-2, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 14),
                        child: Container(
                          width: 13,
                          height: 13,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Tiêu đề chính
              const Text(
                'Expense Manager',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 16),

              // Dòng chữ phụ
              const Text(
                'Quản lý chi tiêu cá nhân\nđơn giản và hiệu quả',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 4),

              // Nút Bắt đầu
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
