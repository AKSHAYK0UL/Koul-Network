import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/auth/screens/forgot_password.dart';
import 'package:koul_network/UI/auth/screens/signup.dart';

import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/model/auth_request_signin.dart';
import 'package:loading_indicator/loading_indicator.dart';

final _formkey = GlobalKey<FormState>();
Future<void> _onSignInPressed(BuildContext context, SignInClass authobj) async {
  final isFormvalid = _formkey.currentState!.validate();
  if (!isFormvalid) {
    return;
  }
  _formkey.currentState!.save();
  context.read<AuthBloc>().add(SignInRequestEvent(
      userEmail: authobj.userEmail, password: authobj.password));
}

Widget BuildTextFieldSignIn({
  required BuildContext context,
  required bool Function() password,
}) {
  final screenSize = MediaQuery.sizeOf(context);
  SignInClass authobj = SignInClass(userEmail: "", password: "");

  return Container(
    margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.009),
    child: Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter email';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
              hintText: 'Email',
              hintStyle: Theme.of(context).textTheme.titleMedium,
              prefixIcon: Icon(
                Icons.email,
                color: Theme.of(context).textTheme.titleMedium!.color,
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
            onSaved: (newValue) {
              authobj.userEmail = newValue!;
            },
            cursorRadius: const Radius.circular(0),
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter password';
              }
              return null;
            },
            obscureText: !password(),
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
              hintText: 'Password',
              hintStyle: Theme.of(context).textTheme.titleMedium,
              suffixIcon: IconButton(
                onPressed: password,
                icon: Icon(
                  password() ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
              prefixIcon: Icon(
                Icons.lock,
                color: Theme.of(context).textTheme.titleMedium!.color,
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
            onSaved: (newValue) {
              authobj.password = newValue!;
            },
            cursorRadius: const Radius.circular(0),
            keyboardType: TextInputType.visiblePassword,
            autofocus: false,
            textInputAction: TextInputAction.done,
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
                          await _onSignInPressed(context, authobj);
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
                          Icons.person,
                          size: screenSize.height * 0.0315,
                          color: Theme.of(context).textTheme.titleLarge!.color,
                        ),
                  label: Text(
                    state is AuthLoadingState ? 'Signing In...' : 'Sign In',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushReplacementNamed(SignUpScreen.routeName);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Register now",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(ForgotPasswordScreen.routeName);
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
