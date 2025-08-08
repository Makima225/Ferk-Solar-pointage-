
import 'package:get/get.dart';
import '../../controllers/personnel_controller.dart';
import '../../models/personnel_model.dart';
import 'package:flutter/material.dart';

class ListePresencePage extends StatelessWidget {
  final int entrepriseId;
  const ListePresencePage({Key? key, required this.entrepriseId}) : super(key: key);

  final List<String> jours = const ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  @override
  Widget build(BuildContext context) {
    final PersonnelController personnelController = Get.put(PersonnelController());
    personnelController.loadPersonnels(entrepriseId);
    return Obx(() {
      final personnels = personnelController.personnels;
      return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.blue[50]),
              dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) return Colors.blue[100];
                return null;
              }),
              columns: [
                DataColumn(label: Text('Personnel', style: TextStyle(fontWeight: FontWeight.bold))),
                ...jours.map((j) => DataColumn(label: Text(j, style: TextStyle(fontWeight: FontWeight.bold)))),
                DataColumn(label: Text('Total H. Travaillées', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                DataColumn(label: Text('Retard cumulé', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red))),
                DataColumn(label: Text('Heures supp.', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green))),
              ],
              rows: personnels.map((pers) {
                // Pas de pointage réel encore, on affiche des cellules vides
                return DataRow(
                  cells: [
                    DataCell(Text(pers.nomComplet, style: TextStyle(fontWeight: FontWeight.w600))),
                    ...jours.map((j) => DataCell(Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HA: -', style: TextStyle(fontSize: 12)),
                        Text('HS: -', style: TextStyle(fontSize: 12)),
                      ],
                    ))),
                    DataCell(Text('0h 00', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
                    DataCell(Text('0h 00', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
                    DataCell(Text('0h 00', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }


// ...
}
