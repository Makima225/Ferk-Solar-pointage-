import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../app_routes.dart';
import '../models/projet_model.dart';
import '../models/horaire_projet_model.dart';

import '../services/projet_service.dart';
import '../controllers/projet_controller.dart';

class DashboardAdmin extends StatelessWidget {
  final AuthController authController = Get.find();
  final ProjetService projetService = Get.put(ProjetService());
  final ProjetController projetController = Get.put(ProjetController());

  void _showEditProjetDialog(BuildContext context, Projet projet) async {
    final horaires = await projetService.getHorairesByProjet(projet.id!);
    final _nomCtrl = TextEditingController(text: projet.nom);
    final _entreeCtrl = TextEditingController(text: horaires.isNotEmpty ? horaires.first.heureEntree : '');
    final _sortieCtrl = TextEditingController(text: horaires.isNotEmpty ? horaires.first.heureSortie : '');
    final jours = [
      'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'
    ];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le projet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomCtrl,
                  decoration: InputDecoration(labelText: 'Nom du projet'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _entreeCtrl,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Heure d'entrée (HH:mm)"),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      _entreeCtrl.text = picked.format(context);
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _sortieCtrl,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Heure de sortie (HH:mm)"),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      _sortieCtrl.text = picked.format(context);
                    }
                  },
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
                final entree = _entreeCtrl.text.trim();
                final sortie = _sortieCtrl.text.trim();
                if (nom.isEmpty || entree.isEmpty || sortie.isEmpty) {
                  Get.snackbar('Erreur', 'Tous les champs sont requis');
                  return;
                }
                // Update projet nom
                await projetService.database.then((db) => db.update(
                  'projets',
                  {'nom': nom},
                  where: 'id = ?',
                  whereArgs: [projet.id],
                ));
                // Update horaires pour tous les jours
                for (final jour in jours) {
                  await projetService.database.then((db) => db.update(
                    'horaires_projet',
                    {'heureEntree': entree, 'heureSortie': sortie},
                    where: 'projetId = ? AND jour = ?',
                    whereArgs: [projet.id, jour],
                  ));
                }
                await projetController.loadProjets();
                Navigator.of(context).pop();
                Get.snackbar('Succès', 'Projet modifié');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Page administaration', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              authController.logout();
              Get.offAllNamed(AppRoutes.scan);
            },
          ),
        ],
      ),
      body: Obx(() {
        final projets = projetController.projets;
        if (projets.isEmpty) {
          return Center(child: Text('Aucun projet pour le moment', style: TextStyle(fontSize: 18, color: Colors.grey)));
        }
        return RefreshIndicator(
          onRefresh: () async {
            await projetController.loadProjets();
          },
          child: ListView.separated(
            padding: EdgeInsets.only(top: 12, bottom: 80),
            itemCount: projets.length,
            separatorBuilder: (_, __) => Divider(height: 0),
            itemBuilder: (context, index) {
              final projet = projets[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.work, color: Colors.blue.shade700),
                ),
                title: Text(projet.nom, style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Projet #${projet.id}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.orange),
                      tooltip: 'Modifier',
                      onPressed: () {
                        _showEditProjetDialog(context, projet);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Supprimer',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Supprimer'),
                            content: Text('Supprimer ce projet ?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('Annuler')),
                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('Supprimer', style: TextStyle(color: Colors.red)) ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await projetController.deleteProjet(projet.id!);
                          Get.snackbar('Projet supprimé', '', snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
                onTap: () {
                  Get.toNamed('/projet', arguments: projet);
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProjetDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showCreateProjetDialog(BuildContext context) {
    final _nomCtrl = TextEditingController();
    final _entreeCtrl = TextEditingController();
    final _sortieCtrl = TextEditingController();
    final jours = [
      'lundi', 'mardi', 'mercredi', 'jeudi', 'vendredi', 'samedi', 'dimanche'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Créer un projet'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nomCtrl,
                  decoration: InputDecoration(labelText: 'Nom du projet'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _entreeCtrl,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Heure d'entrée (HH:mm)"),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      _entreeCtrl.text = picked.format(context);
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _sortieCtrl,
                  readOnly: true,
                  decoration: InputDecoration(labelText: "Heure de sortie (HH:mm)"),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) {
                      _sortieCtrl.text = picked.format(context);
                    }
                  },
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
                final entree = _entreeCtrl.text.trim();
                final sortie = _sortieCtrl.text.trim();
                if (nom.isEmpty || entree.isEmpty || sortie.isEmpty) {
                  Get.snackbar('Erreur', 'Tous les champs sont requis');
                  return;
                }
                try {
                  final projetId = await projetService.insertProjet(Projet(nom: nom));
                  for (final jour in jours) {
                    await projetService.insertHoraire(
                      HoraireProjet(
                        projetId: projetId,
                        jour: jour,
                        heureEntree: entree,
                        heureSortie: sortie,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                  Get.snackbar('Succès', 'Projet créé avec horaires');
                } catch (e) {
                  Get.snackbar('Erreur', 'Erreur lors de la création: $e');
                }
              },
              child: Text('Créer'),
            ),
          ],
        );
      },
    );
  }
}
