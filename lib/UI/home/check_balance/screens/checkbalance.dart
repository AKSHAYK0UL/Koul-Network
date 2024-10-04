import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/check_balance/widgets/account_lowbalance_alert.dart';
import 'package:koul_network/UI/home/check_balance/widgets/alert_on_highamount.dart';
import 'package:koul_network/UI/home/check_balance/widgets/balance_card.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/singleton/currentuser.dart';

class CheckbalanceScreen extends StatefulWidget {
  static const routeName = "CheckbalanceScreen";

  const CheckbalanceScreen({super.key});

  @override
  State<CheckbalanceScreen> createState() => _CheckbalanceScreenState();
}

class _CheckbalanceScreenState extends State<CheckbalanceScreen> {
  @override
  void initState() {
    context.read<KoulAccountBloc>().add(AccountBalanceEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentState = context.read<KoulAccountBloc>().state;
    print("Check balance $currentState");
    final screenSize = MediaQuery.sizeOf(context);
    final currentuser = CurrentUserSingleton.getCurrentUserInstance();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(135, 15, 14, 14),
            child: Text(
              currentuser.name.toString().toUpperCase()[0],
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              "${currentuser.name.toString().replaceFirst(currentuser.name[0], currentuser.name[0].toUpperCase())}  ",
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
          subtitle: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              "${currentuser.id.toString()}  ",
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.visible,
              maxLines: 1,
            ),
          ),
        ),
      ),
      body: BlocConsumer<KoulAccountBloc, KoulAccountState>(
        listener: (context, state) {
          if (state is UpdateTrackerState) {
            buildSnackBar(context, "Tracker Updated");
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (state is FailureState) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is AccountBalanceState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  buildBalanceCard(context, state.accountBalance),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.035,
                      vertical: screenSize.width * 0.0125,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Account setting",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                  LowBalanceAlert(
                    account: state.accountBalance,
                  ),
                  AlertOnHighAmount(
                    account: state.accountBalance,
                  )
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
