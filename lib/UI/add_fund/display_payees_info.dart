import 'package:flutter/material.dart';
import 'package:koul_network/UI/add_fund/screen/self_transfer.dart';
import 'package:koul_network/UI/home/more/widget/user_info.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/helpers/helper_functions/phone_formatter.dart';
import 'package:lottie/lottie.dart';

class DisplayPayeesInfo extends StatefulWidget {
  static const routeName = "DisplayPayeesInfo";
  const DisplayPayeesInfo({super.key});

  @override
  State<DisplayPayeesInfo> createState() => _DisplayPayeesInfoState();
}

class _DisplayPayeesInfoState extends State<DisplayPayeesInfo> {
  @override
  Widget build(BuildContext context) {
    final routeData =
        ModalRoute.of(context)?.settings.arguments as PayeesDetailState;

    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Verify Payee's Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            "assets/account.json",
            height: screenSize.height * 0.280,
            alignment: Alignment.center,
            repeat: false,
          ),
          Text(
            "Verify Payee's Detail Before Proceeding",
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.red),
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
                  data: routeData.payeeDetail.koulId,
                  screenSize: screenSize,
                ),
                buildUserInfo(
                  context: context,
                  title: "Name",
                  data: routeData.payeeDetail.name.replaceFirst(
                      routeData.payeeDetail.name[0],
                      routeData.payeeDetail.name[0].toUpperCase()),
                  screenSize: screenSize,
                ),
                buildUserInfo(
                  context: context,
                  title: "Phone",
                  data:
                      "+91 ${formatPhoneNumber(routeData.payeeDetail.phoneNo)}",
                  screenSize: screenSize,
                ),
                buildUserInfo(
                  context: context,
                  title: "Email",
                  data: routeData.payeeDetail.email,
                  screenSize: screenSize,
                ),
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed(
              TransferFund.routeName,
              arguments: {
                "koul_id": routeData.payeeDetail.koulId,
                "name": routeData.payeeDetail.name
              },
            );
          },
          label: Text("Proceed"),
          icon: Icon(Icons.forward),
          style: TextButton.styleFrom(
              fixedSize: Size(
            screenSize.height * 1,
            screenSize.height * 0.071,
          )),
        )
      ],
    );
  }
}
