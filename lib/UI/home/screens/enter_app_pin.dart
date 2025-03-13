import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/more/screen/AppPinkeypad.dart';
import 'package:koul_network/UI/home/more/screen/more_tab.dart';
import 'package:koul_network/UI/home/screens/navbar_screen.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/core/enums/enter_pin_options.dart';
import 'package:koul_network/core/helpers/auth_bio_pin.dart';
import 'package:koul_network/core/singleton/currentuser.dart';

class EnterAppPIN extends StatefulWidget {
  const EnterAppPIN({super.key});

  @override
  State<EnterAppPIN> createState() => _EnterAppPINState();
}

class _EnterAppPINState extends State<EnterAppPIN> {
  String inputnum = "";
  bool valid = true;
  Widget keyPad({
    required String num,
    required Size screenSize,
  }) {
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
                              if (inputnum.length == 4) {
                                //verify PIN
                                context
                                    .read<AuthBloc>()
                                    .add(EnterAppPINEvent(appPIN: inputnum));
                              }
                              if (inputnum.length < 4) {
                                valid = false;
                              }
                            },
                          );
                        }
                      : () {
                          setState(() {
                            if (inputnum.length <= 3) {
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

  //show Vcode title

  @override
  Widget build(BuildContext context) {
    final currentuser = CurrentUserSingleton.getCurrentUserInstance();
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                color: Theme.of(context).canvasColor,
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.white,
                  size: 30,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: EnterAppPINOptions.forgotPIN,
                    child: Text(
                      "Forgot PIN?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  PopupMenuItem(
                    value: EnterAppPINOptions.logOut,
                    child: Text(
                      "Sign Out?",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
                onSelected: (EnterAppPINOptions opValue) {
                  if (opValue == EnterAppPINOptions.forgotPIN) {
                    authenticateWithBiometrics(
                        context: context,
                        toKoulId: currentuser.id,
                        route: AppPINKeypad.routeName);
                  } else {
                    showDialogOnLogOut(context);
                  }
                },
              ),
            ),
            Text(
              "Enter App PIN",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.height * 0.029,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.010,
            ),
            Text(
              currentuser.email,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            SizedBox(
              height: screenSize.height * 0.080,
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
                buildPasswordVisibility(screenSize),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.065,
            ),
            SizedBox(
              height: screenSize.height * 0.05,
              child: BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is UserInfoState) {
                    return const NavbarScreen();
                  }
                  if (state is EnterPINLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    );
                  }

                  if (!valid) {
                    return Text(
                      "Enter a 4-digit PIN",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: screenSize.height * 0.027,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  if (state is VerifyAppPINFailureState) {
                    return Text(
                      "Incorrect PIN",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: screenSize.height * 0.027,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.105,
            ),
            Wrap(
              children: [
                ...numbers.map(
                  (keynum) => SizedBox(
                    width: screenSize.width / 3,
                    height: screenSize.height * 0.11,
                    child: SizedBox(
                        child: keyPad(
                      num: keynum,
                      screenSize: screenSize,
                    )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
