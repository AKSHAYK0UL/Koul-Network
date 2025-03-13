import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/transaction_pin.dart';
import 'package:koul_network/UI/home/cross%20screen/widget/show_alert_dialog.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/widgets/showmodelsheet_on_payment_error.dart';
import 'package:koul_network/core/enums/route_pay_pin.dart';
import 'package:koul_network/core/singleton/currentuser_account.dart';
import 'package:permission_handler/permission_handler.dart';

List<String> steps = [
  "Tap on Open Setting.",
  "Select Permissions.",
  "Allow Phone Permission."
];

void handlePayment(
    {required BuildContext context,
    required String toKoulId,
    required String toName,
    required double amount,
    required CurrentuserKoulAccountSingleton currentKoulAccount}) async {
  final screenSize = MediaQuery.sizeOf(context);

  bool isPositiveAmount = amount >= 1;
  bool isLowBalanceAlert = currentKoulAccount.accountLowBalanceAlertIs &&
      currentKoulAccount.accountLowBalanceAmountAlert >
          (currentKoulAccount.accountCurrentBalance - amount);
  bool isLargeExpenseAlert = currentKoulAccount.accountLargeExpenseAlertIs &&
      currentKoulAccount.accountLargeExpenseAmountAlert - 1 < amount;
  bool hasSufficientBalance =
      currentKoulAccount.accountCurrentBalance >= amount;

  if (isPositiveAmount &&
      (currentKoulAccount.transactionPin.isEmpty ||
          currentKoulAccount.transactionPin == "__")) {
    showAlertDialog(
        context: context,
        title: "Setup your Koul pin first",
        content:
            "Before proceeding with your payment, please create the Koul PIN.\nYou will need to enter this PIN every time you make a payment.",
        amount: amount,
        toKoulId: toKoulId,
        toName: toName,
        route: AlertRoute.pin);
  } else if (isPositiveAmount) {
    if (!hasSufficientBalance) {
      showModelSheet(context, "insufficent amount");
    } else if (isLowBalanceAlert && isLargeExpenseAlert) {
      showAlertDialog(
          context: context,
          title: "Low balance",
          content:
              "After this transaction, your account balance will be less than the limit you have set for low balance alert.",
          amount: amount,
          toKoulId: toKoulId,
          toName: toName,
          route: AlertRoute.pay);
    } else if (isLowBalanceAlert) {
      showAlertDialog(
          context: context,
          title: "Low balance",
          content:
              "After this transaction, your account balance will be less than the limit you have set for low balance alert.",
          amount: amount,
          toKoulId: toKoulId,
          toName: toName,
          route: AlertRoute.pay);
    } else if (isLargeExpenseAlert && hasSufficientBalance) {
      showAlertDialog(
          context: context,
          title: "Large amount",
          content:
              "The amount you are about to pay, ₹$amount, exceeds the limit you have established for large amount alerts.\nPlease verify that you are paying the right person to avoid any errors",
          amount: amount,
          toKoulId: toKoulId,
          toName: toName,
          route: AlertRoute.pay);
    } else if (hasSufficientBalance) {
      if (await Permission.phone.isDenied) {
        Permission.phone.request();
      } else if (await Permission.phone.isPermanentlyDenied) {
        if (!context.mounted) return;
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                alignment: Alignment.center,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 54, 54, 54),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.045,
                      vertical: screenSize.width * 0.080),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Enable Phone Permissions",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * 0.013,
                      ),
                      Text(
                        "Enable phone permissions to proceed with your payment",
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.013,
                      ),
                      BulletedList(
                        bulletColor: Colors.white,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        listItems: steps,
                        style: Theme.of(context).textTheme.labelMedium,
                        listOrder: ListOrder.unordered,
                        bulletType: BulletType.conventional,
                      ),
                      const Spacer(),
                      SizedBox(
                        width: double.infinity,
                        height: screenSize.height * 0.071,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await openAppSettings();
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                          },
                          label: Text(
                            "Open setting",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          icon: const Icon(Icons.settings),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
      } else {
        if (!context.mounted) return;
        Navigator.of(context).pushNamed(TransactionPin.routeName, arguments: {
          "tokoulid": toKoulId,
          "amount": amount.toString(),
          "toname": toName
        });
      }
    }
  } else {
    buildSnackBar(context, "payment must be at least ₹1");
  }
}
