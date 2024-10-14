import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/enums/app_pin_settting.dart';
import 'package:koul_network/helpers/helper_functions/logout/logout_func.dart';
import 'package:koul_network/singleton/currentuser.dart';
import 'package:lottie/lottie.dart';

class Loading extends StatefulWidget {
  static const routeName = "loading";
  const Loading({super.key});
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final routeData =
        ModalRoute.of(context)!.settings.arguments as AppPINSettingRoute;
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ForgotAppPINSuccessState) {
                //on Forgot PIN
                // logOut(context);

                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    // Start the countdown as soon as the dialog is shown
                    Timer.periodic(const Duration(seconds: 3), (_) {
                      // Navigator.of(context, rootNavigator: true).pop();
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
              if (state is AppPINCreationFailedState) {
                //on fail state
                Timer.periodic(
                  const Duration(milliseconds: 5000),
                  (_) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      HomeScreen.routeName,
                      (Route<dynamic> route) => false,
                    );
                  },
                );
              }
              if (state is AppPINCreatedState) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName,
                  (Route<dynamic> route) => false,
                );
                CurrentUserSingleton
                    .clearCurrentUserInstance(); //clear the previous singleton instance data
              }
            },
            builder: (context, state) {
              if (state is EnterPINLoadingState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Transform.scale(
                        scale:
                            routeData == AppPINSettingRoute.delete ? 3.0 : 1.5,
                        child: Lottie.asset(
                          routeData == AppPINSettingRoute.delete
                              ? "assets/delete.json"
                              : "assets/updatepassword.json",
                          repeat: false,
                        ),
                      ),
                      if (routeData == AppPINSettingRoute.delete)
                        SizedBox(
                          height: screenSize.height * 0.200,
                        ),
                      Text(
                        routeData == AppPINSettingRoute.create
                            ? "Creating App PIN..."
                            : routeData == AppPINSettingRoute.update ||
                                    routeData == AppPINSettingRoute.forgot
                                ? "Updating App PIN..."
                                : "Deleting App PIN...",
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    ],
                  ),
                );
              }
              if (state is AppPINCreationFailedState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        "assets/failed.json",
                        repeat: false,
                      ),
                      SizedBox(
                        height: screenSize.height * 0.100,
                      ),
                      Text(
                        routeData == AppPINSettingRoute.create
                            ? "Error in Creating App PIN..."
                            : routeData == AppPINSettingRoute.update ||
                                    routeData == AppPINSettingRoute.forgot
                                ? "Error in Updating App PIN..."
                                : "Error in Deleting App PIN...",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.red.shade800,
                            ),
                      )
                    ],
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
