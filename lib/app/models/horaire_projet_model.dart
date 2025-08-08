class HoraireProjet {
  int? id;
  int projetId;
  String jour; // 'lundi', 'mardi', ...
  String heureEntree; // Format 'HH:mm'
  String heureSortie;

  HoraireProjet({
    this.id,
    required this.projetId,
    required this.jour,
    required this.heureEntree,
    required this.heureSortie,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'projetId': projetId,
      'jour': jour,
      'heureEntree': heureEntree,
      'heureSortie': heureSortie,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory HoraireProjet.fromMap(Map<String, dynamic> map) {
    return HoraireProjet(
      id: map['id'],
      projetId: map['projetId'],
      jour: map['jour'],
      heureEntree: map['heureEntree'],
      heureSortie: map['heureSortie'],
    );
  }
}
