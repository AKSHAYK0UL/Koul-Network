import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/helpers/auth_bio_pin.dart';
import 'package:koul_network/helpers/helper_functions/currentuser_koulaccount/getcurrentuser_koulaccount.dart';
import 'package:koul_network/singleton/currentuser.dart';
import 'package:lottie/lottie.dart';

class TransactionFailedScreen extends StatelessWidget {
  static const routeName = "TransactionFailed";
  const TransactionFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final toKoulId = routeData['tokoulid'];
    final route = routeData['route'];

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: screenSize.height * 0.005,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    context
                        .read<KoulAccountBloc>()
                        .add(GetTransactionListEvent(koulId: toKoulId!));
                    final currentUserId =
                        CurrentUserSingleton.getCurrentUserInstance().id;

                    getCurrentuserKoulAccountDatail(currentUserId);
                    Navigator.of(context).popUntil(ModalRoute.withName(
                        PreviousTransactionsScreen.routeName));
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.236,
              ),
              Center(
                child: Lottie.asset(
                  "assets/failed.json",
                  repeat: false,
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.0458,
              ),
              Text(
                "Transaction failed\n${route == "incorrectpin" ? "Incorrect Pin" : "Invalid Phone number"}",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: screenSize.height * 0.029,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.height * 0.0135),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: screenSize.height * 0.080,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    label: FittedBox(
                      fit: BoxFit.fill,
                      child: Text(
                        "Retry",
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    icon: const Icon(Icons.settings_backup_restore),
                  ),
                ),
              ),
              if (route == "incorrectpin")
                SizedBox(
                  width: screenSize.height * 0.027,
                ),
              if (route == "incorrectpin")
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: screenSize.height * 0.080,
                    child: TextButton.icon(
                      onPressed: () {
                        authenticateWithBiometrics(
                            context: context, toKoulId: toKoulId!);
                      },
                      label: FittedBox(
                        fit: BoxFit.fill,
                        child: Text(
                          "Reset Pin",
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      icon: const Icon(Icons.lock_outline),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      // onWillPop: () async => false,
    );
  }
}
