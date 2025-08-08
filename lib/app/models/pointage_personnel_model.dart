

class PointagePersonnel {
  final int? id;
  final int personnelId;
  final DateTime date;
  final DateTime? heureEntree;
  final DateTime? heureSortie;
  final int? retardMinutes;
  final int? heuresSuppMinutes;

  PointagePersonnel({
    this.id,
    required this.personnelId,
    required this.date,
    this.heureEntree,
    this.heureSortie,
    this.retardMinutes,
    this.heuresSuppMinutes,
  });

  factory PointagePersonnel.fromMap(Map<String, dynamic> map) {
    return PointagePersonnel(
      id: map['id'],
      personnelId: map['personnelId'],
      date: DateTime.parse(map['date']),
      heureEntree: map['heureEntree'] != null ? DateTime.parse(map['heureEntree']) : null,
      heureSortie: map['heureSortie'] != null ? DateTime.parse(map['heureSortie']) : null,
      retardMinutes: map['retardMinutes'],
      heuresSuppMinutes: map['heuresSuppMinutes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'personnelId': personnelId,
      'date': date.toIso8601String(),
      'heureEntree': heureEntree?.toIso8601String(),
      'heureSortie': heureSortie?.toIso8601String(),
      'retardMinutes': retardMinutes,
      'heuresSuppMinutes': heuresSuppMinutes,
    };
  }
}
