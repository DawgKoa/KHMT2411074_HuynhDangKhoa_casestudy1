import 'package:flutter/material.dart';
import '../main.dart'; // Để chuyển về WelcomeScreen khi đăng xuất

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tiêu đề AppBar
              const Text(
                'Cá nhân',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Thẻ thông tin người dùng (Avatar + Tên + Email)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    // Avatar tròn màu xanh
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFF90CAF9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Tên và email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Nguyễn Văn A',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'nguyenvana@example.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Danh sách menu chức năng
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Thông tin cá nhân',
                      onTap: () => _showFeatureDialog(context, 'Thông tin cá nhân'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.tune,
                      title: 'Cài đặt ngân sách',
                      onTap: () => _showFeatureDialog(context, 'Cài đặt ngân sách'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.format_list_bulleted,
                      title: 'Danh mục chi tiêu',
                      onTap: () => _showFeatureDialog(context, 'Danh mục chi tiêu'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.cloud_upload_outlined,
                      title: 'Sao lưu dữ liệu',
                      onTap: () => _showFeatureDialog(context, 'Sao lưu dữ liệu'),
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Đổi mật khẩu',
                      onTap: () => _showFeatureDialog(context, 'Đổi mật khẩu'),
                    ),
                    _buildDivider(),
                    // Mục Đăng xuất (màu đỏ)
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Đăng xuất',
                      titleColor: const Color(0xFFEF5350),
                      iconColor: const Color(0xFFEF5350),
                      onTap: () => _confirmLogout(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget hiển thị từng dòng menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color titleColor = const Color(0xFF1F2937),
    Color iconColor = const Color(0xFF4B5563),
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 54,
      endIndent: 16,
      color: Color(0xFFF3F4F6),
    );
  }

  // Dialog thông báo tính năng
  void _showFeatureDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: Text('Chức năng "$title" đang trong quá trình phát triển.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  // Dialog xác nhận đăng xuất
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Xác nhận đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất khỏi ứng dụng không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
