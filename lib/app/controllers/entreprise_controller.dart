import 'package:get/get.dart';
import '../models/entreprise_model.dart';
import '../services/entreprise_service.dart';

class EntrepriseController extends GetxController {
  final EntrepriseService service = EntrepriseService();
  var entreprises = <Entreprise>[].obs;

  Future<void> loadEntreprises(int projetId) async {
    entreprises.value = await service.getEntreprisesByProjet(projetId);
  }

  Future<void> addEntreprise(Entreprise entreprise) async {
    await service.insertEntreprise(entreprise);
    await loadEntreprises(entreprise.projetId);
  }

  Future<void> deleteEntreprise(int id, int projetId) async {
    await service.deleteEntreprise(id);
    await loadEntreprises(projetId);
  }
}
