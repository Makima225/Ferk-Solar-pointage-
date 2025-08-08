class Entreprise {
  final int? id;
  final String nom;
  final String typeEntreprise;
  final int projetId;

  Entreprise({this.id, required this.nom, required this.typeEntreprise, required this.projetId});

  factory Entreprise.fromMap(Map<String, dynamic> map) {
    return Entreprise(
      id: map['id'],
      nom: map['nom'],
      typeEntreprise: map['type_entreprise'],
      projetId: map['projetId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'type_entreprise': typeEntreprise,
      'projetId': projetId,
    };
  }
}
