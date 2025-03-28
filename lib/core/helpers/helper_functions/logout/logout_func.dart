import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/enums/auth_type_enum.dart';
import 'package:koul_network/core/singleton/currentuser.dart';
import 'package:koul_network/core/singleton/currentuser_account.dart';

Future<void> logOut(BuildContext context) async {
  String? authType;
  if (Hive.box("auth").isNotEmpty) {
    authType = Hive.box("auth").get("authtype").toString();
  }
  if (authType! == AuthType.emailAuth.toString()) {
    context.read<AuthBloc>().add(AuthLogOutEvent());
    CurrentUserSingleton.clearCurrentUserInstance();
    CurrentuserKoulAccountSingleton.clearCurrentUserKoulAccountInstance();
    context.read<KoulAccountBloc>().add(SetStateToInitial());
  } else if (authType == AuthType.googleAuth.toString()) {
    if (!context.mounted) return;
    context.read<AuthBloc>().add(AuthLogOutEvent());
    context.read<AuthBloc>().add(GoogleSignOutEvent());
    CurrentUserSingleton.clearCurrentUserInstance();
    CurrentuserKoulAccountSingleton.clearCurrentUserKoulAccountInstance();
    context.read<KoulAccountBloc>().add(SetStateToInitial());
  } else {
    //for secure session
    context.read<AuthBloc>().add(AuthLogOutEvent());
    CurrentUserSingleton.clearCurrentUserInstance();
    CurrentuserKoulAccountSingleton.clearCurrentUserKoulAccountInstance();
    context.read<KoulAccountBloc>().add(SetStateToInitial());
  }
}
