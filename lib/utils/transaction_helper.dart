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
      case 'Đi lại':
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
        return const Color(0xFFEF5350); // Đỏ cam theo mockup
      case 'Mua sắm':
        return const Color(0xFF29B6F6); // Xanh dương nhạt theo mockup
      case 'Lương':
      case 'Thu nhập':
        return const Color(0xFF66BB6A); // Xanh lá
      case 'Di chuyển':
      case 'Đi lại':
        return const Color(0xFFAB47BC); // Tím
      case 'Học tập':
      case 'Giáo dục':
        return const Color(0xFF5C6BC0); // Chàm / xanh tím
      case 'Giải trí':
        return const Color(0xFFFFA726); // Cam
      case 'Thưởng':
      case 'Đầu tư':
        return const Color(0xFF26A69A); // Xanh mòng két
      default:
        return const Color(0xFF78909C);
    }
  }
}
