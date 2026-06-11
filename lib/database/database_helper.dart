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
      version: 4, // Version 4 : ajout de la colonne profile_image_path
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return mydb;
  }

  // ==========================================
  // MIGRATION : mise à jour de la structure DB
  // ==========================================
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Migration v1 → v2 : ajout des dates
      await db.execute("ALTER TABLE tasks ADD COLUMN start_date TEXT");
      await db.execute("ALTER TABLE tasks ADD COLUMN end_date TEXT");
    }
    if (oldVersion < 3) {
      // Migration v2 → v3 : ajout de la catégorie
      await db.execute(
        "ALTER TABLE tasks ADD COLUMN category TEXT DEFAULT 'Général'",
      );
    }
    if (oldVersion < 4) {
      // Migration v3 → v4 : ajout du chemin de la photo de profil
      // NULL = pas de photo → avatar par défaut affiché dans l'UI
      await db.execute(
        "ALTER TABLE users ADD COLUMN profile_image_path TEXT",
      );
    }
  }

  // ==========================================
  // CRÉATION INITIALE DES TABLES
  // ==========================================
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        secret_code TEXT NOT NULL,
        profile_image_path TEXT
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
        category TEXT DEFAULT 'Général',
        user_id INTEGER NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');
  }

  // ==========================================
  // UTILISATEURS
  // ==========================================
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

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    return await (await db).query('users');
  }

  Future<List<Map<String, dynamic>>> getUserByEmail(String email) async {
    return await (await db).query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Récupère un utilisateur par son ID — utilisé par AuthController (MVC)
  Future<Map<String, dynamic>?> getUserById(int id) async {
    final result = await (await db).query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> loginUser(
    String email,
    String password,
  ) async {
    return await (await db).query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
  }

  Future<List<Map<String, dynamic>>> verifySecretCode(
    String email,
    String secretCode,
  ) async {
    return await (await db).query(
      'users',
      where: 'email = ? AND secret_code = ?',
      whereArgs: [email, secretCode],
    );
  }

  Future<int> updatePassword(String email, String password) async {
    return await (await db).update(
      'users',
      {'password': password},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Stocke uniquement le chemin local de l'image (pas de BLOB)
  Future<int> updateProfileImagePath(int userId, String? imagePath) async {
    return await (await db).update(
      'users',
      {'profile_image_path': imagePath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  // ==========================================
  // TÂCHES
  // ==========================================
  Future<int> insertTask(
    String title,
    String description,
    String? startDate,
    String? endDate,
    int priority,
    int progress,
    int status,
    int userId,
    String category,
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
        'category': category,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAllTasks() async {
    return await (await db).query('tasks');
  }

  Future<List<Map<String, dynamic>>> getTasksByUser(int userId) async {
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
    String category,
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
        'category': category,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteTask(int id) async {
    return await (await db).delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}