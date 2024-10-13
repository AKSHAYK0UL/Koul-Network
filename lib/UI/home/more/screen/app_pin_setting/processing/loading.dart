import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
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
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AppPINCreatedState) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName,
                (Route<dynamic> route) => false,
              );
            }
          },
          builder: (context, state) {
            if (state is EnterPINLoadingState) {
              return Center(
                child: Lottie.asset("assets/updatepassword.json"),
              );
            }
            if (state is AppPINCreationFailedState) {
              return Center(
                child: Lottie.asset("assets/failed.json"),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
