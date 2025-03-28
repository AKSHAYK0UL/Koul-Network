import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/helpers/helper_functions/number_formatter.dart';
import 'package:koul_network/model/koul_account/account_balance.dart';

Widget buildBalanceCard(BuildContext context, AccountBalance account) {
  final screenSize = MediaQuery.sizeOf(context);
  return Card(
    margin: EdgeInsets.all(screenSize.width * 0.060),
    color: const Color.fromARGB(255, 44, 43, 43),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: SizedBox(
      height: screenSize.width * 0.640,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.065),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white70,
                  size: screenSize.width * 0.075,
                ),
                SizedBox(
                  width: screenSize.width * 0.020,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${numberFormatter(account.accountCurrentBalance.toString())} ₹ ",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                    overflow: TextOverflow.visible,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.030,
          ),
          SizedBox(
            width: screenSize.width * 0.510,
            height: screenSize.height * 0.068,
            child: TextButton.icon(
              onPressed: () {
                context.read<KoulAccountBloc>().add(AccountBalanceEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh Balance"),
            ),
          ),
        ],
      ),
    ),
  );
}
