import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/cross%20screen/widget/transaction_detail.dart';
import 'package:koul_network/core/enums/show_phone.dart';
import 'package:koul_network/core/helpers/helper_functions/phone_formatter.dart';
import 'package:koul_network/core/helpers/utc_to_ist.dart';
import 'package:koul_network/model/koul_account/transaction.dart';
import 'package:koul_network/core/singleton/currentuser.dart';

class TransactionDetailScreen extends StatelessWidget {
  static const routeName = "TransactionDetailScreen";
  const TransactionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentuser = CurrentUserSingleton.getCurrentUserInstance().name;
    final screenSize = MediaQuery.sizeOf(context);

    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final transactionData = routeData["transactiondata"] as Transaction;
    final phone = routeData["phone"];
    final phoneNoVisibility = routeData["phoneVisibility"] as ShowPhone;
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Transaction Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.013,
              ),
              CircleAvatar(
                radius: screenSize.height * 0.0364,
                backgroundColor: const Color.fromARGB(135, 15, 14, 14),
                child: Text(
                  transactionData.from.name == currentuser
                      ? transactionData.to.name[0].toUpperCase()
                      : transactionData.from.name[0].toUpperCase(),
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Text(
                transactionData.from.name == currentuser
                    ? "To ${transactionData.to.name.replaceFirst(
                        transactionData.to.name[0],
                        transactionData.to.name[0].toUpperCase(),
                      )}"
                    : "From ${transactionData.from.name.replaceFirst(
                        transactionData.from.name[0],
                        transactionData.from.name[0].toUpperCase(),
                      )}",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (phoneNoVisibility != ShowPhone.phoneEmpty)
                Text(
                  phoneNoVisibility == ShowPhone.phoneNotVisible
                      ? formatPhoneNumber(phone)
                      : phone,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              SizedBox(
                height: screenSize.height * 0.013,
              ),
              Text(
                transactionData.amount.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: screenSize.height * 0.0590,
                      fontWeight: FontWeight.w400,
                    ),
              ),
              SizedBox(
                height: screenSize.height * 0.013,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.greenAccent.shade700,
                    size: screenSize.height * 0.026,
                  ),
                  Text(
                    " Completed",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * 0.00325,
              ),
              Divider(
                thickness: 0.3,
                endIndent: screenSize.height * 0.104,
                indent: screenSize.height * 0.104,
              ),
              SizedBox(
                height: screenSize.height * 0.00325,
              ),
              Text(
                timeFormaterFull(
                  transactionData.date.toString(),
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              buildTransactionDetailBox(
                context: context,
                transactionData: transactionData,
                rightButtonText: "Repot",
                rightButtonFun: () {},
                rightButtonIcon: Icons.report,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
