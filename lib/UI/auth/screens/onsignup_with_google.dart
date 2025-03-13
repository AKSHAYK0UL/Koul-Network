import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/core/enums/auth_type_enum.dart';
import 'package:koul_network/core/helpers/helper_functions/show_model_sheet.dart';
import 'package:koul_network/core/helpers/helper_functions/sim_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simnumber/siminfo.dart';

class OnSignUpWithGoogle extends StatefulWidget {
  static const routeName = "OnSignUpWithGoogle";
  const OnSignUpWithGoogle({super.key});

  @override
  State<OnSignUpWithGoogle> createState() => _OnSignUpWithGoogleState();
}

class _OnSignUpWithGoogleState extends State<OnSignUpWithGoogle>
    with SingleTickerProviderStateMixin {
  void privacyPolicy() {
    debugPrint("privacyPolicy");
  }

  void userAgreement() {
    debugPrint("userAgreement");
  }

  void gqueries() {
    debugPrint("Gqueries@koulnetwork");
  }

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
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Text(
          "User Confirmation",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              children: [
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFaliueState) {
                      buildSnackBar(context, state.error);
                    }
                    if (state is AuthHomeState) {
                      if (state.userId.isNotEmpty &&
                          state.authToken.isNotEmpty) {
                        context.read<AuthBloc>().add(SaveUserInfoEvent(
                            userId: state.userId,
                            authToken: state.authToken,
                            authType: AuthType.googleAuth));
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName, (route) => false);
                      }
                    }
                  },
                  child: const SizedBox(),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Important Notice Regarding UserName and User Email Updates\n\n",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextSpan(
                        text: "Dear User,\n\n",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextSpan(
                        text:
                            "Thank you for considering signing up with Google authentication. Before you proceed, we want to ensure complete transparency regarding our username and user email policy.",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                      TextSpan(
                        text:
                            "Upon signing up using your Google account, your username and user email will be automatically generated based on the information provided by Google. Please be aware that both your username and user email will be permanently tied to your Google account and cannot be altered within our system.",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                      TextSpan(
                        text:
                            "It's paramount to acknowledge that by proceeding with Google authentication, you are consenting to the permanent association of your username and user email with your Google account.\n\n",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                      TextSpan(
                        text:
                            "Furthermore, your participation signifies your agreement to adhere to our ",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                      TextSpan(
                          text: "user agreement",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Colors.white,
                                  decorationThickness: 1.5,
                                  fontWeight: FontWeight.w900),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              userAgreement();
                            }),
                      TextSpan(
                          text: " and ",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    fontSize: screenSize.height * 0.018,
                                  )),
                      TextSpan(
                          text: "privacy policy",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Colors.white,
                                  decorationThickness: 1.5,
                                  fontWeight: FontWeight.w900),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              privacyPolicy();
                            }),
                      TextSpan(
                        text:
                            ". We take your privacy seriously and are committed to safeguarding your information in accordance with industry standards and legal requirements.\n\n",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                      TextSpan(
                        text:
                            "If you have any inquiries or require clarification regarding this policy, please feel free to contact our support team at ",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                      TextSpan(
                          text: "Gqueries@koulnetwork.uk.\n\n",
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                  decoration: TextDecoration.underline,
                                  decorationStyle: TextDecorationStyle.solid,
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                  decorationThickness: 1.5,
                                  fontWeight: FontWeight.w900),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              gqueries();
                            }),
                      TextSpan(
                        text: "Thank you for your attention to this matter.",
                        style:
                            Theme.of(context).textTheme.labelMedium!.copyWith(
                                  fontSize: screenSize.height * 0.018,
                                ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenSize.width * 0.0654,
                      bottom: screenSize.width * 0.01307),
                  child: SizedBox(
                    height: screenSize.height * 0.071,
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        PermissionStatus phone = await Permission.phone.status;
                        if (!context.mounted) return;
                        if (phone.isPermanentlyDenied) {
                          List<SimCard> siminfo = [];
                          buildGoogleSignUpBottomSheet(context, siminfo);
                          return;
                        }
                        getSimCardsData(context).then((siminfo) {
                          buildGoogleSignUpBottomSheet(context, siminfo);
                        });
                      },
                      style: ElevatedButton.styleFrom(),
                      icon: Icon(
                        Icons.done,
                        size: screenSize.height * 0.035,
                      ),
                      label: Text(
                        "I agree",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
