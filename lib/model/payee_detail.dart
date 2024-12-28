class PayeeDetail {
  String name;
  String koulId;
  String phoneNo;
  String email;
  PayeeDetail(
      {required this.name,
      required this.koulId,
      required this.phoneNo,
      required this.email});
  factory PayeeDetail.fromJson(Map<String, dynamic> json) {
    return PayeeDetail(
      name: json["account_holder_name"],
      koulId: json["koul_id"],
      phoneNo: json["account_holder_phone"],
      email: json["account_holder_email"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "account_holder_name": name,
      "koul_id": koulId,
      "account_holder_phone": phoneNo,
      "account_holder_email": email,
    };
  }
}
