import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../main.dart'; // Import WelcomeScreen
import '../models/transaction_model.dart';
import '../utils/transaction_helper.dart';
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
  final GlobalKey<HomeContentState> _homeContentKey = GlobalKey<HomeContentState>();

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(
        key: _homeContentKey,
        scaffoldKey: _scaffoldKey,
      ),
      const Center(
        child: Text(
          'Màn hình Giao dịch',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      const Center(
        child: Text(
          'Màn hình Thống kê',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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
              onPressed: () async {
                // Điều hướng sang màn hình Thêm giao dịch
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
                );
                // Nếu thêm thành công -> load lại dữ liệu SQLite
                if (result == true) {
                  _homeContentKey.currentState?.loadData();
                }
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
// NỘI DUNG CHÍNH CỦA TRANG CHỦ (HomeContent) - KẾT NỐI VỚI SQLITE
// ---------------------------------------------------------------------------
class HomeContent extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeContent({super.key, required this.scaffoldKey});

  @override
  State<HomeContent> createState() => HomeContentState();
}

class HomeContentState extends State<HomeContent> {
  List<TransactionModel> _transactions = [];
  double _balance = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Load toàn bộ dữ liệu thực tế từ SQLite
  Future<void> loadData() async {
    setState(() => _isLoading = true);
    try {
      final txList = await DatabaseHelper.instance.getAllTransactions();
      final income = await DatabaseHelper.instance.getTotalIncome();
      final expense = await DatabaseHelper.instance.getTotalExpense();
      final bal = await DatabaseHelper.instance.getBalance();

      if (mounted) {
        setState(() {
          _transactions = txList;
          _totalIncome = income;
          _totalExpense = expense;
          _balance = bal;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadData,
      color: const Color(0xFF1769E0),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(scaffoldKey: widget.scaffoldKey),
            const SizedBox(height: 20),
            BalanceCard(balance: _balance),
            const SizedBox(height: 20),
            SummarySection(
              totalIncome: _totalIncome,
              totalExpense: _totalExpense,
            ),
            const SizedBox(height: 28),
            TransactionHeader(
              onViewAll: () {
                // Có thể mở tab Giao dịch hoặc hiển thị toàn bộ
              },
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : TransactionList(
                    transactions: _transactions,
                    onRefresh: loadData,
                  ),
          ],
        ),
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
  final double balance;

  const BalanceCard({super.key, required this.balance});

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
            color: const Color(0xFF1769E0).withValues(alpha: 0.3),
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
                    _isBalanceVisible
                        ? TransactionHelper.formatCurrency(widget.balance)
                        : '******',
                    key: ValueKey<bool>(_isBalanceVisible),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
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
              color: Colors.white.withValues(alpha: 0.12),
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
        color: Colors.white.withValues(alpha: 0.4),
        shape: BoxShape.circle,
      ),
    );
  }
}

// 3. KHU VỰC THỐNG KÊ THU / CHI (SummarySection)
class SummarySection extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  const SummarySection({
    super.key,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: 'TỔNG THU NHẬP',
            amount: TransactionHelper.formatCurrency(totalIncome),
            icon: Icons.arrow_downward,
            iconColor: const Color(0xFF2EAD4B),
            backgroundColor: const Color(0xFFEAF8EB),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: SummaryCard(
            title: 'TỔNG CHI TIÊU',
            amount: TransactionHelper.formatCurrency(totalExpense),
            icon: Icons.arrow_upward,
            iconColor: const Color(0xFFE53935),
            backgroundColor: const Color(0xFFFFEFF0),
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
            backgroundColor: iconColor.withValues(alpha: 0.18),
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
  final VoidCallback? onViewAll;

  const TransactionHeader({super.key, this.onViewAll});

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
          onPressed: onViewAll,
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

// 5. DANH SÁCH GIAO DỊCH (ListView) LOAD TỪ SQLITE
class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onRefresh;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          children: const [
            Icon(Icons.receipt_long_outlined, size: 50, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'Chưa có giao dịch nào',
              style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 6),
            Text(
              'Nhấn nút (+) bên dưới để thêm giao dịch đầu tiên!',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) =>
            const Divider(height: 1, indent: 16, endIndent: 16),
        itemBuilder: (context, index) {
          final item = transactions[index];
          final isIncome = item.type == 'income';
          final icon = TransactionHelper.getCategoryIcon(item.category);
          final color = TransactionHelper.getCategoryColor(item.category);

          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () async {
              // Bấm vào để sửa giao dịch
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditTransactionScreen(transaction: item),
                ),
              );
              if (result == true) {
                onRefresh();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: color,
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title.isNotEmpty ? item.title : item.category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF667085),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              DateFormat('dd/MM/yyyy').format(item.date),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF667085),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${isIncome ? '+' : '-'}${TransactionHelper.formatCurrency(item.amount)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isIncome
                          ? const Color(0xFF2EAD4B)
                          : const Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}