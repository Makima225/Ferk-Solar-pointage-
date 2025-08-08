import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/personnel_model.dart';
import '../../controllers/personnel_controller.dart';

class PersonnelsPage extends StatelessWidget {
  final int entrepriseId;
  const PersonnelsPage({Key? key, required this.entrepriseId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PersonnelController personnelController = Get.put(PersonnelController());
    personnelController.loadPersonnels(entrepriseId);
    return Scaffold(
      body: Obx(() {
        final personnels = personnelController.personnels;
        if (personnels.isEmpty) {
          return Center(child: Text('Aucun personnel enregistré', style: TextStyle(color: Colors.grey)));
        }
        return ListView.separated(
          padding: EdgeInsets.only(top: 12, bottom: 80),
          itemCount: personnels.length,
          separatorBuilder: (_, __) => Divider(height: 0),
          itemBuilder: (context, index) {
            final pers = personnels[index];
            return ListTile(
              leading: QrImageView(
                data: pers.uuid,
                version: QrVersions.auto,
                size: 40.0,
              ),
              title: Text(pers.nomComplet, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(pers.fonction),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePersonnelDialog(context, entrepriseId),
        child: Icon(Icons.person_add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showCreatePersonnelDialog(BuildContext context, int entrepriseId) {
    final _nomCtrl = TextEditingController();
    final _fonctionCtrl = TextEditingController();
    final _locationCtrl = TextEditingController();
    final PersonnelController personnelController = Get.find();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un personnel'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomCtrl,
                  decoration: InputDecoration(labelText: 'Nom complet'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _fonctionCtrl,
                  decoration: InputDecoration(labelText: 'Fonction'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _locationCtrl,
                  decoration: InputDecoration(labelText: 'Localisation (optionnel)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () async {
                final nom = _nomCtrl.text.trim();
                final fonction = _fonctionCtrl.text.trim();
                final location = _locationCtrl.text.trim().isEmpty ? null : _locationCtrl.text.trim();
                if (nom.isEmpty || fonction.isEmpty) {
                  Get.snackbar('Erreur', 'Nom et fonction requis');
                  return;
                }
                final uuid = Personnel.generateUuid();
                await personnelController.addPersonnel(
                  Personnel(
                    uuid: uuid,
                    nomComplet: nom,
                    fonction: fonction,
                    location: location,
                    entrepriseId: entrepriseId,
                  ),
                );
                Navigator.of(context).pop();
                Get.snackbar('Succès', 'Personnel ajouté');
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
