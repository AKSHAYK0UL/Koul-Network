import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/cross%20screen/widget/transaction_detail.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/helpers/helper_functions/currentuser_koulaccount/getcurrentuser_koulaccount.dart';
import 'package:koul_network/core/helpers/helper_functions/number_formatter.dart';
import 'package:koul_network/core/singleton/currentuser.dart';
import 'package:lottie/lottie.dart';

class TranactionDoneScreen extends StatefulWidget {
  static const routeName = "TranactionDoneScreen";
  const TranactionDoneScreen({super.key});

  @override
  State<TranactionDoneScreen> createState() => _TranactionDoneScreenState();
}

class _TranactionDoneScreenState extends State<TranactionDoneScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _slideAnimationController;
  late Animation<Offset> _slideTransition;
  late Animation<double> _fadeTransition;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200));
    _slideAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _fadeTransition = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideTransition =
        Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0.05))
            .animate(CurvedAnimation(
                parent: _slideAnimationController, curve: Curves.easeInOut));

    _animationController.forward();
    _animationController.addListener(() {
      if (_animationController.isCompleted) {
        _slideAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final toKoulId = ModalRoute.of(context)!.settings.arguments as String;

    final currentstate =
        context.read<KoulAccountBloc>().state as TranactionSuccessfullState;
    final screenSize = MediaQuery.sizeOf(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _slideTransition,
                    child: Column(
                      children: [
                        Center(
                          child: Lottie.asset(
                            "assets/transactionDone.json",
                            width: screenSize.height * 0.185,
                            height: screenSize.height * 0.210,
                            repeat: false,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.0458,
                        ),
                        FadeTransition(
                          opacity: _fadeTransition,
                          child: Column(
                            children: [
                              Text(
                                "Transaction done successfully",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(
                                height: screenSize.height * 0.0264,
                              ),
                              Text(
                                "₹${numberFormatter(currentstate.transactionDoneData.amount.toString())}",
                                style: TextStyle(
                                  fontSize: screenSize.height * 0.0558,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SlideTransition(
                    position: _slideTransition,
                    child: buildTransactionDetailBox(
                      context: context,
                      transactionData: currentstate.transactionDoneData,
                      rightButtonText: "Done",
                      rightButtonFun: () {
                        context
                            .read<KoulAccountBloc>()
                            .add(GetTransactionListEvent(koulId: toKoulId));
                        final currentUserId =
                            CurrentUserSingleton.getCurrentUserInstance().id;

                        getCurrentuserKoulAccountDatail(currentUserId);
                        Navigator.of(context).popUntil(ModalRoute.withName(
                            PreviousTransactionsScreen.routeName));
                      },
                      rightButtonIcon: Icons.done,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // onWillPop: () async => false,
    );
  }
}
