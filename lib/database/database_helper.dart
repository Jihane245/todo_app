import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initDb();
    }
    return _db!;
  }

  Future<Database> initDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'todo.db');

    Database mydb = await openDatabase(
      path,
      // 1. ON PASSE À LA VERSION 2
      version: 2, 
      onCreate: _onCreate,
      // 2. ON AJOUTE LA FONCTION DE MISE À JOUR
      onUpgrade: _onUpgrade, 
    );

    return mydb;
  }

  // ==========================================
  // NOUVELLE FONCTION POUR METTRE À JOUR LA DB
  // ==========================================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // On ajoute les colonnes manquantes sans détruire la table
      await db.execute("ALTER TABLE tasks ADD COLUMN start_date TEXT");
      await db.execute("ALTER TABLE tasks ADD COLUMN end_date TEXT");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        secret_code TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        start_date TEXT,
        end_date TEXT,
        priority INTEGER DEFAULT 1,
        progress INTEGER DEFAULT 0,
        status INTEGER DEFAULT 0,
        user_id INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }
  Future<int> insertUser(
    String name,
    String email,
    String password,
    String secretCode,
  ) async {

    return await (await db).insert(
      'users',
      {
        'name': name,
        'email': email,
        'password': password,
        'secret_code': secretCode,
      },
    );
  }
Future<int> insertTask(
  String title,
  String description,
  String? startDate,
  String? endDate,
  int priority,
  int progress,
  int status,
  int userId,
) async {

  return await (await db).insert(
    'tasks',
    {
      'title': title,
      'description': description,

      'start_date': startDate,
      'end_date': endDate,

      'priority': priority,

      'progress': progress,

      'status': status,

      'user_id': userId,
    },
  );
}
  Future<List<Map<String, dynamic>>> getAllTasks() async {

    return await (await db).query(
      'tasks',
    );
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {

    return await (await db).query(
      'users',
    );
  }

  Future<List<Map<String, dynamic>>> getTasksByUser(
    int userId,
  ) async {

    return await (await db).query(
      'tasks',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateTask(
  int id,
  String title,
  String description,

  String? startDate,
  String? endDate,

  int priority,

  int progress,

  int status,
) async {

  return await (await db).update(
    'tasks',
    {
      'title': title,

      'description': description,

      'start_date': startDate,

      'end_date': endDate,

      'priority': priority,

      'progress': progress,

      'status': status,
    },

    where: 'id = ?',

    whereArgs: [id],
  );
}

  Future<int> deleteTask(
    int id,
  ) async {

    return await (await db).delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> getUserByEmail(
    String email,
  ) async {

    return await (await db).query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  Future<List<Map<String, dynamic>>> loginUser(
    String email,
    String password,
  ) async {

    return await (await db).query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [
        email,
        password,
      ],
    );
  }

  Future<List<Map<String, dynamic>>> verifySecretCode(
    String email,
    String secretCode,
  ) async {

    return await (await db).query(
      'users',
      where: 'email = ? AND secret_code = ?',
      whereArgs: [
        email,
        secretCode,
      ],
    );
  }

  Future<int> updatePassword(
    String email,
    String password,
  ) async {

    return await (await db).update(
      'users',
      {
        'password': password,
      },
      where: 'email = ?',
      whereArgs: [email],
    );
  }
}