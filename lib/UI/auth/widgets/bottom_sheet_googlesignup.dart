import 'package:bulleted_list/bulleted_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:simnumber/siminfo.dart';

// ignore: must_be_immutable
class BuildGoogleSignUpBottomSheet extends StatefulWidget {
  List<SimCard> simInfo;
  BuildGoogleSignUpBottomSheet(this.simInfo, {super.key});

  @override
  State<BuildGoogleSignUpBottomSheet> createState() =>
      _BuildGoogleSignUpBottomSheetState();
}

class _BuildGoogleSignUpBottomSheetState
    extends State<BuildGoogleSignUpBottomSheet> {
  List<SimCard> simCardInfo = [];
  List<String> steps = [
    "Tap on Open Setting.",
    "Select Permissions.",
    "Allow Phone Permission."
  ];
  String? groupvalue;
  bool phoneStaus = true;

  Future<void> phonePermissionStatus() async {
    PermissionStatus phone = await Permission.phone.status;
    if (phone.isGranted) {
      setState(() {
        phoneStaus = true;
      });
      return;
    }
    if (phone.isPermanentlyDenied) {
      setState(() {
        phoneStaus = false;
      });
      return;
    }

    if (phone.isDenied) {
      Permission.phone.request();

      return;
    } else {
      setState(() {
        phoneStaus = true;
      });
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    phonePermissionStatus();
    setState(() {
      simCardInfo = widget.simInfo;
      if (simCardInfo.isNotEmpty) {
        groupvalue = simCardInfo[0].phoneNumber;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: phoneStaus && widget.simInfo.isEmpty
          ? Container(
              alignment: Alignment.center,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 54, 54, 54),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
              ),
              child: Text(
                "NO sim card found",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : !phoneStaus
              ? Container(
                  alignment: Alignment.center,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 54, 54, 54),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.045,
                        vertical: screenSize.width * 0.080),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Enable Phone Permissions",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.013,
                        ),
                        Text(
                          "To complete your registration, Please enable phone permissions",
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        SizedBox(
                          height: screenSize.height * 0.013,
                        ),
                        BulletedList(
                          bulletColor: Colors.white,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          listItems: steps,
                          style: Theme.of(context).textTheme.labelMedium,
                          listOrder: ListOrder.unordered,
                          bulletType: BulletType.conventional,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 54, 54, 54),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.045,
                        vertical: screenSize.width * 0.080),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select a phone number",
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: screenSize.height * 0.013,
                        ),
                        FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "Ensure the same SIM card used during registration\nis in your device to make a transaction",
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                    fontSize: screenSize.height * 0.02080),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.width * 0.010,
                        ),
                        const Divider(
                          thickness: 1.5,
                        ),
                        SizedBox(
                          height: screenSize.width * 0.010,
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          itemCount: simCardInfo.length,
                          itemBuilder: (context, index) {
                            final simData = simCardInfo[index];
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: screenSize.width * 0.010,
                                  vertical: 0),
                              title: Text(simData.carrierName!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              subtitle: Text(simData.phoneNumber!,
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                              trailing: Radio(
                                fillColor: WidgetStateProperty.resolveWith(
                                  (states) => Colors.white,
                                ),
                                value: simData.phoneNumber!,
                                groupValue: groupvalue,
                                onChanged: (value) {
                                  setState(() {
                                    groupvalue = value;
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  groupvalue = simData.phoneNumber!;
                                });
                              },
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              indent: 0,
                              endIndent: 0,
                              thickness: 2,
                            );
                          },
                        ),
                        SizedBox(
                          height: screenSize.width * 0.039,
                        ),
                      ],
                    ),
                  ),
                ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: phoneStaus && simCardInfo.isEmpty
          ? const Text("")
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.025,
                  vertical: screenSize.width * 0.050),
              child: SizedBox(
                width: double.infinity,
                height: screenSize.height * 0.071,
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return !phoneStaus
                        ? ElevatedButton.icon(
                            onPressed: () async {
                              await openAppSettings();
                              if (!context.mounted) return;
                              Navigator.of(context).pop();
                            },
                            label: Text(
                              "Open setting",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            icon: const Icon(Icons.settings),
                          )
                        : ElevatedButton.icon(
                            onPressed: state is AuthLoadingState
                                ? null
                                : () {
                                    context
                                        .read<AuthBloc>()
                                        .add(GoogleSignAuthEvent(groupvalue!));
                                  },
                            label: Text(state is AuthLoadingState
                                ? "Loading..."
                                : "Sign Up"),
                            icon: state is AuthLoadingState
                                ? Center(
                                    child: LoadingIndicator(
                                      indicatorType: Indicator.pacman,
                                      colors: const [Colors.white],
                                      strokeWidth: 2,
                                      backgroundColor: Colors.blueGrey,
                                      pathBackgroundColor: Colors.grey.shade700,
                                    ),
                                  )
                                : const Icon(Icons.person),
                          );
                  },
                ),
              ),
            ),
    );
  }
}
