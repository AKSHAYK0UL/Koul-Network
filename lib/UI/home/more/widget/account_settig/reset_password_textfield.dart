import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/core/helpers/helper_functions/password_checker.dart';
import 'package:koul_network/model/auth_request_signup.dart';
import 'package:koul_network/core/singleton/currentuser.dart';
import 'package:loading_indicator/loading_indicator.dart';

final _formkey = GlobalKey<FormState>();
String passwordValue = "";

Future<void> _onPressedreset(
    BuildContext context, SignUpClass authObject) async {
  final isFormValid = _formkey.currentState!.validate();

  if (!isFormValid) {
    return;
  }
  _formkey.currentState!.save();
  context.read<AuthBloc>().add(
        ForgetPasswordEvent(
          userEmail: CurrentUserSingleton.getCurrentUserInstance().email,
          password: authObject.password,
        ),
      );
}

final _passwordFocusNode = FocusNode();
final _confirmPasswordFocusNode = FocusNode();

Widget buildResetpasswordTextField({
  required BuildContext context,
  required bool Function() password,
  required bool Function() confirmPassword,
}) {
  final screenSize = MediaQuery.sizeOf(context);
  SignUpClass authobj = SignUpClass(
    userName: "",
    userEmail: "",
    password: "",
  );
  return Container(
    margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.009),
    child: Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              final pass = checkPassword(value!);
              if (!pass.isValid) {
                return pass.message;
              }

              return null;
            },
            obscureText: !password(),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
              hintText: 'New Password',
              hintStyle: Theme.of(context).textTheme.titleMedium,
              prefixIcon: Icon(
                Icons.lock,
                color: Theme.of(context).textTheme.titleMedium!.color,
              ),
              suffixIcon: IconButton(
                onPressed: password,
                icon: Icon(
                  password() ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              errorStyle: const TextStyle(color: Colors.orange),
            ),
            cursorRadius: const Radius.circular(0),
            keyboardType: TextInputType.visiblePassword,
            autofocus: false,
            textInputAction: TextInputAction.next,
            focusNode: _passwordFocusNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_confirmPasswordFocusNode);
            },
            onChanged: (newValue) {
              passwordValue = newValue;
            },
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Enter Confirm Password";
              } else if (value != passwordValue) {
                return "Passwords do not match";
              }
              return null;
            },
            obscureText: !confirmPassword(),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
              hintText: 'Confirm Password',
              hintStyle: Theme.of(context).textTheme.titleMedium,
              prefixIcon: Icon(
                Icons.lock,
                color: Theme.of(context).textTheme.titleMedium!.color,
              ),
              suffixIcon: IconButton(
                onPressed: confirmPassword,
                icon: Icon(
                  confirmPassword() ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.grey.shade500,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 2,
                ),
              ),
              errorStyle: const TextStyle(color: Colors.orange),
            ),
            cursorRadius: const Radius.circular(0),
            keyboardType: TextInputType.visiblePassword,
            autofocus: false,
            textInputAction: TextInputAction.done,
            focusNode: _confirmPasswordFocusNode,
            onSaved: (newValue) {
              authobj.password = newValue!;
            },
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          SizedBox(
            width: double.infinity,
            height: screenSize.height * 0.071,
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return ElevatedButton.icon(
                  onPressed: state is AuthLoadingState
                      ? null
                      : () async {
                          FocusManager.instance.primaryFocus!.unfocus();
                          await _onPressedreset(context, authobj);
                        },
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
                      : Icon(
                          Icons.update,
                          size: screenSize.height * 0.0315,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                  label: Text(
                    state is AuthLoadingState ? 'Loading...' : 'Reset',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
