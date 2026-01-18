import 'database.dart';

class DatabaseHelper {
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static AppDatabase? _database;

  Future<AppDatabase> get database async {
    if (_database != null) return _database!;
    _database = AppDatabase();
    return _database!;
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.clearAllData();
  }

  Future<void> clearAllStudents() async {
    final db = await database;
    await db.clearAllStudents();
  }

  Future<void> resetDatabase() async {
    final db = await database;
    await db.resetDatabase();
  }
}
