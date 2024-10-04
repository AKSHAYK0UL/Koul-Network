import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koul_network/UI/auth/screens/secure_signin.dart';
import 'package:koul_network/UI/auth/screens/signin.dart';
import 'package:koul_network/UI/auth/screens/signup_email_or_oauth.dart';
import 'package:koul_network/UI/auth/widgets/google_button.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/enums/auth_type_enum.dart';

class SignInEmailOrOauth extends StatefulWidget {
  static const routeName = "SignInEmailOrOauth";
  const SignInEmailOrOauth({super.key});

  @override
  State<SignInEmailOrOauth> createState() => _SignInEmailOrOauthState();
}

class _SignInEmailOrOauthState extends State<SignInEmailOrOauth>
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

  void userAgreement() {
    debugPrint("userAgreement");
  }

  void privacyPolicy() {
    debugPrint("privacyPolicy");
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
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthGoogleLoginFaliueState) {
            buildSnackBar(context, "No account found");
          }
          if (state is AuthHomeState) {
            if (state.userId.isNotEmpty && state.authToken.isNotEmpty) {
              context.read<AuthBloc>().add(SaveUserInfoEvent(
                    userId: state.userId,
                    authToken: state.authToken,
                    authType: AuthType.googleAuth,
                  ));
              Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName,
                (route) => false,
              );
            }
          }
        },
        child: SafeArea(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Container(
              margin:
                  EdgeInsets.symmetric(horizontal: screenSize.width * 0.020),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: scaleAnimation,
                    child: Container(
                      alignment: Alignment.center,
                      height: screenSize.height * 0.33,
                      child: Image.asset(
                        "assets/koul_signup_image.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.01,
                  ),
                  Text("Log in to Koul Network",
                      style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(
                    height: screenSize.height * 0.04,
                  ),
                  googleButton(
                      context: context,
                      text: "Use Email & Password",
                      icon: Icons.email,
                      func: () {
                        Navigator.of(context).pushNamed(SignInScreen.routeName);
                      }),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  googleButton(
                      context: context,
                      text: "Continue with Google",
                      icon: FontAwesomeIcons.google,
                      func: () {
                        context.read<AuthBloc>().add(GoogleLoginAuthEvent());
                      }),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  googleButton(
                      context: context,
                      text: "Continue with Secure Sign In",
                      icon: (Icons.security),
                      func: () {
                        Navigator.of(context)
                            .pushNamed(SecureSignInScreen.routeName);
                      }),
                  const Spacer(),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: "By continuing, you agree to our ",
                            style: Theme.of(context).textTheme.labelSmall),
                        TextSpan(
                            text: "User Agreement",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Colors.white,
                                  decorationThickness: 1,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                userAgreement();
                              }),
                        TextSpan(
                          text: " and acknowledge that you understand the ",
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        TextSpan(
                            text: "Privacy Policy",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Colors.white,
                                  decorationThickness: 1,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                privacyPolicy();
                              }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.005,
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  SizedBox(
                    height: screenSize.height * 0.005,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        TextSpan(
                          onEnter: (_) {
                            debugPrint("Register Now");
                          },
                          text: "Register now",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.solid,
                            decorationColor: Colors.white,
                            decorationThickness: 1,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).pushReplacementNamed(
                                  SignUpEmailOrOauth.routeName);
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.016,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
