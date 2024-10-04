class verifyData {
  final String userId;
  final String vcode;

  verifyData({
    required this.userId,
    required this.vcode,
  });
  factory verifyData.fromJson(Map<String, dynamic> json) {
    return verifyData(
      userId: json["userid"]!,
      vcode: json["vcode"]!,
    );
  }
  Map<String, String> toJson() {
    return {
      "userid": userId,
      "vcode": vcode,
    };
  }
}
