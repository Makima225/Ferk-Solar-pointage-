class User {
  int? id;
  String name;
  String username;
  String password;

  User({
    this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  // Pour l'insertion dans SQLite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'username': username,
      'password': password,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Pour la lecture depuis SQLite
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      username: map['username'],
      password: map['password'],
    );
  }
}
