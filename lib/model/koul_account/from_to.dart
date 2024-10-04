class FromTo {
  String name;
  String koulId;

  FromTo({required this.name, required this.koulId});
  factory FromTo.fromJson(Map<String, dynamic> json) {
    return FromTo(
      name: json["name"],
      koulId: json["koul_id"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'koul_id': koulId,
    };
  }
}
