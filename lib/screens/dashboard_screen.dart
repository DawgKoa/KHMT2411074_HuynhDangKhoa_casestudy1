import 'package:flutter/material.dart';
import '../main.dart'; // Import WelcomeScreen
import 'them_screen.dart';
import 'sua_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(scaffoldKey: _scaffoldKey),
      const Center(child: Text('Màn hình Giao dịch', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      const Center(child: Text('Màn hình Thống kê', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8F9FA),
      // ============================================================
      // DRAWER – Menu trượt khi bấm nút 3 gạch ngang
      // ============================================================
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              // Header của Drawer
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4D8CF7), Color(0xFF1769E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(Icons.account_balance_wallet, size: 48, color: Colors.white),
                    SizedBox(height: 12),
                    Text(
                      'Expense Manager',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Quản lý chi tiêu cá nhân',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Mục "Bắt đầu" – quay về WelcomeScreen
              ListTile(
                leading: const Icon(Icons.home_outlined, color: Color(0xFF1769E0)),
                title: const Text('Bắt đầu', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.pop(context); // Đóng drawer
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: pages[_currentIndex],
      ),
      // Nút (+) nổi ở góc phải
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1769E0),
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          // Điều hướng sang màn hình Thêm giao dịch
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add, size: 36),
      )
          : null,
      // Thanh điều hướng đáy màn hình (BottomNavigationBar)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: const Color(0xFF1769E0),
        unselectedItemColor: const Color(0xFF263238),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Giao dịch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: 'Thống kê',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NỘI DUNG CHÍNH CỦA TRANG CHỦ (HomeContent)
// ---------------------------------------------------------------------------
class HomeContent extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeContent({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderSection(scaffoldKey: scaffoldKey),
          const SizedBox(height: 20),
          const BalanceCard(),
          const SizedBox(height: 20),
          const SummarySection(),
          const SizedBox(height: 28),
          const TransactionHeader(),
          const SizedBox(height: 12),
          const TransactionList(),
        ],
      ),
    );
  }
}

// 1. THANH TIÊU ĐỀ (Header)
class HeaderSection extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HeaderSection({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu, size: 28),
        ),
        const SizedBox(width: 4),
        const Expanded(
          child: Text(
            'Quản lý thu chi',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // Chuông thông báo có badge đỏ
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, size: 28),
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert, size: 26, color: Colors.black87),
        ),
      ],
    );
  }
}

// 2. THẺ SỐ DƯ (BalanceCard với Gradient & Icon ví chìm)
class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4D8CF7),
            Color(0xFF1769E0),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1769E0).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Nội dung chính của Thẻ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'SỐ DƯ HIỆN TẠI',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isBalanceVisible = !_isBalanceVisible;
                        });
                      },
                      child: Icon(
                        _isBalanceVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text(
                    _isBalanceVisible ? '5.000.000 đ' : '******',
                    key: ValueKey<bool>(_isBalanceVisible),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Chấm tròn chỉ báo slider (dots indicator)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 22,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _dot(),
                    const SizedBox(width: 6),
                    _dot(),
                    const SizedBox(width: 6),
                    _dot(),
                  ],
                ),
              ],
            ),
          ),
          // Biểu tượng Ví tiền chìm ở góc phải
          Positioned(
            right: 15,
            bottom: 20,
            child: Icon(
              Icons.account_balance_wallet,
              size: 90,
              color: Colors.white.withOpacity(0.12),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _dot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}

// 3. KHU VỰC THỐNG KÊ THU / CHI (SummarySection)
class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: SummaryCard(
            title: 'TỔNG THU NHẬP',
            amount: '8.000.000 đ',
            icon: Icons.arrow_downward,
            iconColor: Color(0xFF2EAD4B),
            backgroundColor: Color(0xFFEAF8EB),
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: SummaryCard(
            title: 'TỔNG CHI TIÊU',
            amount: '3.000.000 đ',
            icon: Icons.arrow_upward,
            iconColor: Color(0xFFE53935),
            backgroundColor: Color(0xFFFFEFF0),
          ),
        ),
      ],
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.18),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF555555),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 4. TIÊU ĐỀ GIAO DỊCH GẦN ĐÂY
class TransactionHeader extends StatelessWidget {
  const TransactionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Giao dịch gần đây',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Xem tất cả',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1769E0),
            ),
          ),
        ),
      ],
    );
  }
}

// 5. DANH SÁCH GIAO DỊCH GẦN ĐÂY (ListView.separated)
class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  static const List<TransactionItemData> dummyData = [
    TransactionItemData(
      title: 'Ăn trưa',
      category: 'Ăn uống',
      date: '03/09/2024',
      amount: '-50.000 đ',
      icon: Icons.restaurant,
      color: Color(0xFFFF6D00),
    ),
    TransactionItemData(
      title: 'Xăng xe',
      category: 'Di chuyển',
      date: '03/09/2024',
      amount: '-100.000 đ',
      icon: Icons.directions_car,
      color: Color(0xFF2196F3),
    ),
    TransactionItemData(
      title: 'Lương tháng 9',
      category: 'Thu nhập',
      date: '01/09/2024',
      amount: '+8.000.000 đ',
      icon: Icons.attach_money,
      color: Color(0xFF2EAD4B),
    ),
    TransactionItemData(
      title: 'Mua sắm',
      category: 'Mua sắm',
      date: '31/08/2024',
      amount: '-300.000 đ',
      icon: Icons.shopping_cart,
      color: Color(0xFF9C27B0),
    ),
    TransactionItemData(
      title: 'Học phí',
      category: 'Giáo dục',
      date: '30/08/2024',
      amount: '-500.000 đ',
      icon: Icons.school,
      color: Color(0xFF009688),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: dummyData.length,
        separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final item = dummyData[index];
          final isIncome = item.amount.startsWith('+');

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: item.color,
                  child: Icon(item.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            item.category,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            item.date,
                            style: const TextStyle(fontSize: 13, color: Color(0xFF667085)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  item.amount,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isIncome ? const Color(0xFF2EAD4B) : const Color(0xFFE53935),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class TransactionItemData {
  final String title;
  final String category;
  final String date;
  final String amount;
  final IconData icon;
  final Color color;

  const TransactionItemData({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.icon,
    required this.color,
  });
}