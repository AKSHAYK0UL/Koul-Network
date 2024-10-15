import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/updating_creating_transactionpin.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';

class SetupTransactionPin extends StatefulWidget {
  static const routeName = "SetupTransactionPin";

  const SetupTransactionPin({super.key});

  @override
  State<SetupTransactionPin> createState() => _SetupTransactionPinState();
}

class _SetupTransactionPinState extends State<SetupTransactionPin> {
  String inputnum = "";
  bool valid = true;
  Widget keyPad(String num, Size screenSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.grey.shade800,
        shadowColor: Colors.black,
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          child: InkWell(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.white54),
                ),
              ),
              onPressed: num == "x"
                  ? () {
                      setState(
                        () {
                          valid = true;
                          if (inputnum.isNotEmpty) {
                            inputnum =
                                inputnum.substring(0, inputnum.length - 1);
                          }
                        },
                      );
                    }
                  : num == "y"
                      ? () {
                          setState(
                            () {
                              if (inputnum.length == 5) {
                                context.read<KoulAccountBloc>().add(
                                    CreateTransactionPinEvent(
                                        context: context,
                                        transactionPin: inputnum));
                              } else {
                                valid = false;
                              }
                            },
                          );
                        }
                      : () {
                          setState(() {
                            valid = true;
                            if (inputnum.length <= 4) {
                              inputnum = inputnum + num;
                            }
                          });
                        },
              child: num == "x"
                  ? Icon(
                      Icons.backspace,
                      color: Colors.red.shade400,
                      size: screenSize.height * 0.033,
                    )
                  : num == "y"
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: screenSize.height * 0.033,
                        )
                      : Text(
                          num,
                          style: TextStyle(
                            fontSize: screenSize.height * 0.031,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }

// build Passcode TextField
  Widget buildPinCode(String pinCode, Size screenSize) {
    return Container(
      height: screenSize.height * 0.063,
      width: screenSize.height * 0.063,
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          pinCode,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.height * 0.031,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  bool _isVisible = false;
  Widget buildPasswordVisibility(Size screenSize) {
    return Container(
      height: screenSize.height * 0.063,
      width: screenSize.height * 0.063,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
          child: IconButton(
        color: Colors.black,
        style: IconButton.styleFrom(
          backgroundColor: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          setState(
            () {
              _isVisible = !_isVisible;
            },
          );
        },
        icon: Icon(
          _isVisible ? Icons.visibility : Icons.visibility_off,
          size: screenSize.height * 0.035,
        ),
      )),
    );
  }

//Keypad Numbers
  List<String> numbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "x",
    "0",
    "y"
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final toKoulId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: BlocConsumer<KoulAccountBloc, KoulAccountState>(
          listener: (context, state) {
            if (state is LoadingState) {
              Navigator.of(context).pushReplacementNamed(
                UpdatingCreatingTransactionpin.routeName,
                arguments: toKoulId,
              );
            }
          },
          builder: (context, state) {
            if (state is FailureState) {
              return Center(
                  child: Text(
                state.error,
                style: Theme.of(context).textTheme.titleMedium,
              ));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                ),
                SizedBox(
                  height: screenSize.height * 0.010,
                ),
                Text(
                  "Setup your 5-digit Koul PIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.height * 0.029,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.100,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    buildPinCode(
                        inputnum.isNotEmpty && _isVisible
                            ? inputnum[0]
                            : inputnum.isNotEmpty && !_isVisible
                                ? "•"
                                : "",
                        screenSize),
                    buildPinCode(
                        inputnum.length >= 2 && _isVisible
                            ? inputnum[1]
                            : inputnum.length >= 2 && !_isVisible
                                ? "•"
                                : "",
                        screenSize),
                    buildPinCode(
                        inputnum.length >= 3 && _isVisible
                            ? inputnum[2]
                            : inputnum.length >= 3 && !_isVisible
                                ? "•"
                                : "",
                        screenSize),
                    buildPinCode(
                        inputnum.length >= 4 && _isVisible
                            ? inputnum[3]
                            : inputnum.length >= 4 && !_isVisible
                                ? "•"
                                : "",
                        screenSize),
                    buildPinCode(
                        inputnum.length >= 5 && _isVisible
                            ? inputnum[4]
                            : inputnum.length >= 5 && !_isVisible
                                ? "•"
                                : "",
                        screenSize),
                    buildPasswordVisibility(screenSize),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.050,
                ),
                valid
                    ? SizedBox(
                        height: screenSize.height * 0.04088,
                      )
                    : Text(
                        "Create 5 digit PIN",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.orange),
                      ),
                SizedBox(
                  height: screenSize.height * 0.100,
                ),
                Wrap(
                  children: [
                    ...numbers.map(
                      (keynum) => SizedBox(
                        width: screenSize.width / 3,
                        height: screenSize.height * 0.11,
                        child: SizedBox(child: keyPad(keynum, screenSize)),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
