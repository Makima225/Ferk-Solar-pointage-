import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/entreprise_model.dart';
import 'sous_pages/personnels_page.dart';
import 'sous_pages/liste_presence_page.dart';
import 'sous_pages/statistiques_page.dart';
import '../controllers/entreprise_page_controller.dart';

class EntreprisePage extends StatelessWidget {
  final Entreprise entreprise;
  EntreprisePage({Key? key, required this.entreprise}) : super(key: key);

  final EntreprisePageController controller = Get.put(EntreprisePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entreprise.nom),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _NavButton(
                  label: 'Personnels',
                  selected: controller.selectedIndex.value == 0,
                  onTap: () => controller.setIndex(0),
                ),
                SizedBox(width: 16),
                _NavButton(
                  label: 'Liste de présence',
                  selected: controller.selectedIndex.value == 1,
                  onTap: () => controller.setIndex(1),
                ),
                SizedBox(width: 16),
                _NavButton(
                  label: 'Statistiques',
                  selected: controller.selectedIndex.value == 2,
                  onTap: () => controller.setIndex(2),
                ),
              ],
            )),
          ),
          Expanded(
            child: Obx(() => IndexedStack(
              index: controller.selectedIndex.value,
              children: [
                PersonnelsPage(entrepriseId: entreprise.id!),
                ListePresencePage(entrepriseId: entreprise.id!),
                const StatistiquesPage(),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _NavButton({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey[300],
        foregroundColor: selected ? Colors.white : Colors.black,
        elevation: selected ? 2 : 0,
      ),
      onPressed: onTap,
      child: Text(label),
    );
  }
}



class _ListePresencePage extends StatelessWidget {
  const _ListePresencePage();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Page Liste de présence', style: TextStyle(fontSize: 20)));
  }
}

class _StatistiquesPage extends StatelessWidget {
  const _StatistiquesPage();
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Page Statistiques', style: TextStyle(fontSize: 20)));
  }
}
