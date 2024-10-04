import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koul_network/UI/auth/screens/onsignup_with_google.dart';
import 'package:koul_network/UI/auth/screens/secure_signup_auth.dart';
import 'package:koul_network/UI/auth/screens/signIn_email_or_oauth.dart';
import 'package:koul_network/UI/auth/screens/signup.dart';
import 'package:koul_network/UI/auth/widgets/google_button.dart';

class SignUpEmailOrOauth extends StatefulWidget {
  static const routeName = "SignUpEmailOrOauth";
  const SignUpEmailOrOauth({super.key});

  @override
  State<SignUpEmailOrOauth> createState() => _SignUpEmailOrOauthState();
}

class _SignUpEmailOrOauthState extends State<SignUpEmailOrOauth>
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
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.020),
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
                Text("Sign up for Koul Network",
                    style: Theme.of(context).textTheme.displayLarge),
                SizedBox(
                  height: screenSize.height * 0.04,
                ),
                googleButton(
                    context: context,
                    text: "Continue with Email  ",
                    icon: Icons.email,
                    func: () {
                      Navigator.of(context).pushNamed(SignUpScreen.routeName);
                    }),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                googleButton(
                    context: context,
                    text: "Continue with Google",
                    icon: FontAwesomeIcons.google,
                    func: () {
                      Navigator.of(context)
                          .pushNamed(OnSignUpWithGoogle.routeName);
                    }),
                SizedBox(
                  height: screenSize.height * 0.02,
                ),
                googleButton(
                    context: context,
                    text: "Continue with Secure Sign Up",
                    icon: (Icons.security),
                    func: () {
                      Navigator.of(context)
                          .pushNamed(SecureSignUpScreen.routeName);
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
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
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
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
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
                        text: "Already a member? ",
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
                        text: "Log In",
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
                                SignInEmailOrOauth.routeName);
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
    );
  }
}
