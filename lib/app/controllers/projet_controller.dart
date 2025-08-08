import 'package:get/get.dart';
import '../models/projet_model.dart';
import '../services/projet_service.dart';

class ProjetController extends GetxController {
  var projets = <Projet>[].obs;
  final ProjetService projetService = Get.find<ProjetService>();

  @override
  void onInit() {
    super.onInit();
    loadProjets();
  }

  Future<void> loadProjets() async {
    projets.value = await projetService.getAllProjets();
  }

  Future<void> addProjet(Projet projet) async {
    await projetService.insertProjet(projet);
    await loadProjets();
  }

  Future<void> deleteProjet(int id) async {
    await projetService.deleteProjet(id);
    await loadProjets();
  }
}
