class CurrentUserSingleton {
  static CurrentUserSingleton? _instance;

  late String name;
  late String id;
  late String email;
  late String phone;
  late String authType;

  CurrentUserSingleton._internal({
    required this.name,
    required this.id,
    required this.email,
    required this.phone,
    required this.authType,
  });

  factory CurrentUserSingleton({
    required String name,
    required String id,
    required String email,
    required String phone,
    required String authType,
  }) {
    _instance ??= CurrentUserSingleton._internal(
        name: name, id: id, email: email, phone: phone, authType: authType);
    return _instance!;
  }
  static CurrentUserSingleton getCurrentUserInstance() {
    return _instance!;
  }

  static void clearCurrentUserInstance() {
    _instance = null;
  }
}
