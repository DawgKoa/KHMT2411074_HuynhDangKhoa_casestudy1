import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  static const _databaseName = "expense_manager.db";
  static const _databaseVersion = 1;

  // Tên bảng và các cột
  static const tableTransactions = 'transactions';
  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnAmount = 'amount';
  static const columnType = 'type';
  static const columnCategory = 'category';
  static const columnDate = 'date';
  static const columnNote = 'note';

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Khởi tạo database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  // Tạo bảng trong SQLite
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableTransactions (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnAmount REAL NOT NULL,
        $columnType TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnNote TEXT
      )
    ''');

    // Chèn dữ liệu mẫu ban đầu để giao diện có dữ liệu hiển thị trực quan
    await _seedInitialData(db);
  }

  // Dữ liệu ban đầu tương ứng với mockup ứng dụng
  Future<void> _seedInitialData(Database db) async {
    final sampleData = [
      {
        columnTitle: 'Ăn trưa',
        columnAmount: 50000.0,
        columnType: 'expense',
        columnCategory: 'Ăn uống',
        columnDate: DateTime(2024, 9, 3, 12, 0).toIso8601String(),
        columnNote: 'Cơm trưa văn phòng',
      },
      {
        columnTitle: 'Xăng xe',
        columnAmount: 100000.0,
        columnType: 'expense',
        columnCategory: 'Di chuyển',
        columnDate: DateTime(2024, 9, 3, 8, 30).toIso8601String(),
        columnNote: 'Đổ xăng xe máy',
      },
      {
        columnTitle: 'Lương tháng 9',
        columnAmount: 8000000.0,
        columnType: 'income',
        columnCategory: 'Thu nhập',
        columnDate: DateTime(2024, 9, 1, 9, 0).toIso8601String(),
        columnNote: 'Nhận lương công ty',
      },
      {
        columnTitle: 'Mua sắm',
        columnAmount: 300000.0,
        columnType: 'expense',
        columnCategory: 'Mua sắm',
        columnDate: DateTime(2024, 8, 31, 19, 0).toIso8601String(),
        columnNote: 'Mua đồ dùng cá nhân',
      },
      {
        columnTitle: 'Học phí',
        columnAmount: 500000.0,
        columnType: 'expense',
        columnCategory: 'Học tập',
        columnDate: DateTime(2024, 8, 30, 10, 0).toIso8601String(),
        columnNote: 'Khóa học Flutter',
      },
    ];

    for (final item in sampleData) {
      await db.insert(tableTransactions, item);
    }
  }

  // ===========================================================================
  // CÁC THAO TÁC CRUD (Create, Read, Update, Delete)
  // ===========================================================================

  // 1. Thêm giao dịch mới
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert(tableTransactions, transaction.toMap());
  }

  // 2. Lấy danh sách tất cả giao dịch (sắp xếp mới nhất lên đầu)
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTransactions,
      orderBy: '$columnDate DESC, $columnId DESC',
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // 3. Lấy giao dịch theo ID
  Future<TransactionModel?> getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableTransactions,
      where: '$columnId = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return TransactionModel.fromMap(maps.first);
    }
    return null;
  }

  // 4. Cập nhật giao dịch
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      tableTransactions,
      transaction.toMap(),
      where: '$columnId = ?',
      whereArgs: [transaction.id],
    );
  }

  // 5. Xóa giao dịch theo ID
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      tableTransactions,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // ===========================================================================
  // CÁC HÀM THỐNG KÊ (Hỗ trợ Dashboard & Báo cáo)
  // ===========================================================================

  // Tổng tiền thu nhập (income)
  Future<double> getTotalIncome() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM($columnAmount) as total FROM $tableTransactions WHERE $columnType = ?',
      ['income'],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Tổng tiền chi tiêu (expense)
  Future<double> getTotalExpense() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM($columnAmount) as total FROM $tableTransactions WHERE $columnType = ?',
      ['expense'],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  // Số dư hiện tại = Tổng thu nhập - Tổng chi tiêu
  Future<double> getBalance() async {
    final income = await getTotalIncome();
    final expense = await getTotalExpense();
    return income - expense;
  }

  // Thống kê theo danh mục (cho Màn hình Thống kê)
  Future<List<Map<String, dynamic>>> getCategoryStatistics({
    DateTime? startDate,
    DateTime? endDate,
    String type = 'expense',
  }) async {
    final db = await database;
    String whereClause = '$columnType = ?';
    List<dynamic> whereArgs = [type];

    if (startDate != null && endDate != null) {
      whereClause += ' AND $columnDate >= ? AND $columnDate <= ?';
      whereArgs.add(startDate.toIso8601String());
      whereArgs.add(endDate.toIso8601String());
    }

    final result = await db.rawQuery('''
      SELECT $columnCategory as category, SUM($columnAmount) as total
      FROM $tableTransactions
      WHERE $whereClause
      GROUP BY $columnCategory
      ORDER BY total DESC
    ''', whereArgs);

    return result;
  }

  // Tìm kiếm và lọc giao dịch (cho Màn hình Giao dịch)
  Future<List<TransactionModel>> getFilteredTransactions({
    String filterType = 'all', // 'all', 'income', 'expense'
    String searchQuery = '',
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final db = await database;
    String whereClause = '1 = 1';
    List<dynamic> whereArgs = [];

    if (filterType != 'all') {
      whereClause += ' AND $columnType = ?';
      whereArgs.add(filterType);
    }

    if (category != null &&
        category.isNotEmpty &&
        category != 'Tất cả danh mục') {
      whereClause += ' AND $columnCategory = ?';
      whereArgs.add(category);
    }

    if (startDate != null && endDate != null) {
      whereClause += ' AND $columnDate >= ? AND $columnDate <= ?';
      whereArgs.add(startDate.toIso8601String());
      whereArgs.add(endDate.toIso8601String());
    }

    if (searchQuery.trim().isNotEmpty) {
      whereClause +=
          ' AND ($columnTitle LIKE ? OR $columnCategory LIKE ? OR $columnNote LIKE ?)';
      final queryParam = '%${searchQuery.trim()}%';
      whereArgs.addAll([queryParam, queryParam, queryParam]);
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableTransactions,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: '$columnDate DESC, $columnId DESC',
    );

    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // Đóng database khi cần
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
