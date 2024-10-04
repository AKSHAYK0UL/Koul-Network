class User {
  final String userId;
  final String userEmail;
  final String userName;
  final String authType;
  final String phone;
  String authToken;

  User({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.authType,
    required this.phone,
    required this.authToken,
  });
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json["userid"],
        userEmail: json["useremail"],
        userName: json["username"],
        authType: json["authtype"],
        phone: json["phone"],
        authToken: json["authtoken"]);
  }
  Map<String, String> toJson() {
    return {
      "userid": userId,
      "useremail": userEmail,
      "username": userName,
      "authtype": authType,
      "phone": phone,
      "authtoken": authToken,
    };
  }
}

class GetUserData {
  final String userId;
  final String userEmail;
  final String userName;
  final String authType;
  final String phone;

  GetUserData({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.authType,
    required this.phone,
  });
  factory GetUserData.fromJson(Map<String, dynamic> json) {
    return GetUserData(
      userId: json["userid"],
      userEmail: json["useremail"],
      userName: json["username"],
      authType: json["authtype"],
      phone: json["phone"],
    );
  }
  Map<String, String> toJson() {
    return {
      "userid": userId,
      "useremail": userEmail,
      "username": userName,
      "authtype": authType,
      "phone": phone,
    };
  }
}
