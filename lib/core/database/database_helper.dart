import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _db;
  DatabaseHelper._();

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'hospital_complete.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int v) async {
    await db.execute('''
      CREATE TABLE doctors (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        specialty TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE patients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id TEXT,
        name TEXT,
        age INTEGER,
        gender TEXT,
        disease TEXT,
        doctor_id INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE prescriptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER,
        doctor_id INTEGER,
        diagnosis TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        prescription_id INTEGER,
        name TEXT,
        quantity INTEGER,
        price REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        role TEXT,
        ref_id INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE appointments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        patient_id INTEGER,
        doctor_id INTEGER,
        date TEXT,
        time TEXT,
        status TEXT
      )
    ''');

    await _seedUsers(db);
  }

  Future<void> _seedUsers(Database db) async {
    await db.insert('users', {
      'username':'admin',
      'password':'admin123',
      'role':'admin',
      'ref_id':null
    });
    final doctorId = await db.insert('doctors', {
      'name':'Dr. Ahmad',
      'specialty':'General'
    });
    await db.insert('users', {
      'username':'doctor',
      'password':'doctor123',
      'role':'doctor',
      'ref_id':doctorId
    });
    await db.insert('users', {
      'username':'pharmacy',
      'password':'pharmacy123',
      'role':'pharmacy',
      'ref_id':null
    });
  }
}
