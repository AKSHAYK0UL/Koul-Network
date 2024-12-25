import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/cross%20screen/widget/transaction_detail.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/model/koul_account/from_to.dart';
import 'package:koul_network/model/koul_account/transaction.dart';
import 'package:koul_network/singleton/currentuser.dart';
import 'package:lottie/lottie.dart';

class FundAddedSuccess extends StatefulWidget {
  static const routeName = "FundAddedSuccess";
  const FundAddedSuccess({super.key});

  @override
  State<FundAddedSuccess> createState() => _FundAddedSuccessState();
}

class _FundAddedSuccessState extends State<FundAddedSuccess>
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

  final currentUser = CurrentUserSingleton.getCurrentUserInstance();
  @override
  Widget build(BuildContext context) {
    final txnData =
        ModalRoute.of(context)!.settings.arguments as TransactionDoneState;

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
                                "Fund added successfully",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              SizedBox(
                                height: screenSize.height * 0.0264,
                              ),
                              Text(
                                "₹${txnData.amount}0",
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
                      transactionData: Transaction(
                          amount: txnData.amount,
                          to: FromTo(
                              name: currentUser.name, koulId: currentUser.id),
                          from: FromTo(
                              name: currentUser.name, koulId: currentUser.id),
                          date: DateTime.now(),
                          transactionStatus: true,
                          transactionType: "fund",
                          transactionId: txnData.txnId),
                      rightButtonText: "Done",
                      rightButtonFun: () {
                        context
                            .read<KoulAccountBloc>()
                            .add(AccountBalanceEvent());
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
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
    );
  }
}
