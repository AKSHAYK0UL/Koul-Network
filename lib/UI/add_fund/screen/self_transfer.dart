import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/add_fund/screen/fund_added_success.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/widgets/amount_textfield.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/main.dart';
import 'package:koul_network/singleton/currentuser.dart';

class SelfTransfer extends StatefulWidget {
  static const routeName = "SelfTransfer";
  const SelfTransfer({super.key});
  @override
  State<SelfTransfer> createState() => _SelfTransferState();
}

class _SelfTransferState extends State<SelfTransfer> {
  final amountController = TextEditingController();
  final currentUser = CurrentUserSingleton.getCurrentUserInstance();

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return PopScope(
      child: Scaffold(
        key: scaffoldKey,
        body: BlocConsumer<StripeBloc, StripeState>(
          listener: (context, state) {
            if (state is ErrorState) {
              buildSnackBar(context, state.errorMessage);
            }
            if (state is SuccessState) {
              context
                  .read<StripeBloc>()
                  .add(PaymentSheetEvent(clientId: state.clientId));
            }
            if (state is TransactionDoneState) {
              Navigator.of(context).pushReplacementNamed(
                  FundAddedSuccess.routeName,
                  arguments: state);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SafeArea(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: screenSize.height * 0.0064,
                          top: screenSize.height * 0.0064),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: screenSize.height * 0.0128,
                          vertical: screenSize.height * 0.0064),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: screenSize.height * 0.0387,
                            backgroundColor:
                                const Color.fromARGB(135, 15, 14, 14),
                            child: Text(
                              currentUser.name.toString().toUpperCase()[0],
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.01935,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Adding Funds To ${currentUser.name.replaceFirst(currentUser.name[0], currentUser.name[0].toUpperCase())}",
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.0026,
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              currentUser.id,
                              style: Theme.of(context).textTheme.bodySmall,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                            height: screenSize.height * 0.0026,
                          ),
                          SizedBox(
                            height: screenSize.height * 0.01935,
                          ),
                          buildAmounttextField(
                              context: context,
                              controller: amountController,
                              screenSize: screenSize),
                        ],
                      ),
                    ),
                  ]),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.height * 0.013,
            vertical: screenSize.height * 0.010,
          ),
          child: SizedBox(
            width: double.infinity,
            height: screenSize.height * 0.071,
            child: ElevatedButton.icon(
              onPressed: () async {
                context.read<StripeBloc>().add(AddFundEvent(
                    amount:
                        (double.parse(amountController.text) * 100).toInt()));
              },
              icon: const Icon(Icons.forward),
              label: const Text("Proceed"),
            ),
          ),
        ),
      ),
    );
  }
}
