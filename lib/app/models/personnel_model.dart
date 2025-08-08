import 'package:uuid/uuid.dart';

class Personnel {
  final int? id;
  final String uuid;
  final String nomComplet;
  final String fonction;
  final String? location;
  final int entrepriseId;
  final String? qrCodePath;

  Personnel({
    this.id,
    required this.uuid,
    required this.nomComplet,
    required this.fonction,
    this.location,
    required this.entrepriseId,
    this.qrCodePath,
  });

  factory Personnel.fromMap(Map<String, dynamic> map) {
    return Personnel(
      id: map['id'],
      uuid: map['uuid'],
      nomComplet: map['nom_complet'],
      fonction: map['fonction'],
      location: map['location'],
      entrepriseId: map['entrepriseId'],
      qrCodePath: map['qr_code_path'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'uuid': uuid,
      'nom_complet': nomComplet,
      'fonction': fonction,
      'location': location,
      'entrepriseId': entrepriseId,
      'qr_code_path': qrCodePath,
    };
  }

  static String generateUuid() => const Uuid().v4();
}
