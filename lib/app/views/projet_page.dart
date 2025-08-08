import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/projet_model.dart';
import '../models/horaire_projet_model.dart';
import '../services/projet_service.dart';

class ProjetPage extends StatelessWidget {
  final Projet projet;
  final ProjetService projetService = Get.find<ProjetService>();

  ProjetPage({Key? key, required this.projet}) : super(key: key);

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
          body: Center(child: Text('')),
        );
      },
    );
  }
}
