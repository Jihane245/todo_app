class User {

  int? id;
  String name;
  String email;
  String password;
  String secretCode;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.secretCode,
  });

}