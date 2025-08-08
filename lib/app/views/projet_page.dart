import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/projet_model.dart';
import '../models/horaire_projet_model.dart';
import '../services/projet_service.dart';
import '../models/entreprise_model.dart';

import '../controllers/entreprise_controller.dart';

import '../services/entreprise_service.dart';

import 'entreprise_page.dart';


class ProjetPage extends StatelessWidget {
  final Projet projet;
  final ProjetService projetService = Get.find<ProjetService>();
  final EntrepriseController entrepriseController = Get.put(EntrepriseController());
  final EntrepriseService entrepriseService = EntrepriseService();


  ProjetPage({Key? key, required this.projet}) : super(key: key);

  void _showEditEntrepriseDialog(BuildContext context, Entreprise entreprise) {
    final _nomCtrl = TextEditingController(text: entreprise.nom);
    String typeEntreprise = entreprise.typeEntreprise;
    final types = [
      'Entreprise de Vinci',
      'Sous-traitant de Vinci',
      'Client',
      'Ingénieur Conseil',
      'Autre',
    ];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier l\'entreprise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomCtrl,
                  decoration: InputDecoration(labelText: 'Nom de l\'entreprise'),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: typeEntreprise,
                  items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) {
                    if (val != null) typeEntreprise = val;
                  },
                  decoration: InputDecoration(labelText: 'Type d\'entreprise'),
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
                if (nom.isEmpty) {
                  Get.snackbar('Erreur', 'Le nom est requis');
                  return;
                }
                try {
                  // Update entreprise dans la base
                  await entrepriseService.database.then((db) => db.update(
                    'entreprises',
                    {'nom': nom, 'type_entreprise': typeEntreprise},
                    where: 'id = ?',
                    whereArgs: [entreprise.id],
                  ));
                  await entrepriseController.loadEntreprises(entreprise.projetId);
                  Navigator.of(context).pop();
                  Get.snackbar('Succès', 'Entreprise modifiée');
                } catch (e) {
                  Get.snackbar('Erreur', 'Erreur lors de la modification: $e');
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HoraireProjet>>(
      future: projetService.getHorairesByProjet(projet.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(projet.nom),
              backgroundColor: Colors.blue,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final horaires = snapshot.data ?? [];
        String entree = '';
        String sortie = '';
        if (horaires.isNotEmpty) {
          entree = horaires.first.heureEntree;
          sortie = horaires.first.heureSortie;
        }
        // Charger les entreprises au démarrage
        entrepriseController.loadEntreprises(projet.id!);
        return Scaffold(
          appBar: AppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(projet.nom),
                if (entree.isNotEmpty && sortie.isNotEmpty)
                  Text('Entrée : $entree   Sortie : $sortie', style: TextStyle(fontSize: 14)),
              ],
            ),
            backgroundColor: Colors.blue,
          ),
          body: Obx(() {
            final entreprises = entrepriseController.entreprises;
            if (entreprises.isEmpty) {
              return Center(child: Text('Aucune entreprise enregistrée', style: TextStyle(color: Colors.grey)));
            }
            return ListView.separated(
              padding: EdgeInsets.only(top: 12, bottom: 80),
              itemCount: entreprises.length,
              separatorBuilder: (_, __) => Divider(height: 0),
              itemBuilder: (context, index) {
                final ent = entreprises[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.business, color: Colors.blue.shade700),
                  ),
                  title: Text(ent.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(ent.typeEntreprise),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        tooltip: 'Modifier',
                        onPressed: () {
                          _showEditEntrepriseDialog(context, ent);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        tooltip: 'Supprimer',
                        onPressed: () async {
                          await entrepriseController.deleteEntreprise(ent.id!, projet.id!);
                          Get.snackbar('Entreprise supprimée', '', snackPosition: SnackPosition.BOTTOM);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EntreprisePage(entreprise: ent),
                      ),
                    );
                  },
                );
              },
            );
          }),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showCreateEntrepriseDialog(context),
            child: Icon(Icons.add_business),
            backgroundColor: Colors.blue,
          ),
        );
      },
    );
  }

  void _showCreateEntrepriseDialog(BuildContext context) {
    final _nomCtrl = TextEditingController();
    String typeEntreprise = 'Entreprise de Vinci';
    final types = [
      'Entreprise de Vinci',
      'Sous-traitant de Vinci',
      'Client',
      'Ingénieur Conseil',
      'Autre',
    ];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter une entreprise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomCtrl,
                  decoration: InputDecoration(labelText: 'Nom de l\'entreprise'),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: typeEntreprise,
                  items: types.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                  onChanged: (val) {
                    if (val != null) typeEntreprise = val;
                  },
                  decoration: InputDecoration(labelText: 'Type d\'entreprise'),
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
                if (nom.isEmpty) {
                  Get.snackbar('Erreur', 'Le nom est requis');
                  return;
                }
                try {
                  await entrepriseController.addEntreprise(
                    Entreprise(nom: nom, typeEntreprise: typeEntreprise, projetId: projet.id!),
                  );
                  Navigator.of(context).pop();
                  Get.snackbar('Succès', 'Entreprise ajoutée');
                } catch (e) {
                  Get.snackbar('Erreur', 'Erreur lors de l\'ajout: $e');
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
