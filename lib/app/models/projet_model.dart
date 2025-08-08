class Projet {
  int? id;
  String nom;

  Projet({this.id, required this.nom});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{'nom': nom};
    if (id != null) map['id'] = id;
    return map;
  }

  factory Projet.fromMap(Map<String, dynamic> map) {
    return Projet(id: map['id'], nom: map['nom']);
  }
}
