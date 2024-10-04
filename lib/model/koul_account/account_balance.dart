import 'package:koul_network/model/koul_account/transaction.dart';

class AccountBalance {
  String koulId;
  String accountHolderName;
  double accountCurrentBalance;
  Transaction accountLastTransaction;
  bool accountLowBalanceAlertIs;
  double accountLowBalanceAmountAlert;
  bool accountLargeExpenseAlertIs;
  double accountLargeExpenseAmountAlert;
  String transactionPin;

  AccountBalance({
    required this.koulId,
    required this.accountHolderName,
    required this.accountCurrentBalance,
    required this.accountLastTransaction,
    required this.accountLowBalanceAlertIs,
    required this.accountLowBalanceAmountAlert,
    required this.accountLargeExpenseAlertIs,
    required this.accountLargeExpenseAmountAlert,
    required this.transactionPin,
  });

  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    return AccountBalance(
      transactionPin: json['account_transaction_pin'],
      koulId: json['koul_id'],
      accountHolderName: json['account_holder_name'],
      accountCurrentBalance: json['account_current_balance'].toDouble(),
      accountLastTransaction:
          Transaction.fromJson(json['account_last_transaction']),
      accountLowBalanceAlertIs: json['account_low_balance_alert_is'],
      accountLowBalanceAmountAlert:
          json['account_low_balance_amount_alert'].toDouble(),
      accountLargeExpenseAlertIs: json['account_large_expense_alert_is'],
      accountLargeExpenseAmountAlert:
          json['account_large_expense_amount_alert'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'account_transaction_pin': transactionPin,
      'koul_id': koulId,
      'account_holder_name': accountHolderName,
      'account_current_balance': accountCurrentBalance,
      'account_last_transaction': accountLastTransaction.toJson(),
      'account_low_balance_alert_is': accountLowBalanceAlertIs,
      'account_low_balance_amount_alert': accountLowBalanceAmountAlert,
      'account_large_expense_alert_is': accountLargeExpenseAlertIs,
      'account_large_expense_amount_alert': accountLargeExpenseAmountAlert,
    };
  }
}
