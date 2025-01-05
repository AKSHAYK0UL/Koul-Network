import 'package:koul_network/model/koul_account/from_to.dart';

class Fund {
  final double amount;
  final FromTo from;
  final FromTo to;
  final DateTime date;
  final String txn;

  Fund({
    required this.amount,
    required this.from,
    required this.to,
    required this.date,
    required this.txn,
  });

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      amount: (json["amount"] as num).toDouble(),
      from: FromTo.fromJson(json["from"]),
      to: FromTo.fromJson(json["to"]),
      date: DateTime.parse(json["date"]),
      txn: json["txn"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "from": from.toJson(),
      "to": to.toJson(),
      "date": date.toIso8601String(),
      "txn": txn,
    };
  }
}
