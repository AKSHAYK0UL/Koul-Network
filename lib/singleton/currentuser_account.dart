// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:koul_network/model/koul_account/transaction.dart';

class CurrentuserKoulAccountSingleton {
  static CurrentuserKoulAccountSingleton? _instance;
  late String koulId;
  late String accountHolderName;
  late double accountCurrentBalance;
  late Transaction accountLastTransaction;
  late bool accountLowBalanceAlertIs;
  late double accountLowBalanceAmountAlert;
  late bool accountLargeExpenseAlertIs;
  late double accountLargeExpenseAmountAlert;
  late String transactionPin;
  CurrentuserKoulAccountSingleton._internal({
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

  factory CurrentuserKoulAccountSingleton({
    required koulId,
    required accountHolderName,
    required accountCurrentBalance,
    required accountLastTransaction,
    required accountLowBalanceAlertIs,
    required accountLowBalanceAmountAlert,
    required accountLargeExpenseAlertIs,
    required accountLargeExpenseAmountAlert,
    required transactionPin,
  }) {
    _instance ??= CurrentuserKoulAccountSingleton._internal(
      koulId: koulId,
      accountHolderName: accountHolderName,
      accountCurrentBalance: accountCurrentBalance,
      accountLargeExpenseAlertIs: accountLargeExpenseAlertIs,
      accountLargeExpenseAmountAlert: accountLargeExpenseAmountAlert,
      accountLowBalanceAlertIs: accountLowBalanceAlertIs,
      accountLowBalanceAmountAlert: accountLowBalanceAmountAlert,
      accountLastTransaction: accountLastTransaction,
      transactionPin: transactionPin,
    );
    return _instance!;
  }
  static CurrentuserKoulAccountSingleton getCurrentUserKoulAccountInstance() {
    return _instance!;
  }

  static void clearCurrentUserKoulAccountInstance() {
    _instance = null;
  }
}
