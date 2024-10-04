import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/cross%20screen/transaction_detail.dart';
import 'package:koul_network/enums/show_phone.dart';
import 'package:koul_network/helpers/utc_to_ist.dart';
import 'package:koul_network/model/koul_account/transaction.dart';
import 'package:koul_network/singleton/currentuser.dart';

bool transactionTime(
    DateTime currentTransactiondate, DateTime previousTransactionDate) {
  final currentDate = utcToIst(currentTransactiondate.toString());
  final previousDate = utcToIst(previousTransactionDate.toString());

  return currentDate == previousDate ? true : false;
}

Widget buildPreviousTranactionCard(
    {required BuildContext context,
    required Transaction transactionData,
    required DateTime previousTransactionDate,
    required String phone,
    required ShowPhone phoneVisibility}) {
  final currentuser = CurrentUserSingleton.getCurrentUserInstance().name;

  final screenSize = MediaQuery.sizeOf(context);
  return Column(
    children: [
      if (!transactionTime(transactionData.date, previousTransactionDate))
        Chip(
          backgroundColor: Colors.grey.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          label: Text(
            utcToIst(transactionData.date.toString()),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      Align(
        alignment: transactionData.from.koulId ==
                CurrentUserSingleton.getCurrentUserInstance().id
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(
              horizontal: screenSize.height * 0.0132, vertical: 1),
          height: screenSize.height * 0.1715,
          width: screenSize.height * 0.296,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                TransactionDetailScreen.routeName,
                arguments: {
                  "transactiondata": transactionData,
                  "phone": phone,
                  "phoneVisibility": phoneVisibility
                },
              );
            },
            borderRadius: BorderRadius.circular(18),
            splashColor: const Color.fromARGB(255, 41, 41, 41),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              elevation: 2,
              color: const Color.fromARGB(255, 49, 49, 49),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.height * 0.0264),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentuser == transactionData.from.name
                          ? "Payment to ${transactionData.to.name.replaceFirst(transactionData.to.name[0], transactionData.to.name[0].toUpperCase()).split(' ')[0]}"
                          : "Payment to you",
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.0106,
                    ),
                    Text(
                      "₹${transactionData.amount}",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.0106,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.greenAccent.shade700,
                          size: screenSize.height * 0.0264,
                        ),
                        Text(
                          "  Paid  ${timeFormater(transactionData.date.toString())}",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: screenSize.height * 0.0304,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: screenSize.height * 0.0220,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
