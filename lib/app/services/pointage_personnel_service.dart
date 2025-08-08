import 'package:sqflite/sqflite.dart';
import '../models/pointage_personnel_model.dart';

class PointagePersonnelService {
  final Database db;
  PointagePersonnelService(this.db);

  Future<int> insertPointage(PointagePersonnel pointage) async {
    return await db.insert('pointages', pointage.toMap());
  }

  Future<List<PointagePersonnel>> getPointagesByPersonnelAndWeek(int personnelId, DateTime weekStart, DateTime weekEnd) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'pointages',
      where: 'personnelId = ? AND date BETWEEN ? AND ?',
      whereArgs: [personnelId, weekStart.toIso8601String(), weekEnd.toIso8601String()],
    );
    return List.generate(maps.length, (i) => PointagePersonnel.fromMap(maps[i]));
  }

  Future<int> updatePointage(PointagePersonnel pointage) async {
    return await db.update(
      'pointages',
      pointage.toMap(),
      where: 'id = ?',
      whereArgs: [pointage.id],
    );
  }

  Future<int> deletePointage(int id) async {
    return await db.delete(
      'pointages',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
