import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/projet_model.dart';
import '../models/horaire_projet_model.dart';

class ProjetService {
  static final ProjetService _instance = ProjetService._internal();
  factory ProjetService() => _instance;
  ProjetService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'projets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE projets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT UNIQUE
          )
        ''');
        await db.execute('''
          CREATE TABLE horaires_projet(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            projetId INTEGER,
            jour TEXT,
            heureEntree TEXT,
            heureSortie TEXT,
            UNIQUE(projetId, jour),
            FOREIGN KEY(projetId) REFERENCES projets(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Projet CRUD
  Future<int> insertProjet(Projet projet) async {
    final db = await database;
    return await db.insert('projets', projet.toMap());
  }

  Future<List<Projet>> getAllProjets() async {
    final db = await database;
    final maps = await db.query('projets');
    return maps.map((e) => Projet.fromMap(e)).toList();
  }

  Future<int> deleteProjet(int id) async {
    final db = await database;
    return await db.delete('projets', where: 'id = ?', whereArgs: [id]);
  }

  // HoraireProjet CRUD
  Future<int> insertHoraire(HoraireProjet horaire) async {
    final db = await database;
    return await db.insert('horaires_projet', horaire.toMap());
  }

  Future<List<HoraireProjet>> getHorairesByProjet(int projetId) async {
    final db = await database;
    final maps = await db.query('horaires_projet', where: 'projetId = ?', whereArgs: [projetId]);
    return maps.map((e) => HoraireProjet.fromMap(e)).toList();
  }

  Future<int> deleteHoraire(int id) async {
    final db = await database;
    return await db.delete('horaires_projet', where: 'id = ?', whereArgs: [id]);
  }
}
