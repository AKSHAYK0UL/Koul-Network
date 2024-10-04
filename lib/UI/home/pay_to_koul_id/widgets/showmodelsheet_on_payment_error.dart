import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/check_balance/screens/checkbalance.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/errors/payment_errors.dart';

//Insufficient Funds
//transaction failed
//other

void showModelSheet(BuildContext context, String error) {
  final screenSize = MediaQuery.sizeOf(context);
  List<String> errorDesp = error.contains("insufficent amount")
      ? insufficientFund
      : error.contains("transaction failed")
          ? tranactionFailed
          : otherError;
  String errorHeading = error.contains("insufficent amount")
      ? errortitle[0]
      : error.contains("transaction failed")
          ? errortitle[1]
          : errortitle[2];
  showModalBottomSheet(
    isDismissible: false,
    context: context,
    builder: (context) {
      return Container(
        height: screenSize.height * 0.70,
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 54, 54, 54),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10))),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.030,
              vertical: screenSize.width * 0.080),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  errorHeading,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Divider(),
                BulletedList(
                  bulletColor: Colors.white,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  listItems: errorDesp,
                  style: Theme.of(context).textTheme.labelMedium,
                  listOrder: ListOrder.unordered,
                  bulletType: BulletType.conventional,
                ),
                SizedBox(
                  height: screenSize.height * 0.050,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenSize.height * 0.060,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom().copyWith(
                            backgroundColor: WidgetStateProperty.resolveWith(
                              (states) => const Color.fromARGB(255, 9, 59, 135),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.refresh),
                          label: FittedBox(
                            fit: BoxFit.fill,
                            child: Text(
                              "Try Again",
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (error == "insufficent amount")
                      SizedBox(
                        width: screenSize.height * 0.020,
                      ),
                    if (error == "insufficent amount")
                      Expanded(
                        child: SizedBox(
                          height: screenSize.height * 0.060,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom().copyWith(
                              backgroundColor: WidgetStateProperty.resolveWith(
                                (states) =>
                                    const Color.fromARGB(255, 9, 59, 135),
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<KoulAccountBloc>()
                                  .add(SetStateToInitial());

                              Navigator.of(context).pop();
                              Navigator.of(context).pushNamed(
                                CheckbalanceScreen.routeName,
                              );
                            },
                            icon: const Icon(Icons.balance),
                            label: FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                "Check Balance",
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
