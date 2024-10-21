import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/cross%20screen/transaction_detail.dart';

import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/enums/show_phone.dart';
import 'package:koul_network/helpers/utc_to_ist.dart';
import 'package:koul_network/singleton/currentuser.dart';

class RecentTxn extends StatelessWidget {
  final ChartDataState state;
  const RecentTxn({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    final screenSize = MediaQuery.sizeOf(context);
    return Column(
      children: [
        ColoredBox(
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.height * 0.03,
              vertical: screenSize.height * 0.02,
            ),
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                "All transactions for the month of ${state.chartdata.month}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: state.chartdata.newTXN.length - 1,
            itemBuilder: (context, index) {
              int rIndex =
                  state.chartdata.newTXN.length - index - 1; //reverse Index
              final tData = state.chartdata.newTXN[rIndex];
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.height * 0.008,
                    vertical: screenSize.height * 0.004),
                child: ListTile(
                  minTileHeight: screenSize.height * 0.105,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      TransactionDetailScreen.routeName,
                      arguments: {
                        "transactiondata": tData,
                        "phone": "",
                        "phoneVisibility": ShowPhone.phoneEmpty
                      },
                    );
                  },
                  tileColor: const Color.fromARGB(255, 40, 39, 39),
                  title: Text(
                    tData.to.koulId == currentUser.id
                        ? tData.from.name.replaceFirst(tData.from.name[0],
                            tData.from.name[0].toUpperCase())
                        : tData.to.name.replaceFirst(
                            tData.to.name[0], tData.to.name[0].toUpperCase()),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    timeFormaterFull(
                      tData.date.toString(),
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Container(
                    alignment: Alignment.centerRight,
                    width: screenSize.height * 0.120,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        tData.transactionType == "credit"
                            ? "+ ₹${tData.amount.toString()}"
                            : "₹${tData.amount.toString()}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: tData.transactionType == "credit"
                                  ? Colors.green
                                  : Colors.white,
                            ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
