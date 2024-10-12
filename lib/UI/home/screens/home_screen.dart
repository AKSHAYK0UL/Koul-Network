import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koul_network/UI/auth/screens/signIn_email_or_oauth.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/screens/enter_app_pin.dart';
import 'package:koul_network/UI/home/screens/navbar_screen.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final uid = Hive.box("auth").get("uid");
    final token = Hive.box("auth").get("token");

    print("UID :$uid");

    print("Token : $token");

    // context
    //     .read<AuthBloc>()
    //     .add(FetchUserInfoFromUserIdEvent(userid: uid, token: token));
    context
        .read<AuthBloc>()
        .add(GetAppPINStatusEvent(userid: uid, token: token));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocConsumer<AuthBloc, AuthState>(
        buildWhen: (previous, current) => previous != current,
        listener: (context, state) {
          if (state is AuthInitial || Hive.box("auth").isEmpty) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                SignInEmailOrOauth.routeName, (route) => false);
          }
          if (state is AuthFaliueState) {
            buildSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }
          if (state is UserInfoState) {
            return const NavbarScreen();
          }
          // if (state is EnterAppPINState) {
          //   return const EnterAppPIN();
          // }
          if (state is VerifyAppPINFailureState ||
              state is EnterAppPINState ||
              state is EnterPINLoadingState) {
            return const EnterAppPIN();
          }

          return const SizedBox();
        },
      ),
    );
  }
}
