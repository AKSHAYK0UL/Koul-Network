import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/transaction_pin.dart';
import 'package:koul_network/enums/route_pay_pin.dart';
import 'package:koul_network/helpers/auth_bio_pin.dart';

showAlertDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required String toKoulId,
    required double amount,
    required String toName,
    required AlertRoute route}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(content, style: Theme.of(context).textTheme.bodySmall),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (route != AlertRoute.sim)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                route == AlertRoute.pay
                    ? Navigator.of(context).pushNamed(
                        TransactionPin.routeName,
                        arguments: {
                          "tokoulid": toKoulId,
                          "amount": amount.toString(),
                          "toname": toName
                        },
                      )
                    : authenticateWithBiometrics(context, toKoulId);
              },
              child: Text(
                "Continue",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
        ],
      );
    },
  );
}
