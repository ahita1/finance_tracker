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
  final db = await openDatabase(
    path,
    onCreate: (db, version) async {
      await db.execute('CREATE TABLE incomes('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT, '
          'amount REAL, '
          'date TEXT, '
          'category TEXT, '
          'budget_cycle TEXT);'); 
      await db.execute('CREATE TABLE expenses('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT, '
          'amount REAL, '
          'date TEXT, '
          'category TEXT, '
          'budget_cycle TEXT);');  
    },
    version: 2, 
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('ALTER TABLE incomes ADD COLUMN budget_cycle TEXT;');
        await db.execute('ALTER TABLE expenses ADD COLUMN budget_cycle TEXT;');
      }
    },
  );
  return db;
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
