import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:koul_network/UI/auth/widgets/hasUserData_OrNot.dart';

class CheckNSC extends StatefulWidget {
  const CheckNSC({super.key});

  @override
  State<CheckNSC> createState() => _CheckNSCState();
}

class _CheckNSCState extends State<CheckNSC> {
  AppCheck appCheck = AppCheck();
  bool installed = false;
  bool enabled = false;
  bool available = false;
  final package = "com.example.nex_service_core";

  @override
  void initState() {
    checkNSCAvailability();
    super.initState();
  }

  Future<void> checkNSCAvailability() async {
    final isAvailable = await appCheck.checkAvailability(package);
    final isEnabled = await appCheck.isAppEnabled(package);
    final isInstalled = await appCheck.isAppInstalled(package);

    setState(() {
      if (isAvailable != null) {
        available = true;
      }
      if (isEnabled) {
        enabled = true;
      }
      if (isInstalled) {
        installed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String message = "";

    if (!available) {
      message = "Nex Service Core is not available on your device.";
    } else if (!installed) {
      message = "Nex Service Core is not installed on your device.";
    } else if (!enabled) {
      message = "Nex Service Core is not enabled. Please enable it to proceed.";
    }

    return available && enabled && installed
        ? HasUserDataOrNot()
        : Scaffold(
            body: Center(
              child: Text(
                message,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
