import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/processing_screen.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/widgets/amount_textfield.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/enums/show_phone.dart';
import 'package:koul_network/core/helpers/helper_functions/currentuser_koulaccount/getcurrentuser_koulaccount.dart';
import 'package:koul_network/core/helpers/helper_functions/phone_formatter.dart';
import 'package:koul_network/core/helpers/payment/handle_payment.dart';
import 'package:koul_network/main.dart';
import 'package:koul_network/core/singleton/currentuser.dart';
import 'package:koul_network/core/singleton/currentuser_account.dart';

class PayScreen extends StatefulWidget {
  static const routeName = "PayScreen";
  const PayScreen({super.key});
  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  final amountController = TextEditingController();
  final currentKoulAccount =
      CurrentuserKoulAccountSingleton.getCurrentUserKoulAccountInstance();

  @override
  void initState() {
    super.initState();
    getCurrentuserKoulAccountDatail(currentKoulAccount.koulId);
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(currentKoulAccount.accountCurrentBalance);
    final screenSize = MediaQuery.sizeOf(context);

    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final toKoulId = routeData['tokoulid'];
    final toName = routeData['toname'];
    final phone = routeData["phone"];
    final phoneNoVisibility = routeData["phonevisibility"] as ShowPhone;

    return PopScope(
      child: Scaffold(
        key: scaffoldKey,
        body: SafeArea(
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
                      backgroundColor: const Color.fromARGB(135, 15, 14, 14),
                      child: Text(
                        toName.toString().toUpperCase()[0],
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
                        "Paying ${toName!.replaceFirst(toName[0], toName[0].toUpperCase())}",
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
                        toKoulId!,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      height: screenSize.height * 0.0026,
                    ),
                    Text(
                      phoneNoVisibility == ShowPhone.phoneNotVisible
                          ? formatPhoneNumber(phone!)
                          : phone,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.visible,
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: screenSize.height * 0.01935,
                    ),
                    BlocListener<KoulAccountBloc, KoulAccountState>(
                      listener: (context, state) {
                        if (state is FailureState) {
                          buildSnackBar(context, state.error);
                        }
                        if (state is PayToKoulIdLoadingState) {
                          Navigator.of(context).pushReplacementNamed(
                            ProcessingScreen.routeName,
                            arguments: toKoulId,
                          );
                        }
                      },
                      child: buildAmounttextField(
                          context: context,
                          controller: amountController,
                          screenSize: screenSize),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
                double amount = amountController.text.isEmpty
                    ? 0.0
                    : double.parse(amountController.text.replaceAll(",", ""));

                handlePayment(
                    context: context,
                    toKoulId: toKoulId,
                    toName: toName,
                    amount: amount,
                    currentKoulAccount: currentKoulAccount);
              },
              icon: const Icon(Icons.forward),
              label: const Text("Proceed"),
            ),
          ),
        ),
      ),
      onPopInvoked: (_) {
        context
            .read<KoulAccountBloc>()
            .add(GetTransactionListEvent(koulId: toKoulId));
        final currentUserId = CurrentUserSingleton.getCurrentUserInstance().id;

        getCurrentuserKoulAccountDatail(currentUserId);
      },
    );
  }
}
