import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_database.db');
    print('Database path: $path'); // Debug log
    return openDatabase(
      path,
      onCreate: (db, version) async {
        print('Creating tables'); // Debug log
        await db.execute(
          'CREATE TABLE incomes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL);',
        );
        await db.execute(
          'CREATE TABLE expenses(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, amount REAL, date TEXT);',
        );
      },
      version: 1,
    );
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'finance_database.db');
    await databaseFactory.deleteDatabase(path);
  }

  Future<int> insertIncome(Map<String, dynamic> income) async {
    Database db = await database;
    return await db.insert('incomes', income);
  }

  Future<int> insertExpense(Map<String, dynamic> expense) async {
    Database db = await database;
    return await db.insert('expenses', expense);
  }
}
