import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../utils/transaction_helper.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => StatisticsScreenState();
}

class StatisticsScreenState extends State<StatisticsScreen> {
  String _selectedPeriod = 'this_month'; // 'this_month', 'last_month', 'this_year'
  List<CategoryStatItem> _stats = [];
  double _totalExpense = 0.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStatistics();
  }

  // Load thống kê từ SQLite theo kỳ thời gian
  Future<void> loadStatistics() async {
    setState(() => _isLoading = true);
    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate;

    if (_selectedPeriod == 'this_month') {
      startDate = DateTime(now.year, now.month, 1);
      endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    } else if (_selectedPeriod == 'last_month') {
      startDate = DateTime(now.year, now.month - 1, 1);
      endDate = DateTime(now.year, now.month, 0, 23, 59, 59);
    } else {
      // this_year
      startDate = DateTime(now.year, 1, 1);
      endDate = DateTime(now.year, 12, 31, 23, 59, 59);
    }

    try {
      final rawStats = await DatabaseHelper.instance.getCategoryStatistics(
        startDate: startDate,
        endDate: endDate,
        type: 'expense',
      );

      // Nếu trong tháng này chưa có phát sinh, thử tải toàn bộ các kỳ để luôn có dữ liệu hiển thị đẹp
      List<Map<String, dynamic>> finalData = rawStats;
      if (finalData.isEmpty) {
        finalData = await DatabaseHelper.instance.getCategoryStatistics(type: 'expense');
      }

      double total = 0.0;
      for (final item in finalData) {
        total += (item['total'] as num?)?.toDouble() ?? 0.0;
      }

      final List<CategoryStatItem> items = [];
      for (final item in finalData) {
        final category = item['category'] as String? ?? 'Khác';
        final amount = (item['total'] as num?)?.toDouble() ?? 0.0;
        final percentage = total > 0 ? (amount / total * 100) : 0.0;
        items.add(CategoryStatItem(
          category: category,
          amount: amount,
          percentage: percentage,
          color: TransactionHelper.getCategoryColor(category),
        ));
      }

      if (mounted) {
        setState(() {
          _stats = items;
          _totalExpense = total;
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Tiêu đề AppBar
              const Text(
                'Thống kê',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Cụm nút lọc thời gian: [Tháng này] - [Tháng trước] - [Năm nay]
              Row(
                children: [
                  _buildPeriodTab('Tháng này', 'this_month'),
                  const SizedBox(width: 8),
                  _buildPeriodTab('Tháng trước', 'last_month'),
                  const SizedBox(width: 8),
                  _buildPeriodTab('Năm nay', 'this_year'),
                ],
              ),
              const SizedBox(height: 28),

              // 3. Biểu đồ tròn Donut Chart
              Center(
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(250, 250),
                        painter: DonutChartPainter(items: _stats),
                      ),
                      // Chữ ở trung tâm biểu đồ
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            TransactionHelper.formatCurrency(_totalExpense),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tổng chi tiêu',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 4. Danh sách chi tiết danh mục (Legend & Breakdown)
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_stats.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Text(
                      'Chưa có dữ liệu chi tiêu trong kỳ này',
                      style: TextStyle(color: Color(0xFF9CA3AF)),
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _stats.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 32, endIndent: 8),
                    itemBuilder: (context, index) {
                      final item = _stats[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          children: [
                            // Chấm tròn màu tương ứng
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Tên danh mục
                            Expanded(
                              child: Text(
                                item.category,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            // Số tiền
                            Text(
                              TransactionHelper.formatCurrency(item.amount),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 14),

                            // Phần trăm %
                            SizedBox(
                              width: 44,
                              child: Text(
                                '${item.percentage.toStringAsFixed(0)}%',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Nút chuyển kỳ thống kê
  Widget _buildPeriodTab(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedPeriod != value) {
            setState(() => _selectedPeriod = value);
            loadStatistics();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1769E0) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
            ),
          ),
        ),
      ),
    );
  }
}

// Model thống kê theo từng danh mục
class CategoryStatItem {
  final String category;
  final double amount;
  final double percentage;
  final Color color;

  CategoryStatItem({
    required this.category,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

// Custom Painter vẽ biểu đồ Donut Chart (Hình chiếc nhẫn khuyết ở giữa)
class DonutChartPainter extends CustomPainter {
  final List<CategoryStatItem> items;

  DonutChartPainter({required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 36.0;

    if (items.isEmpty) {
      final paint = Paint()
        ..color = const Color(0xFFE5E7EB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawCircle(center, radius - strokeWidth / 2, paint);
      return;
    }

    double startAngle = -math.pi / 2;
    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    for (final item in items) {
      final sweepAngle = (item.percentage / 100) * 2 * math.pi;
      if (sweepAngle <= 0) continue;

      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}
