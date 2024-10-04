import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/auth/screens/verification_code_signup.dart';
import 'package:koul_network/UI/auth/widgets/secure_signup_textfield.dart';
import 'package:koul_network/UI/global_widget/build_dialogbox.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';

// ignore: must_be_immutable
class SecureSignUpScreen extends StatefulWidget {
  static const routeName = "SecureSignUpScreen";

  const SecureSignUpScreen({super.key});

  @override
  State<SecureSignUpScreen> createState() => _SecureSignUpScreenState();
}

class _SecureSignUpScreenState extends State<SecureSignUpScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(animationController);

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return PopScope(
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * 0.020),
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          duration: const Duration(milliseconds: 380),
                          curve: Curves.linear,
                          height: MediaQuery.of(context).viewInsets.bottom > 0
                              ? 0
                              : screenSize.height * 0.30,
                          child: Image.asset(
                            "assets/koul_signup_image.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
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
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            buildDialogBox(
                                context: context,
                                title: "Please note",
                                content: Text(
                                    "When signing up, provide your username and email—no password needed. A verification code will be sent to your email to complete the signup. For login, enter your register email and username, receive a verification code, and enter it to access your account. This method is more secure than traditional password-based accounts because there is no password to be stolen or hacked. If anyone wants access to your account, they would first need access to your email address, adding an extra layer of security.",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium),
                                clipboardtext: "");
                          },
                          icon: const Icon(
                            Icons.info,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.020),
                    child: Text(
                      "Let's create an account for you.",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFaliueState) {
                        buildSnackBar(context, state.error);
                      } else if (state is AuthSucessState) {
                        Navigator.of(context)
                            .pushNamed(VcodeSignupScreen.routeName, arguments: {
                          "userid": state.userId,
                          "sn": "securesignup"
                        });
                      }
                    },
                    child: const SizedBox(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.020),
                    child: buildTextFieldSecureSignUp(
                      context: context,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onPopInvoked: (didPop) {
        context.read<AuthBloc>().add(SetStateToAuthInitialEvent());
      },
    );
  }
}
