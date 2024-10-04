import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koul_network/UI/auth/screens/signIn_email_or_oauth.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';

class HasUserDataOrNot extends StatelessWidget {
  const HasUserDataOrNot({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("auth").listenable(),
      builder: (context, value, child) {
        if (value.isEmpty) {
          return const SignInEmailOrOauth();
        }
        return const HomeScreen();
      },
    );
  }
}
