import 'package:koul_network/model/koul_account/from_to.dart';

class Transaction {
  final double amount;
  FromTo to;
  FromTo from;
  DateTime date;
  final bool transactionStatus;
  String transactionType;
  String transactionId;

  Transaction({
    required this.amount,
    required this.to,
    required this.from,
    required this.date,
    required this.transactionStatus,
    required this.transactionType,
    required this.transactionId,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'].toDouble(),
      to: FromTo.fromJson(json['to']),
      from: FromTo.fromJson(json['from']),
      date: DateTime.parse(json['date']),
      transactionStatus: json['transaction_status'],
      transactionType: json['transaction_type'],
      transactionId: json['transaction_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'to': to,
      'from': from,
      'date': date.toIso8601String(),
      'transaction_status': transactionStatus,
      'transaction_type': transactionType,
      'transaction_id': transactionId,
    };
  }
}
