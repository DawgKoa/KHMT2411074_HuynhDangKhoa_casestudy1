import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionHelper {
  // Format tiền tệ Việt Nam (ví dụ: 5.000.000 đ)
  static String formatCurrency(double amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount.round()).replaceAll(',', '.')} đ';
  }

  // Lấy Icon tương ứng theo danh mục
  static IconData getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Lương':
      case 'Thu nhập':
        return Icons.attach_money;
      case 'Mua sắm':
        return Icons.shopping_cart;
      case 'Học tập':
      case 'Giáo dục':
        return Icons.school;
      case 'Giải trí':
        return Icons.sports_esports;
      case 'Thưởng':
      case 'Đầu tư':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }

  // Lấy màu sắc chủ đạo của icon danh mục
  static Color getCategoryColor(String category) {
    switch (category) {
      case 'Ăn uống':
        return const Color(0xFFFF6D00);
      case 'Di chuyển':
        return const Color(0xFF2196F3);
      case 'Lương':
      case 'Thu nhập':
      case 'Thưởng':
      case 'Đầu tư':
        return const Color(0xFF2EAD4B);
      case 'Mua sắm':
        return const Color(0xFF9C27B0);
      case 'Học tập':
      case 'Giáo dục':
        return const Color(0xFF009688);
      case 'Giải trí':
        return const Color(0xFFE91E63);
      default:
        return const Color(0xFF607D8B);
    }
  }
}
