class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type; // 'expense' (chi tiêu) hoặc 'income' (thu nhập)
  final String category;
  final DateTime date;
  final String? note;

  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
  });

  // Chuyển đối tượng sang Map để lưu vào SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  // Chuyển Map từ SQLite sang đối tượng TransactionModel
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      type: map['type'] as String? ?? 'expense',
      category: map['category'] as String? ?? 'Khác',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'] as String) ?? DateTime.now()
          : DateTime.now(),
      note: map['note'] as String?,
    );
  }

  // Tiện ích sao chép để cập nhật
  TransactionModel copyWith({
    int? id,
    String? title,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
    String? note,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
