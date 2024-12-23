import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:koul_network/UI/auth/widgets/hasUserData_OrNot.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/model/contact.dart';
import 'package:koul_network/route/routes.dart';
import 'package:koul_network/secrets/api.dart';
import 'package:koul_network/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = PUBLISHABLE_KEY;

  await Hive.initFlutter();
  await Hive.openBox("auth");
  Hive.registerAdapter(UserContactAdapter());
  await Hive.openBox<UserContact>("contacts");

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color.fromARGB(255, 44, 43, 43),
    systemNavigationBarColor: Color.fromARGB(255, 44, 43, 43),
  ));

  runApp(const Koul());
}

final GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class Koul extends StatelessWidget {
  const Koul({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) => KoulAccountBloc(),
        ),
        BlocProvider(
          create: (context) => StripeBloc(),
        )
      ],
      child: MaterialApp(
        title: "Koul Network",
        debugShowCheckedModeBanner: false,
        theme: themeDATA(context),
        home: const HasUserDataOrNot(),
        routes: routeTable,
      ),
    );
  }
}
