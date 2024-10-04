class ToKoulId {
  final String userId;
  final String userEmail;
  final String userName;
  final String phone;

  ToKoulId({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.phone,
  });
  factory ToKoulId.fromJson(Map<String, dynamic> json) {
    return ToKoulId(
      userId: json["userid"],
      userEmail: json["useremail"],
      userName: json["username"],
      phone: json["phone"],
    );
  }
  Map<String, String> toJson() {
    return {
      "userid": userId,
      "useremail": userEmail,
      "username": userName,
      "phone": phone,
    };
  }
}
