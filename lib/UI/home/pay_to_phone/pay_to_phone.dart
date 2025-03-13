import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/widgets/textfield.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/enums/route_path.dart';
import 'package:koul_network/core/enums/show_phone.dart';

class PayToPhone extends StatefulWidget {
  static const routeName = "PayToPhone";
  const PayToPhone({super.key});

  @override
  State<PayToPhone> createState() => _PayToPhoneState();
}

class _PayToPhoneState extends State<PayToPhone> {
  String phoneNo = "";

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Pay to Phone number",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          KoulTextField(
            autoFocus: true,
            prefixValue: "+91  ",
            maxLength: 10,
            keyBoardType: TextInputType.number,
            labelText: "Enter Phone number",
            onTextChanged: (phone) {
              setState(() {
                phoneNo = phone.trim();
              });
            },
          ),
          Expanded(
            child: BlocConsumer<KoulAccountBloc, KoulAccountState>(
              listener: (context, state) {
                if (state is KoulIdSuccessState) {
                  Navigator.of(context).pushNamed(
                      PreviousTransactionsScreen.routeName,
                      arguments: {
                        "showphone": ShowPhone.phoneVisible,
                        "route": RoutePath.payKoulId
                      });
                }
              },
              builder: (context, state) {
                if (state is FailureState) {
                  return Center(
                    child: Text(
                      state.error,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }
                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
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
          child: BlocBuilder<KoulAccountBloc, KoulAccountState>(
            builder: (context, state) {
              return ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor:
                      const Color.fromARGB(255, 61, 61, 61),
                  disabledForegroundColor: Colors.white,
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(
                    fontSize: screenSize.height * 0.023,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: phoneNo.length < 10 || state is LoadingState
                    ? null
                    : () {
                        FocusManager.instance.primaryFocus!.unfocus();
                        context
                            .read<KoulAccountBloc>()
                            .add(PayToPhoneNoEvent(phoneNo: phoneNo));
                      },
                icon: const Icon(Icons.verified_user_outlined),
                label: const Text("Verify"),
              );
            },
          ),
        ),
      ),
    );
  }
}
