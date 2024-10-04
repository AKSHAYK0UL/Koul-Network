class SignInClass {
  String userEmail;
  String password;

  SignInClass({
    required this.userEmail,
    required this.password,
  });

  factory SignInClass.fromJson(Map<String, dynamic> json) {
    return SignInClass(
        userEmail: json['useremail']!, password: json['password']!);
  }
  Map<String, String> toJson() {
    return {
      'useremail': userEmail,
      'password': password,
    };
  }
}
