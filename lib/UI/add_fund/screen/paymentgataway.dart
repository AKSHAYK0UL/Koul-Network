import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/add_fund/screen/fund_added_success.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/model/koul_account/from_to.dart';
import 'package:lottie/lottie.dart';

class Paymentgataway extends StatelessWidget {
  static const routeName = "Paymentgataway";
  const Paymentgataway({super.key});

  @override
  Widget build(BuildContext context) {
    final routeData = ModalRoute.of(context)?.settings.arguments as FromTo;

    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<StripeBloc, StripeState>(
          listener: (context, state) {
            if (state is ErrorState) {
              buildSnackBar(context, state.errorMessage);
            }
            if (state is SuccessState) {
              context.read<StripeBloc>().add(PaymentSheetEvent(
                    toName: routeData.name,
                    toKoulId: routeData.koulId,
                    clientId: state.clientId,
                  ));
            }
            if (state is TransactionDoneState) {
              Navigator.of(context)
                  .pushReplacementNamed(FundAddedSuccess.routeName, arguments: {
                "toname": routeData.name,
                "tokoulid": routeData.koulId,
                "state": state,
              });
            }
            if (state is StripeInitial) {
              Navigator.of(context)
                  .pop(); //when payment sheet is closed by the user
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset("assets/paymentgataway.json"),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.0655,
                  ),
                  Text(
                    "Processing please wait...",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
