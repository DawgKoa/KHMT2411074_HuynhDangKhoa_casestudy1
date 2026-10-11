import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatefulWidget {
  final String initialType;
  final String initialCategory;
  final String initialPeriod;

  const FilterScreen({
    super.key,
    this.initialType = 'all',
    this.initialCategory = 'Tất cả danh mục',
    this.initialPeriod = 'today',
  });

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // 1. Loại giao dịch: 'all', 'income', 'expense'
  late String _selectedType;

  // 2. Danh mục
  late String _selectedCategory;
  final List<String> _categories = [
    'Tất cả danh mục',
    'Ăn uống',
    'Di chuyển',
    'Đi lại',
    'Lương',
    'Thu nhập',
    'Mua sắm',
    'Học tập',
    'Giáo dục',
    'Giải trí',
    'Khác',
  ];

  // 3. Khoảng thời gian: 'today', '7_days', 'this_month', 'custom'
  late String _selectedPeriod;
  DateTimeRange? _customDateRange;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
    _selectedCategory = widget.initialCategory;
    _selectedPeriod = widget.initialPeriod;
  }

  // Chọn khoảng ngày tùy chỉnh
  Future<void> _pickCustomDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDateRange: _customDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 7)),
            end: DateTime.now(),
          ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1769E0),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customDateRange = picked;
        _selectedPeriod = 'custom';
      });
    }
  }

  void _applyFilter() {
    final filterResult = {
      'type': _selectedType,
      'category': _selectedCategory,
      'period': _selectedPeriod,
      'customDateRange': _customDateRange,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã áp dụng bộ lọc!'),
        backgroundColor: Color(0xFF1769E0),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context, filterResult);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Bộ lọc',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 1. LOẠI GIAO DỊCH
                    // ==========================================
                    const Text(
                      'Loại giao dịch',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildCheckboxOption(
                      label: 'Tất cả',
                      isSelected: _selectedType == 'all',
                      onTap: () => setState(() => _selectedType = 'all'),
                    ),
                    _buildCheckboxOption(
                      label: 'Thu nhập',
                      isSelected: _selectedType == 'income',
                      onTap: () => setState(() => _selectedType = 'income'),
                    ),
                    _buildCheckboxOption(
                      label: 'Chi tiêu',
                      isSelected: _selectedType == 'expense',
                      onTap: () => setState(() => _selectedType = 'expense'),
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // 2. DANH MỤC
                    // ==========================================
                    const Text(
                      'Danh mục',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _categories.contains(_selectedCategory)
                              ? _selectedCategory
                              : _categories.first,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xFF9CA3AF),
                          ),
                          items: _categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(
                                cat,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCategory = val);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // 3. KHOẢNG THỜI GIAN
                    // ==========================================
                    const Text(
                      'Khoảng thời gian',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildRadioOption(
                      label: 'Hôm nay',
                      value: 'today',
                    ),
                    _buildRadioOption(
                      label: '7 ngày qua',
                      value: '7_days',
                    ),
                    _buildRadioOption(
                      label: 'Tháng này',
                      value: 'this_month',
                    ),
                    _buildRadioOption(
                      label: _customDateRange != null
                          ? 'Tùy chỉnh (${DateFormat('dd/MM').format(_customDateRange!.start)} - ${DateFormat('dd/MM').format(_customDateRange!.end)})'
                          : 'Tùy chỉnh',
                      value: 'custom',
                      onExtraTap: _pickCustomDateRange,
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================
            // NÚT "ÁP DỤNG"
            // ==========================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1769E0),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _applyFilter,
                  child: const Text(
                    'Áp dụng',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tùy chọn Checkbox loại giao dịch
  Widget _buildCheckboxOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1769E0) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1769E0)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tùy chọn Radio khoảng thời gian
  Widget _buildRadioOption({
    required String label,
    required String value,
    VoidCallback? onExtraTap,
  }) {
    final isSelected = _selectedPeriod == value;

    return InkWell(
      onTap: () {
        setState(() => _selectedPeriod = value);
        if (value == 'custom' && onExtraTap != null) {
          onExtraTap();
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1769E0)
                      : const Color(0xFFD1D5DB),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1769E0),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (value == 'custom' && isSelected)
              IconButton(
                icon: const Icon(Icons.date_range, size: 20, color: Color(0xFF1769E0)),
                onPressed: _pickCustomDateRange,
              ),
          ],
        ),
      ),
    );
  }
}
