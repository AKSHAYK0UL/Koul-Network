import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/more/widget/user_info.dart';
import 'package:koul_network/singleton/currentuser.dart';
import 'package:lottie/lottie.dart';

class AccountInfo extends StatefulWidget {
  static const routeName = "AccountInfo";
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  final currentUser = CurrentUserSingleton.getCurrentUserInstance();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Account Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/account.json",
            height: screenSize.height * 0.310,
            alignment: Alignment.center,
            repeat: false,
          ),
          Align(
            alignment: Alignment.center,
            child: Chip(
              backgroundColor: Colors.transparent,
              side: const BorderSide(color: Colors.transparent),
              avatar: const Icon(
                Icons.check,
                color: Colors.green,
              ),
              label: Text(
                "Your account is secure",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Card(
            elevation: screenSize.height * 0.00200,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.symmetric(
                horizontal: screenSize.height * 0.0110,
                vertical: screenSize.height * 0.0000),
            color: const Color.fromARGB(255, 43, 42, 42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildUserInfo(
                  context: context,
                  title: "KOUL ID",
                  data: currentUser.id,
                  screenSize: screenSize,
                ),
                buildUserInfo(
                  context: context,
                  title: "Name",
                  data: currentUser.name.replaceFirst(
                      currentUser.name[0], currentUser.name[0].toUpperCase()),
                  screenSize: screenSize,
                ),
                buildUserInfo(
                  context: context,
                  title: "Phone",
                  data: "+91 ${currentUser.phone}",
                  screenSize: screenSize,
                ),
                buildUserInfo(
                  context: context,
                  title: "Email",
                  data: currentUser.email,
                  screenSize: screenSize,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
