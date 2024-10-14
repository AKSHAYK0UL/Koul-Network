import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/helpers/helper_functions/currentuser_koulaccount/getcurrentuser_koulaccount.dart';
import 'package:koul_network/singleton/currentuser.dart';
import 'package:lottie/lottie.dart';

class UpdatingCreatingTransactionpin extends StatefulWidget {
  static const routeName = "UpdatingCreatingTransactionpin";
  const UpdatingCreatingTransactionpin({super.key});

  @override
  State<UpdatingCreatingTransactionpin> createState() =>
      _UpdatingCreatingTransactionpinState();
}

class _UpdatingCreatingTransactionpinState
    extends State<UpdatingCreatingTransactionpin> {
  @override
  Widget build(BuildContext context) {
    final toKoulId = ModalRoute.of(context)!.settings.arguments as String;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<KoulAccountBloc, KoulAccountState>(
            listener: (context, state) {
              if (state is TransactionPinUpdatedState) {
                if (toKoulId ==
                    CurrentUserSingleton.getCurrentUserInstance().id) {
                  Navigator.of(context).pop();
                } else {
                  context
                      .read<KoulAccountBloc>()
                      .add(GetTransactionListEvent(koulId: toKoulId));
                  final currentUserId =
                      CurrentUserSingleton.getCurrentUserInstance().id;

                  getCurrentuserKoulAccountDatail(currentUserId);
                  Navigator.of(context).popUntil(ModalRoute.withName(
                      PreviousTransactionsScreen.routeName));
                }
              }
            },
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale: 1.5,
                        child: Lottie.asset(
                          "assets/updatepassword.json",
                          repeat: false,
                        ),
                      ),
                      Text(
                        "Creating KOUL PIN...",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              }
              if (state is FailureState) {
                //
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
