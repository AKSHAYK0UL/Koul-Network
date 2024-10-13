import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/more/screen/AppPinkeypad.dart';
import 'package:koul_network/UI/home/more/widget/build_tiles.dart';
import 'package:koul_network/enums/app_pin_settting.dart';
import 'package:koul_network/singleton/currentuser.dart';

class AppPinSetting extends StatelessWidget {
  static const routeName = "apppinsetting";
  const AppPinSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App PIN Setting",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          if (!currentUser.appPINstatus)
            buildTiles(
              context: context,
              text: "Create App PIN",
              icon: Icons.pin,
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppPINKeypad.routeName,
                  arguments: AppPINSettingRoute.create,
                );
              },
            ),
          if (currentUser.appPINstatus)
            buildTiles(
              context: context,
              text: "Update App PIN",
              icon: Icons.change_circle,
              onTap: () {},
            ),
          if (currentUser.appPINstatus)
            buildTiles(
              context: context,
              text: "Delete App PIN",
              icon: Icons.delete,
              onTap: () {},
            ),
        ],
      ),
    );
  }
}
