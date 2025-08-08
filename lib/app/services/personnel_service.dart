
import 'package:sqflite/sqflite.dart';
import '../models/personnel_model.dart';
import 'entreprise_service.dart';

class PersonnelService {
  Future<void> updatePersonnel(int id, String nomComplet, String fonction, String? location) async {
    final db = await database;
    await db.update(
      'personnels',
      {
        'nom_complet': nomComplet,
        'fonction': fonction,
        'location': location,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<Database> get database async => EntrepriseService().database;

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS personnels (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uuid TEXT NOT NULL UNIQUE,
        nom_complet TEXT NOT NULL,
        fonction TEXT NOT NULL,
        location TEXT,
        entrepriseId INTEGER NOT NULL,
        qr_code_path TEXT,
        FOREIGN KEY(entrepriseId) REFERENCES entreprises(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertPersonnel(Personnel personnel) async {
    final db = await database;
    return await db.insert('personnels', personnel.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Personnel>> getPersonnelsByEntreprise(int entrepriseId) async {
    final db = await database;
    final maps = await db.query('personnels', where: 'entrepriseId = ?', whereArgs: [entrepriseId]);
    return maps.map((e) => Personnel.fromMap(e)).toList();
  }

  Future<void> deletePersonnel(int id) async {
    final db = await database;
    await db.delete('personnels', where: 'id = ?', whereArgs: [id]);
  }
}
