import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/check_balance/screens/checkbalance.dart';
import 'package:koul_network/UI/home/more/screen/account_info.dart';
import 'package:koul_network/UI/home/more/screen/account_setting.dart';
import 'package:koul_network/UI/home/more/screen/privacy.dart';
import 'package:koul_network/UI/home/more/widget/build_tiles.dart';
import 'package:koul_network/helpers/helper_functions/logout/logout_func.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Setting",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialogOnLogOut(context);
            },
            icon: const Icon(
              Icons.login,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTiles(
            context: context,
            text: "Account Detail",
            icon: Icons.person,
            onTap: () {
              Navigator.of(context).pushNamed(AccountInfo.routeName);
            },
          ),
          buildTiles(
            context: context,
            text: "Account Setting",
            icon: Icons.settings,
            onTap: () {
              Navigator.of(context).pushNamed(AccountSetting.routeName);
            },
          ),
          buildTiles(
            context: context,
            text: "Balance and More",
            icon: Icons.account_balance,
            onTap: () {
              Navigator.of(context).pushNamed(CheckbalanceScreen.routeName);
            },
          ),
          buildTiles(
            context: context,
            text: "Privacy",
            icon: Icons.verified_user,
            onTap: () {
              Navigator.of(context).pushNamed(Privacy.routeName);
            },
          ),
        ],
      ),
    );
  }
}

void showDialogOnLogOut(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          "Are You Sure?",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          "Are you sure you want to Sign Out?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () async {
              await logOut(context); //helper func
            },
            child: Text(
              "Yes",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      );
    },
  );
}
