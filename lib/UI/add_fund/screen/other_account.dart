// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:koul_network/UI/add_fund/display_payees_info.dart';
// import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
// import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
// import 'package:koul_network/model/payees.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:lottie/lottie.dart';

// class OtherAccount extends StatefulWidget {
//   static const routeName = "otheraccount";
//   const OtherAccount({super.key});

//   @override
//   State<OtherAccount> createState() => _OtherAccountState();
// }

// class _OtherAccountState extends State<OtherAccount> {
//   final payeesFormKey = GlobalKey<FormState>();
//   // Payees payees = Payees(name: "", email: "", koulId: "");
//   String? payeeKoulId;
//   // Method to save the payees form
//   void onSavedPayeesForm() {
//     final isValid = payeesFormKey.currentState!.validate();
//     if (!isValid) {
//       return;
//     }
//     payeesFormKey.currentState!.save();
//     context
//         .read<StripeBloc>()
//         .add(PayeesDetailEvent(payeeKoulId: payeeKoulId!));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.sizeOf(context);

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         titleSpacing: 0,
//         title: Text(
//           "Enter Payee's Detail",
//           style: Theme.of(context).textTheme.titleMedium,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Form(
//           key: payeesFormKey,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 15),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 AnimatedContainer(
//                   duration: const Duration(milliseconds: 380),
//                   alignment: Alignment.center,
//                   curve: Curves.linear,
//                   height:
//                       MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 220,
//                   child: Lottie.asset(
//                     "assets/accountdetail.json",
//                     width: double.infinity,
//                     repeat: false,
//                   ),
//                 ),
//                 TextFormField(
//                   validator: (name) {
//                     if (name!.isEmpty) {
//                       return "Enter payee's name";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: Text("Name"),
//                     border: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.black,
//                       ),
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.white38,
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     errorBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.red,
//                       ),
//                     ),
//                     floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   textInputAction: TextInputAction.next,
//                   onSaved: (name) {
//                     payees.name = name!;
//                   },
//                 ),
//                 SizedBox(height: 28),
//                 TextFormField(
//                   validator: (koulId) {
//                     if (koulId!.isEmpty) {
//                       return "Enter payee's Koul Id";
//                     } else if (koulId.length < 24) {
//                       return "Invalid payee's Koul Id";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: Text("Koul ID"),
//                     border: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.black,
//                       ),
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.white38,
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     errorBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.red,
//                       ),
//                     ),
//                     floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   textInputAction: TextInputAction.next,
//                   maxLength: 24,
//                   buildCounter: (context,
//                       {required currentLength,
//                       required isFocused,
//                       required maxLength}) {
//                     return Text(
//                       '$currentLength/$maxLength',
//                       style: Theme.of(context).textTheme.bodySmall,
//                     );
//                   },
//                   onSaved: (koulId) {
//                     payees.koulId = koulId!;
//                   },
//                 ),
//                 TextFormField(
//                   validator: (email) {
//                     if (email!.isEmpty) {
//                       return "Enter payee's Email Id";
//                     } else if (!email.contains("@")) {
//                       return "Invalid payee's Email Id";
//                     }
//                     return null;
//                   },
//                   decoration: InputDecoration(
//                     label: Text("Email ID"),
//                     border: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.black,
//                       ),
//                     ),
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.white38,
//                       ),
//                     ),
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.white,
//                       ),
//                     ),
//                     errorBorder: UnderlineInputBorder(
//                       borderSide: const BorderSide(
//                         width: 2,
//                         color: Colors.red,
//                       ),
//                     ),
//                     floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
//                     labelStyle: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   textInputAction: TextInputAction.done,
//                   onSaved: (email) {
//                     payees.email = email!;
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       persistentFooterButtons: [
//         BlocConsumer<StripeBloc, StripeState>(
//           listener: (context, state) {
//             if (state is PayeesDetailState) {
//               Navigator.of(context)
//                   .pushNamed(DisplayPayeesInfo.routeName, arguments: state);
//             }
//             if (state is ErrorState) {
//               buildSnackBar(context, state.errorMessage);
//             }
//           },
//           builder: (BuildContext context, StripeState state) => TextButton.icon(
//             onPressed: state is LoadingState
//                 ? null
//                 : () {
//                     onSavedPayeesForm(payees);
//                   },
//             label: Text(
//               state is LoadingState ? 'Verifying...' : 'Verify',
//             ),
//             icon: state is LoadingState
//                 ? Center(
//                     child: LoadingIndicator(
//                       indicatorType: Indicator.pacman,
//                       colors: const [Colors.white],
//                       strokeWidth: 2,
//                       backgroundColor: Colors.blueGrey,
//                       pathBackgroundColor: Colors.grey.shade700,
//                     ),
//                   )
//                 : Icon(Icons.verified_user_outlined),
//             style: TextButton.styleFrom(
//               fixedSize: Size(
//                 screenSize.height * 1,
//                 screenSize.height * 0.071,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

//================================================================================

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/add_fund/display_payees_info.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';

class OtherAccount extends StatefulWidget {
  static const routeName = "otheraccount";
  const OtherAccount({super.key});

  @override
  State<OtherAccount> createState() => _OtherAccountState();
}

class _OtherAccountState extends State<OtherAccount> {
  final _koulIdController = TextEditingController();

  @override
  void dispose() {
    _koulIdController.dispose();
    super.dispose();
  }

  void _onVerify() {
    final koulId = _koulIdController.text.trim();
    if (koulId.isEmpty) {
      buildSnackBar(context, "Please enter the Payee's Koul ID");
      return;
    }
    if (koulId.length < 24) {
      buildSnackBar(context, "Koul ID must be 24 characters");
      return;
    }
    context.read<StripeBloc>().add(PayeesDetailEvent(payeeKoulId: koulId));
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Enter Payee's Koul ID",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 380),
              alignment: Alignment.center,
              curve: Curves.linear,
              height: MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 220,
              child: Lottie.asset(
                "assets/accountdetail.json",
                width: double.infinity,
                repeat: false,
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _koulIdController,
              maxLength: 24,
              decoration: InputDecoration(
                label: Text("KOUL ID"),
                border: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white38,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              buildCounter: (context,
                  {required currentLength,
                  required isFocused,
                  required maxLength}) {
                return Text(
                  '$currentLength/$maxLength',
                  style: Theme.of(context).textTheme.bodySmall,
                );
              },
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
          ],
        ),
      ),
      floatingActionButton: BlocConsumer<StripeBloc, StripeState>(
        listener: (context, state) {
          if (state is PayeesDetailState) {
            Navigator.of(context)
                .pushNamed(DisplayPayeesInfo.routeName, arguments: state);
          }
          if (state is ErrorState) {
            buildSnackBar(context, state.errorMessage);
          }
        },
        builder: (context, state) => Padding(
          padding: EdgeInsets.only(left: screenSize.width * 0.085),
          child: TextButton.icon(
            onPressed: state is LoadingState
                ? null
                : () {
                    _onVerify();
                  },
            label: Text(
              state is LoadingState ? 'Verifying...' : 'Verify',
            ),
            icon: state is LoadingState
                ? Center(
                    child: LoadingIndicator(
                      indicatorType: Indicator.pacman,
                      colors: const [Colors.white],
                      strokeWidth: 2,
                      backgroundColor: Colors.blueGrey,
                      pathBackgroundColor: Colors.grey.shade700,
                    ),
                  )
                : Icon(Icons.verified_user_outlined),
            style: TextButton.styleFrom(
              fixedSize: Size(
                screenSize.height * 1,
                screenSize.height * 0.071,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
