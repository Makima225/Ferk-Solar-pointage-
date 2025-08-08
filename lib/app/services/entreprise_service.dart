import 'package:sqflite/sqflite.dart';
import '../models/entreprise_model.dart';
import 'projet_service.dart';

class EntrepriseService {
  Future<Database> get database async {
    final db = await ProjetService().database;
    // S'assure que la table existe à chaque accès
    await createTable(db);
    return db;
  }

  Future<void> createTable(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS entreprises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT NOT NULL,
        type_entreprise TEXT NOT NULL,
        projetId INTEGER NOT NULL,
        UNIQUE(nom, projetId),
        FOREIGN KEY(projetId) REFERENCES projets(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertEntreprise(Entreprise entreprise) async {
    final db = await database;
    return await db.insert('entreprises', entreprise.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Entreprise>> getEntreprisesByProjet(int projetId) async {
    final db = await database;
    final maps = await db.query('entreprises', where: 'projetId = ?', whereArgs: [projetId]);
    return maps.map((e) => Entreprise.fromMap(e)).toList();
  }

  Future<void> deleteEntreprise(int id) async {
    final db = await database;
    await db.delete('entreprises', where: 'id = ?', whereArgs: [id]);
  }
}
