class User {
  int? id;
  String name;
  String email;
  String password;
  String secretCode;
  String? profileImagePath; // Chemin local de la photo de profil (nullable)

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.secretCode,
    this.profileImagePath, // Optionnel — null si pas de photo
  });

  // Convertit un Map SQLite en objet User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      secretCode: map['secret_code'],
      profileImagePath: map['profile_image_path'], // null si colonne absente ou vide
    );
  }

  // Convertit un objet User en Map pour SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'secret_code': secretCode,
      'profile_image_path': profileImagePath,
    };
  }
}