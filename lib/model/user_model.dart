class UserModel {
  final String username;
  final String email;
  final String password;

  UserModel(
      {required this.username, required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'name': username,
      'email': email,
      'password': password,
      // Tambahkan field lain yang diperlukan
    };
  }
}
