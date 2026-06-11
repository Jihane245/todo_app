import '../database/database_helper.dart';

class AuthController {

  DatabaseHelper db = DatabaseHelper();

  Future<bool> register(
    String name,
    String email,
    String password,
    String secretCode,
  ) async {

    var user = await db.getUserByEmail(
      email.trim(),
    );

    if (user.isNotEmpty) {
      return false;
    }

    await db.insertUser(
      name.trim(),
      email.trim(),
      password.trim(),
      secretCode.trim(),
    );

    return true;
  }

  Future<Map<String, dynamic>?> login(
  String email,
  String password,
) async {

  var user = await db.loginUser(
    email.trim(),
    password.trim(),
  );

  if (user.isEmpty) {
    return null;
  }

  return user.first;
}
  Future<bool> resetPassword(
    String email,
    String secretCode,
    String newPassword,
  ) async {

    var user = await db.verifySecretCode(
      email.trim(),
      secretCode.trim(),
    );

    if (user.isEmpty) {
      return false;
    }

    await db.updatePassword(
      email.trim(),
      newPassword.trim(),
    );

    return true;
  }

  // Récupère un utilisateur par son ID — utilisé dans HomePage
  // pour afficher le nom de l'utilisateur connecté (conformité MVC)
  Future<String> getUserName(int id) async {
    final user = await db.getUserById(id);
    return user != null ? user['name'] as String : 'Utilisateur';
  }
}