class CurrentUserSingleton {
  static CurrentUserSingleton? _instance;

  late String name;
  late String id;
  late String email;
  late String phone;
  late String authType;
  late String authToken;

  CurrentUserSingleton._internal({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.authType,
    required this.authToken,
  });

  factory CurrentUserSingleton({
    required String name,
    required String id,
    required String email,
    required String phone,
    required String authType,
    required String authToken,
  }) {
    _instance ??= CurrentUserSingleton._internal(
      name: name,
      id: id,
      email: email,
      phone: phone,
      authType: authType,
      authToken: authToken,
    );
    return _instance!;
  }
  static CurrentUserSingleton getCurrentUserInstance() {
    return _instance!;
  }

  static void clearCurrentUserInstance() {
    _instance = null;
  }
}
