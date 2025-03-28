import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/cross%20screen/transaction_detail.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/core/enums/show_phone.dart';
import 'package:koul_network/core/helpers/helper_functions/number_formatter.dart';
import 'package:koul_network/core/helpers/utc_to_ist.dart';
import 'package:koul_network/model/koul_account/transaction.dart';
import 'package:koul_network/core/singleton/currentuser.dart';

class FundTxn extends StatefulWidget {
  static const routeName = "/fundtxn";
  const FundTxn({super.key});

  @override
  State<FundTxn> createState() => _FundTxnState();
}

class _FundTxnState extends State<FundTxn> {
  final currentUser = CurrentUserSingleton.getCurrentUserInstance();
  @override
  void initState() {
    context.read<StripeBloc>().add(GetFundsTXNList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          scrolledUnderElevation: 0,
          title: Text(
            "Stripe Transactions",
            style: Theme.of(context).textTheme.titleMedium,
          )),
      body: BlocConsumer<StripeBloc, StripeState>(
        listenWhen: (previous, current) => previous != current,
        buildWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is ErrorState) {
            buildSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (state is FundTXNState) {
            return state.fundTxnList.isEmpty
                ? Center(
                    child: Text(
                      "No Transaction Done Yet!",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.fundTxnList.length,
                    itemBuilder: (context, index) {
                      final rIndex = (state.fundTxnList.length) -
                          index -
                          1; //reverse Index
                      final fundData = state.fundTxnList[rIndex];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.height * 0.008,
                            vertical: screenSize.height * 0.004),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              TransactionDetailScreen.routeName,
                              arguments: {
                                "transactiondata": Transaction(
                                    amount: fundData.amount,
                                    date: fundData.date,
                                    from: fundData.from,
                                    to: fundData.to,
                                    transactionId: fundData.txn,
                                    transactionStatus: true,
                                    transactionType:
                                        fundData.to.koulId == currentUser.id
                                            ? "credit"
                                            : "debit"),
                                "phone": "",
                                "phoneVisibility": ShowPhone.phoneEmpty
                              },
                            );
                          },
                          minTileHeight: screenSize.height * 0.105,
                          tileColor: const Color.fromARGB(255, 40, 39, 39),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          splashColor: Colors.transparent,
                          title: Text(
                            fundData.to.koulId == currentUser.id
                                ? "Self Transfer"
                                : fundData.to.name.replaceFirst(
                                    fundData.to.name[0],
                                    fundData.to.name[0].toUpperCase()),
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          subtitle: Text(
                            timeFormaterFull(fundData.date.toString()),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: Container(
                            alignment: Alignment.centerRight,
                            width: screenSize.height * 0.120,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                fundData.to.koulId == currentUser.id
                                    ? "+ ₹${numberFormatter(fundData.amount.toString())}"
                                    : "₹${numberFormatter(fundData.amount.toString())}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color:
                                          fundData.to.koulId == currentUser.id
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
    );
  }
}
