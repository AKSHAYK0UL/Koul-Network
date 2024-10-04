import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/auth/widgets/counterTimer.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/enums/auth_type_enum.dart';
import 'package:koul_network/helpers/helper_functions/logout/logout_func.dart';
import 'package:koul_network/singleton/currentuser.dart';

class VcodeSignupScreen extends StatefulWidget {
  static const routeName = "VcodeSignupScreen";
  const VcodeSignupScreen({super.key});

  @override
  State<VcodeSignupScreen> createState() => _VcodeSignupScreenState();
}

class _VcodeSignupScreenState extends State<VcodeSignupScreen> {
  String inputnum = "";
  bool valid = true;
  Widget keyPad(
      String num, Size screenSize, String userId, String routeScreen) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthHomeState) {}
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
          child: Material(
            clipBehavior: Clip.hardEdge,
            color: Colors.grey.shade800,
            shadowColor: Colors.black,
            elevation: 0.5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                                    if (routeScreen == "signup") {
                                      context.read<AuthBloc>().add(
                                            SignUpverifyEvent(
                                              userId: userId,
                                              vcode: inputnum,
                                            ),
                                          );
                                    } else if (routeScreen == "securesignup") {
                                      context.read<AuthBloc>().add(
                                            SecureSignUpverifyEvent(
                                              userId: userId,
                                              vcode: inputnum,
                                            ),
                                          );
                                    } else if (routeScreen == "securesignin") {
                                      context.read<AuthBloc>().add(
                                          SecureSignInverifyEvent(
                                              userId: userId, vcode: inputnum));
                                    } else {
                                      context.read<AuthBloc>().add(
                                            ForgotVerifyEvent(
                                              userId: userId,
                                              vcode: inputnum,
                                            ),
                                          );
                                    }
                                  }
                                  if (inputnum.length < 5) {
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
      },
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
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final userid = routeData["userid"];
    final routeScreen =
        routeData["sn"]; //from which screen the (signup or reset)

    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Column(
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
              "Enter 5 digit verification code",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.height * 0.029,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: screenSize.height * 0.100, //125
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
              height: screenSize.height * 0.035,
            ),
            const CounterTimer(),
            SizedBox(
              height: screenSize.height * 0.028,
            ),
            SizedBox(
                height: screenSize.height * 0.05,
                // height: 40,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthHomeState) {
                      print("USER ID :${state.userId}");
                      print("Token  :${state.authToken}");
                      print("before THE IF");

                      if (CurrentUserSingleton.getCurrentUserInstance()
                          .id
                          .isEmpty) {
                        print("INSIDE THE IF");
                        context.read<AuthBloc>().add(
                              SaveUserInfoEvent(
                                  userId: state.userId,
                                  authToken: state.authToken,
                                  authType: AuthType.emailAuth),
                            );
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName, ((route) => false));
                      } else {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            // Start the countdown as soon as the dialog is shown
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.of(context, rootNavigator: true).pop();
                              logOut(context);
                            });

                            return AlertDialog(
                              backgroundColor: Theme.of(context).canvasColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              content: Text(
                                "You will be logged out in 3 seconds",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          },
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      );
                    }
                    if (state is AuthInvalidVcodeState || !valid) {
                      return Text(
                        "Invalid verification code",
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: screenSize.height * 0.027,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }

                    return Container();
                  },
                )),
            SizedBox(
              height: screenSize.height * 0.055,
            ),
            Wrap(
              children: [
                ...numbers.map(
                  (keynum) => SizedBox(
                    width: screenSize.width / 3,
                    height: screenSize.height * 0.11,
                    child: SizedBox(
                        child:
                            keyPad(keynum, screenSize, userid!, routeScreen!)),
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
