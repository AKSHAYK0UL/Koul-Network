import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/auth/widgets/signin_textfield.dart';
import 'package:koul_network/UI/global_widget/open_setting_dialogbox.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/core/enums/auth_type_enum.dart';

// ignore: must_be_immutable
class SignInScreen extends StatefulWidget {
  static const routeName = "SignInScreen";
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
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

  bool passwordVisibilityValue = true;
  bool confirmPasswordVisibilityValue = true;

  bool passwordVisibility() {
    setState(() {
      passwordVisibilityValue = !passwordVisibilityValue;
    });
    return passwordVisibilityValue;
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.020),
                    child: Text(
                      "Welcome Back!",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthFaliueState &&
                          state.error.contains("permanently denied")) {
                        buildOpenSettingDialogBox(
                            context: context,
                            title: "Location Permission",
                            content:
                                "Location permission is permanently denied. Please open settings to enable location access.");
                      }
                      if (state is AuthHomeState) {
                        if (state.userId.isNotEmpty &&
                            state.authToken.isNotEmpty) {
                          context.read<AuthBloc>().add(
                                SaveUserInfoEvent(
                                    userId: state.userId,
                                    authToken: state.authToken,
                                    authType: AuthType.emailAuth),
                              );
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              HomeScreen.routeName, ((route) => false));
                        }
                      }
                      if (state is AuthFaliueState &&
                          state.error != "permanently denied") {
                        buildSnackBar(context, state.error);
                      }
                    },
                    child: const SizedBox(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.020),
                    child: buildTextFieldSignIn(
                      context: context,
                      password: passwordVisibility,
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
