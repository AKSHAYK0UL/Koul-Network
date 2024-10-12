import 'package:flutter/material.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/setup_transaction_pin.dart';
import 'package:koul_network/main.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();
bool _isAuthenticated = false;
Future<void> authenticateWithBiometrics(
    {required BuildContext context,
    required String toKoulId,
    String route = ''}) async {
  try {
    _isAuthenticated = await auth.authenticate(
      localizedReason: 'Scan your fingerprint or Enter your lock screen pin',
      options: const AuthenticationOptions(
        biometricOnly: false,
      ),
    );
    print(_isAuthenticated);
    if (_isAuthenticated) {
      if (route.isEmpty) {
        Navigator.of(scaffoldKey.currentContext!)
            .pushNamed(SetupTransactionPin.routeName, arguments: toKoulId);
      } else if (route.isNotEmpty) {
        Navigator.of(scaffoldKey.currentContext!).pushNamed(route);
      }
      print('Successfully authenticated');
    }
  } catch (e) {
    print(e.toString());
    if (!context.mounted) return;
    buildSnackBar(context, "error in authentication");
  }
}
