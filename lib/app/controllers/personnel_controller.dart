import 'package:get/get.dart';
import '../models/personnel_model.dart';
import '../services/personnel_service.dart';

class PersonnelController extends GetxController {
  final PersonnelService service = PersonnelService();
  var personnels = <Personnel>[].obs;

  Future<void> loadPersonnels(int entrepriseId) async {
    personnels.value = await service.getPersonnelsByEntreprise(entrepriseId);
  }

  Future<void> addPersonnel(Personnel personnel) async {
    await service.insertPersonnel(personnel);
    await loadPersonnels(personnel.entrepriseId);
  }

  Future<void> deletePersonnel(int id, int entrepriseId) async {
    await service.deletePersonnel(id);
    await loadPersonnels(entrepriseId);
  }
}
