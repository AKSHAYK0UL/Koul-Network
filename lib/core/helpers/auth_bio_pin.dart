import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/setup_transaction_pin.dart';
import 'package:koul_network/main.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();
bool _isAuthenticated = false;
// Future<void> authenticateWithBiometrics(
//     {required BuildContext context,
//     required String toKoulId,
//     String route = ''}) async {
//   try {
//     _isAuthenticated = await auth.authenticate(
//       localizedReason: 'Scan your fingerprint or Enter your lock screen pin',
//       options: const AuthenticationOptions(
//         biometricOnly: false,
//       ),
//     );
//     if (_isAuthenticated) {
//       if (route.isEmpty) {
//         Navigator.of(scaffoldKey.currentContext!)
//             .pushNamed(SetupTransactionPin.routeName, arguments: toKoulId);
//       } else if (route.isNotEmpty) {
//         // Navigator.of(scaffoldKey.currentContext!).pushNamed(route);
//         if (!context.mounted) return;
//         Navigator.of(context).pushNamed(route);
//       }
//     }
//   } catch (e) {
//     if (!context.mounted) return;
//     buildSnackBar(context, "error in authentication");
//   }
// }

Future<void> authenticateWithBiometrics({
  required BuildContext context,
  required String toKoulId,
  String route = '',
}) async {
  try {
    // Check if the device supports biometrics or PIN
    bool isSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (isSupported && canCheckBiometrics) {
      _isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint or Enter your lock screen PIN',
        options: const AuthenticationOptions(
          biometricOnly: false,
        ),
      );
    }
  } catch (e) {
    _isAuthenticated = false;
  }

  // If authentication succeeds or is skipped, navigate to the next screen
  if (_isAuthenticated || !(await _isAuthenticationSetup())) {
    if (route.isEmpty) {
      Navigator.of(scaffoldKey.currentContext!)
          .pushNamed(SetupTransactionPin.routeName, arguments: toKoulId);
    } else {
      if (!context.mounted) return;
      Navigator.of(context).pushNamed(route);
    }
  }
}

/// Helper function to check if authentication is set up
Future<bool> _isAuthenticationSetup() async {
  return await auth.isDeviceSupported() && await auth.canCheckBiometrics;
}
