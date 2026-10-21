import 'package:flutter/material.dart';
import '../main.dart'; // Để chuyển về WelcomeScreen khi đăng xuất

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Nguyễn Văn A';
  String _email = 'nguyenvana@example.com';
  String _phone = '0987654321';
  double _monthlyBudget = 10000000;
  double _alertThreshold = 80;

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
                        children: [
                          Text(
                            _name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Color(0xFF1769E0), size: 22),
                      tooltip: 'Chỉnh sửa thông tin',
                      onPressed: _showEditProfileSheet,
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
                      onTap: _showEditProfileSheet,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.tune,
                      title: 'Cài đặt ngân sách',
                      onTap: _showBudgetSheet,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.format_list_bulleted,
                      title: 'Danh mục chi tiêu',
                      onTap: _showCategoriesSheet,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.cloud_upload_outlined,
                      title: 'Sao lưu dữ liệu',
                      onTap: _showBackupDialog,
                    ),
                    _buildDivider(),
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Đổi mật khẩu',
                      onTap: _showChangePasswordDialog,
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

  // 1. Chỉnh sửa Thông tin cá nhân
  void _showEditProfileSheet() {
    final nameCtrl = TextEditingController(text: _name);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _phone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Thông tin cá nhân',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: 'Họ và tên',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Số điện thoại',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1769E0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  setState(() {
                    _name = nameCtrl.text.trim().isNotEmpty ? nameCtrl.text.trim() : _name;
                    _email = emailCtrl.text.trim().isNotEmpty ? emailCtrl.text.trim() : _email;
                    _phone = phoneCtrl.text.trim().isNotEmpty ? phoneCtrl.text.trim() : _phone;
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã cập nhật thông tin cá nhân!'),
                      backgroundColor: Color(0xFF2EAD4B),
                    ),
                  );
                },
                child: const Text('Lưu thay đổi', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Cài đặt ngân sách
  void _showBudgetSheet() {
    double tempBudget = _monthlyBudget;
    double tempAlert = _alertThreshold;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cài đặt ngân sách chi tiêu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Hạn mức chi tiêu hàng tháng:'),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: tempBudget,
                      min: 1000000,
                      max: 50000000,
                      divisions: 49,
                      activeColor: const Color(0xFF1769E0),
                      onChanged: (val) => setSheetState(() => tempBudget = val),
                    ),
                  ),
                  Text(
                    '${(tempBudget / 1000000).toStringAsFixed(1)} tr',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text('Cảnh báo khi đạt ${tempAlert.toInt()}% ngân sách:'),
              Slider(
                value: tempAlert,
                min: 50,
                max: 100,
                divisions: 10,
                activeColor: const Color(0xFFFFA726),
                onChanged: (val) => setSheetState(() => tempAlert = val),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1769E0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    setState(() {
                      _monthlyBudget = tempBudget;
                      _alertThreshold = tempAlert;
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đã cập nhật cài đặt ngân sách!'),
                        backgroundColor: Color(0xFF2EAD4B),
                      ),
                    );
                  },
                  child: const Text('Lưu cài đặt', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 3. Danh mục chi tiêu
  void _showCategoriesSheet() {
    final categories = [
      {'name': 'Ăn uống', 'icon': Icons.restaurant, 'color': const Color(0xFFEF5350)},
      {'name': 'Di chuyển', 'icon': Icons.directions_car, 'color': const Color(0xFFAB47BC)},
      {'name': 'Mua sắm', 'icon': Icons.shopping_cart, 'color': const Color(0xFF29B6F6)},
      {'name': 'Học tập', 'icon': Icons.school, 'color': const Color(0xFF5C6BC0)},
      {'name': 'Giải trí', 'icon': Icons.sports_esports, 'color': const Color(0xFFFFA726)},
      {'name': 'Lương / Thu nhập', 'icon': Icons.attach_money, 'color': const Color(0xFF66BB6A)},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Danh mục chi tiêu & thu nhập',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: categories.length,
                separatorBuilder: (c, i) => const Divider(height: 1),
                itemBuilder: (c, i) {
                  final cat = categories[i];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: (cat['color'] as Color).withValues(alpha: 0.18),
                      child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 20),
                    ),
                    title: Text(cat['name'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.check_circle, color: Color(0xFF2EAD4B), size: 20),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 4. Sao lưu dữ liệu
  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Sao lưu & Đồng bộ'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• Bản sao lưu gần nhất: Hôm nay, 08:30'),
            SizedBox(height: 8),
            Text('• Cơ sở dữ liệu SQLite đã được bảo vệ an toàn trên thiết bị của bạn.'),
            SizedBox(height: 8),
            Text('Nhấn "Sao lưu ngay" để đồng bộ dữ liệu mới nhất.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Đóng'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1769E0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: const Icon(Icons.cloud_done_outlined, size: 18),
            label: const Text('Sao lưu ngay'),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sao lưu dữ liệu thành công!'),
                  backgroundColor: Color(0xFF2EAD4B),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // 5. Đổi mật khẩu
  void _showChangePasswordDialog() {
    final oldPassCtrl = TextEditingController();
    final newPassCtrl = TextEditingController();
    final confirmPassCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đổi mật khẩu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPassCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPassCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmPassCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Nhập lại mật khẩu mới',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1769E0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              if (newPassCtrl.text.isEmpty || oldPassCtrl.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập đầy đủ các trường!')),
                );
                return;
              }
              if (newPassCtrl.text != confirmPassCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mật khẩu xác nhận không trùng khớp!')),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đổi mật khẩu thành công!'),
                  backgroundColor: Color(0xFF2EAD4B),
                ),
              );
            },
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  // 6. Dialog xác nhận đăng xuất
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
