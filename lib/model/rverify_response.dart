class Ruser {
  final String userId;
  final String userEmail;
  final String authToken;

  Ruser({
    required this.userId,
    required this.userEmail,
    required this.authToken,
  });
  factory Ruser.fromJson(Map<String, dynamic> json) {
    return Ruser(
        userId: json["userid"],
        userEmail: json["useremail"],
        authToken: json["authtoken"]);
  }
  Map<String, String> toJson() {
    return {
      "userid": userId,
      "useremail": userEmail,
      "authtoken": authToken,
    };
  }
}
