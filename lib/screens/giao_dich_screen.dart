import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../db/database_helper.dart';
import '../models/transaction_model.dart';
import '../utils/transaction_helper.dart';
import 'sua_screen.dart';
import 'bo_loc_screen.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all'; // 'all', 'income', 'expense'
  List<TransactionModel> _transactions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Load danh sách giao dịch có lọc theo loại và từ khóa tìm kiếm
  Future<void> loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final list = await DatabaseHelper.instance.getFilteredTransactions(
        filterType: _selectedFilter,
        searchQuery: _searchController.text,
      );
      if (mounted) {
        setState(() {
          _transactions = list;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Tiêu đề AppBar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: const Text(
                'Giao dịch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // 2. Thanh tìm kiếm kèm icon lọc
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => loadTransactions(),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm giao dịch...',
                    hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF9CA3AF)),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const FilterScreen()),
                        );
                        if (result != null && result is Map) {
                          setState(() {
                            _selectedFilter = result['type'] ?? 'all';
                          });
                          loadTransactions();
                        }
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // 3. Các nút gạt lọc: [Tất cả] - [Thu nhập] - [Chi tiêu]
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFilterTab('Tất cả', 'all'),
                  const SizedBox(width: 10),
                  _buildFilterTab('Thu nhập', 'income'),
                  const SizedBox(width: 10),
                  _buildFilterTab('Chi tiêu', 'expense'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Danh sách giao dịch
            Expanded(
              child: RefreshIndicator(
                onRefresh: loadTransactions,
                color: const Color(0xFF1769E0),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _transactions.isEmpty
                        ? _buildEmptyState()
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            itemCount: _transactions.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final item = _transactions[index];
                              return _buildTransactionCard(item);
                            },
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Nút lọc phân loại (Tất cả, Thu nhập, Chi tiêu)
  Widget _buildFilterTab(String label, String value) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () {
        if (_selectedFilter != value) {
          setState(() => _selectedFilter = value);
          loadTransactions();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1769E0) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }

  // Thẻ giao dịch hiển thị theo phong cách Mockup 3
  Widget _buildTransactionCard(TransactionModel item) {
    final isIncome = item.type == 'income';
    final icon = TransactionHelper.getCategoryIcon(item.category);
    final color = TransactionHelper.getCategoryColor(item.category);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EditTransactionScreen(transaction: item),
          ),
        );
        if (result == true) {
          loadTransactions();
        }
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            // Icon trong khung bo tròn
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 14),

            // Tên danh mục / Tiêu đề và ngày
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.isNotEmpty ? item.title : item.category,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('dd/MM/yyyy').format(item.date),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),

            // Số tiền (+ / -)
            Text(
              '${isIncome ? '+' : '-'}${TransactionHelper.formatCurrency(item.amount)}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isIncome
                    ? const Color(0xFF2EAD4B)
                    : const Color(0xFFEF5350),
              ),
            ),
            const SizedBox(width: 6),

            // Mũi tên chevron
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

  // Trạng thái trống
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
          child: Column(
            children: const [
              Icon(Icons.search_off_rounded, size: 64, color: Color(0xFFD1D5DB)),
              SizedBox(height: 16),
              Text(
                'Không tìm thấy giao dịch nào',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B7280),
                ),
              ),
              SizedBox(height: 6),
              Text(
                'Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
