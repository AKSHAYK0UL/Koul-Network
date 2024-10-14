import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/transaction_failed.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/tranaction_done.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:lottie/lottie.dart';

class ProcessingScreen extends StatefulWidget {
  static const routeName = "ProcessingScreen";
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final toKoulId = ModalRoute.of(context)!.settings.arguments as String;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocListener<KoulAccountBloc, KoulAccountState>(
          listener: (context, state) {
            if (state is FailureState) {
              print("Transaction Failed");
              if (state.error == "invalid phone number") {
                Navigator.of(context).pushReplacementNamed(
                  TransactionFailedScreen.routeName,
                  arguments: {
                    "tokoulid": toKoulId,
                    "route": "invalidphoneno",
                  },
                );
              } else {
                Navigator.of(context).pushReplacementNamed(
                  TransactionFailedScreen.routeName,
                  arguments: {
                    "tokoulid": toKoulId,
                    "route": "transactionfailed",
                  },
                );
              }
            }

            if (state is IncorrectTransactionPinState) {
              Navigator.of(context).pushReplacementNamed(
                TransactionFailedScreen.routeName,
                arguments: {
                  "tokoulid": toKoulId,
                  "route": "incorrectpin",
                },
              );
            }
            if (state is TranactionSuccessfullState) {
              print("Transaction Done");
              Navigator.of(context).pushReplacementNamed(
                TranactionDoneScreen.routeName,
                arguments: toKoulId,
              );
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  "assets/processing.json",
                ),
                Text(
                  "Processing please wait...",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: screenSize.height * 0.029,
                      ),
                )
              ],
            ),
          ),
        ),
      ),
      // onWillPop: () async => false,
    );
  }
}
