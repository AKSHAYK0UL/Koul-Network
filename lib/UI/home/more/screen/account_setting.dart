import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/more/screen/account_setting/reset_password.dart';
import 'package:koul_network/UI/home/more/widget/build_tiles.dart';
import 'package:koul_network/helpers/auth_bio_pin.dart';
import 'package:koul_network/main.dart';
import 'package:koul_network/singleton/currentuser.dart';

class AccountSetting extends StatefulWidget {
  static const routeName = "AccountSetting";
  const AccountSetting({super.key});

  @override
  State<AccountSetting> createState() => _AccountSettingState();
}

class _AccountSettingState extends State<AccountSetting> {
  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Account Setting",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          if (CurrentUserSingleton.getCurrentUserInstance().authType ==
              "Email Auth")
            buildTiles(
              context: context,
              text: "Reset password",
              icon: Icons.password,
              onTap: () {
                Navigator.of(context).pushNamed(
                  ResetPasswordScreen.routeName,
                );
              },
            ),
          buildTiles(
            context: context,
            text: "Update App Pin",
            icon: Icons.key,
            onTap: () {},
          ),
          buildTiles(
            context: context,
            text: "Update KOUL Pin",
            icon: Icons.pin,
            onTap: () {
              authenticateWithBiometrics(context, currentUser.id);
            },
          ),
        ],
      ),
    );
  }
}
