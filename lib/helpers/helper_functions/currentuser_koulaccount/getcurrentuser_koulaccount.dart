import 'dart:convert';
import 'dart:io';
import 'package:koul_network/model/koul_account/account_balance.dart';
import 'package:http/http.dart' as http;
import 'package:koul_network/secrets/api.dart';
import 'package:koul_network/singleton/currentuser_account.dart';

Future<void> getCurrentuserKoulAccountDatail(String uid) async {
  print("IN KOUL ACCOUNT");
  try {
    final url = Uri.parse("$KOUL_SERVICE_API_URL/account_balance");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          "userid": uid,
        },
      ),
    );
    print("RESPONSE K ID -> ${response.body.toString()}");
    if (response.statusCode == HttpStatus.accepted) {
      final AccountBalance kAccount =
          AccountBalance.fromJson(jsonDecode(response.body));
      CurrentuserKoulAccountSingleton.clearCurrentUserKoulAccountInstance();
      CurrentuserKoulAccountSingleton(
        koulId: kAccount.koulId,
        accountHolderName: kAccount.accountHolderName,
        accountCurrentBalance: kAccount.accountCurrentBalance,
        accountLastTransaction: kAccount.accountLastTransaction,
        accountLowBalanceAlertIs: kAccount.accountLowBalanceAlertIs,
        accountLowBalanceAmountAlert: kAccount.accountLowBalanceAmountAlert,
        accountLargeExpenseAlertIs: kAccount.accountLargeExpenseAlertIs,
        accountLargeExpenseAmountAlert: kAccount.accountLargeExpenseAmountAlert,
        transactionPin: kAccount.transactionPin,
      );
    } else {
      print("ERROR: KACCOUNT TO SINGLETON (HTTP ERROR)");
    }
  } catch (_) {
    print("ERROR: KACCOUNT TO SINGLETON (CATCH)");
  }
}
