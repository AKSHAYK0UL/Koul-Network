import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/auth/screens/verification_code_signup.dart';
import 'package:koul_network/UI/home/more/widget/account_settig/reset_password_textfield.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';

// ignore: must_be_immutable
class ResetPasswordScreen extends StatefulWidget {
  static const routeName = "ResetPasswordScreen";
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(animationController);
    scaleAnimation =
        Tween<double>(begin: 10, end: 1).animate(animationController);

    animationController.forward();
  }

  bool passwordVisibilityValue = true;
  bool confirmPasswordVisibilityValue = true;

  bool passwordVisibility() {
    setState(() {
      passwordVisibilityValue = !passwordVisibilityValue;
    });
    return passwordVisibilityValue;
  }

  bool confirmPasswordVisibility() {
    setState(() {
      confirmPasswordVisibilityValue = !confirmPasswordVisibilityValue;
    });
    return confirmPasswordVisibilityValue;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
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
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.020),
                  child: Text(
                    "Reset Password",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.01,
                ),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFaliueState) {
                      // buildSnackBar(context, state.error);
                    } else if (state is AuthSucessState) {
                      Navigator.of(context).pushNamed(
                          VcodeSignupScreen.routeName,
                          arguments: {"userid": state.userId, "sn": "reset"});
                    }
                  },
                  child: const SizedBox(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.020),
                  child: buildResetpasswordTextField(
                      context: context,
                      password: passwordVisibility,
                      confirmPassword: confirmPasswordVisibility),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
