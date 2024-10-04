class SignUpClass {
  String userName;
  String userEmail;
  String password;

  SignUpClass({
    required this.userName,
    required this.userEmail,
    required this.password,
  });

  factory SignUpClass.fromJson(Map<String, dynamic> json) {
    return SignUpClass(
      userName: json['username']!,
      userEmail: json['useremail']!,
      password: json['password']!,
    );
  }
  Map<String, String> toJson() {
    return {
      'username': userName,
      'useremail': userEmail,
      'password': password,
    };
  }
}
