import 'package:koul_network/model/koul_account/large_amount.dart';
import 'package:koul_network/model/koul_account/transaction.dart';

class ChartDataModel {
  List<Transaction> newTXN;
  double debitAmount;
  double creditAmount;
  LargeAmount largeAmountPaidTo;
  LargeAmount largeAmountReceivedFrom;
  String month;

  ChartDataModel({
    required this.newTXN,
    required this.debitAmount,
    required this.creditAmount,
    required this.largeAmountPaidTo,
    required this.largeAmountReceivedFrom,
    required this.month,
  });
}
