import 'package:intl/intl.dart';
import 'package:koul_network/model/koul_account/chart_data.dart';
import 'package:koul_network/model/koul_account/large_amount.dart';
import 'package:koul_network/model/koul_account/transaction.dart';

ChartDataModel getTXNChartData(List<Transaction> transactions) {
  double debitAmount = 0;
  double creditAmount = 0;

  // Get the last transaction's month and year for filtering
  final lastTxnDate = DateFormat("MMM-yyyy").format(transactions.last.date);

  // Filter transactions for the current/last month
  final newTXN = transactions.where((txn) {
    return DateFormat("MMM-yyyy").format(txn.date) == lastTxnDate;
  }).toList();

  // Calculate total debit and credit for the month
  for (var txn in newTXN) {
    if (txn.transactionType == "debit") {
      debitAmount += txn.amount;
    } else if (txn.transactionType == "credit") {
      creditAmount += txn.amount;
    }
  }

  // Get the largest debit transaction
  final debitTXN =
      newTXN.where((txn) => txn.transactionType == "debit").toList();
  LargeAmount? largeDebitTXN;
  if (debitTXN.isNotEmpty) {
    debitTXN.sort((a, b) => b.amount.compareTo(a.amount));
    largeDebitTXN = LargeAmount(
        amount: debitTXN.first.amount, name: debitTXN.first.to.name);
  } else {
    largeDebitTXN = LargeAmount(amount: 0, name: '');
  }

  // Get the largest credit transaction
  final creditTXN =
      newTXN.where((txn) => txn.transactionType == "credit").toList();
  LargeAmount? largeCreditTXN;
  if (creditTXN.isNotEmpty) {
    creditTXN.sort((a, b) => b.amount.compareTo(a.amount));
    largeCreditTXN = LargeAmount(
        amount: creditTXN.first.amount, name: creditTXN.first.from.name);
  } else {
    largeCreditTXN = LargeAmount(amount: 0, name: '');
  }

  // Get the current month name
  String currentMonth = DateFormat("MMMM").format(newTXN.first.date);

  return ChartDataModel(
      newTXN: newTXN,
      debitAmount: debitAmount,
      creditAmount: creditAmount,
      largeAmountPaidTo: largeDebitTXN,
      largeAmountReceivedFrom: largeCreditTXN,
      month: currentMonth);
}
