import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/cross%20screen/transaction_detail.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/enums/ledgerInfo.dart';
import 'package:koul_network/enums/show_phone.dart';
import 'package:koul_network/helpers/utc_to_ist.dart';
import 'package:koul_network/singleton/currentuser.dart';

class Transactions extends StatefulWidget {
  static const routeName = "Transactions";
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> with RouteAware {
  Ledgerinfo txninfoView = Ledgerinfo.both;

  @override
  void initState() {
    final currentState = context.read<KoulAccountBloc>().state;

    if (currentState.runtimeType != AllTransactionsListState) {
      context.read<KoulAccountBloc>().add(GetAllTransactionsListEvent());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CurrentUserSingleton currentUser =
        CurrentUserSingleton.getCurrentUserInstance();
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: AppBar(
          scrolledUnderElevation: 0,
          title: Text(
            "Ledger",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: screenSize.height * 0.008,
                vertical: screenSize.height * 0.009),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black26,
            ),
            child: DropdownButton(
                value: txninfoView,
                style: Theme.of(context).textTheme.titleSmall,
                iconEnabledColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(
                    horizontal: screenSize.height * 0.008,
                    vertical: screenSize.height * 0.009),
                underline: const Divider(
                  color: Colors.transparent,
                ),
                items: [
                  DropdownMenuItem(
                    value: Ledgerinfo.credit,
                    child: Text(
                      "Credit",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  DropdownMenuItem(
                    value: Ledgerinfo.debit,
                    child: Text("Debit",
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                  DropdownMenuItem(
                    value: Ledgerinfo.both,
                    child: Text("All",
                        style: Theme.of(context).textTheme.titleSmall),
                  ),
                ],
                onChanged: (Ledgerinfo? txnInf0) {
                  setState(() {
                    txninfoView = txnInf0!;
                  });
                }),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<KoulAccountBloc>().add(GetAllTransactionsListEvent());
        },
        color: Colors.white,
        child: BlocBuilder<KoulAccountBloc, KoulAccountState>(
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (state is FailureState) {
              return Text(state.error);
            }
            if (state is AllTransactionsListState) {
              final creditTransaction = state.transactions
                  .where((t) => t.transactionType == "credit")
                  .toList();
              final debitTransaction = state.transactions
                  .where((t) => t.transactionType != "credit")
                  .toList();

              return state.transactions.length == 1
                  ? Center(
                      child: Text(
                        "No Transaction Done Yet!",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    )
                  : ListView.builder(
                      itemCount: txninfoView == Ledgerinfo.credit
                          ? creditTransaction.length
                          : txninfoView == Ledgerinfo.debit
                              ? debitTransaction.length - 1
                              : state.transactions.length - 1,
                      itemBuilder: (context, index) {
                        // Reverse Index
                        int rIndex = (txninfoView == Ledgerinfo.credit
                                ? creditTransaction.length
                                : txninfoView == Ledgerinfo.debit
                                    ? debitTransaction.length
                                    : state.transactions.length) -
                            index -
                            1;

                        final tData = txninfoView == Ledgerinfo.credit
                            ? creditTransaction[rIndex]
                            : txninfoView == Ledgerinfo.debit
                                ? debitTransaction[rIndex]
                                : state.transactions[rIndex];

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
                                  ? tData.from.name.replaceFirst(
                                      tData.from.name[0],
                                      tData.from.name[0].toUpperCase())
                                  : tData.to.name.replaceFirst(tData.to.name[0],
                                      tData.to.name[0].toUpperCase()),
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
                                      ? "+ ₹${tData.amount.toStringAsFixed(2)}"
                                      : "₹${tData.amount.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
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
                    );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

//const Color.fromARGB(66, 7, 7, 7),