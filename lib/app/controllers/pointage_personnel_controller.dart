import 'package:get/get.dart';
import '../models/pointage_personnel_model.dart';
import '../services/pointage_personnel_service.dart';

class PointagePersonnelController extends GetxController {
  final PointagePersonnelService service;
  var pointages = <PointagePersonnel>[].obs;

  PointagePersonnelController(this.service);

  Future<void> loadPointages(int personnelId, DateTime weekStart, DateTime weekEnd) async {
    pointages.value = await service.getPointagesByPersonnelAndWeek(personnelId, weekStart, weekEnd);
  }

  Future<void> addPointage(PointagePersonnel pointage) async {
    await service.insertPointage(pointage);
    // Optionally reload
  }

  Future<void> updatePointage(PointagePersonnel pointage) async {
    await service.updatePointage(pointage);
    // Optionally reload
  }

  Future<void> deletePointage(int id) async {
    await service.deletePointage(id);
    // Optionally reload
  }
}
