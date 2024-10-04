import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:koul_network/UI/auth/screens/secure_signup_auth.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';

import 'package:koul_network/model/auth_request_signup.dart';
import 'package:loading_indicator/loading_indicator.dart';

final _formkey = GlobalKey<FormState>();

void _onSignInPressed(BuildContext context, SignUpClass authobj) {
  final isFormValid = _formkey.currentState!.validate();

  if (!isFormValid) {
    return;
  }
  _formkey.currentState!.save();
  context.read<AuthBloc>().add(
        SecureSignInEvent(
            userEmail: authobj.userEmail, userName: authobj.userName),
      );
}

final _nameFocusNode = FocusNode();
final _emailFocusNode = FocusNode();

Widget buildTextFieldSecureSignIn({
  required BuildContext context,
}) {
  final screenSize = MediaQuery.sizeOf(context);
  SignUpClass authobj = SignUpClass(userName: "", userEmail: "", password: "");
  return Container(
    margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.009),
    child: Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return 'Enter name';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(vertical: screenSize.height * 0.02),
              hintText: 'Name',
              hintStyle: Theme.of(context).textTheme.titleMedium,
              prefixIcon: Icon(
                Icons.account_circle,
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
              authobj.userName = newValue!;
            },
            cursorRadius: const Radius.circular(0),
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            textInputAction: TextInputAction.next,
            focusNode: _nameFocusNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_emailFocusNode);
            },
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
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
            cursorRadius: const Radius.circular(0),
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            textInputAction: TextInputAction.done,
            focusNode: _emailFocusNode,
            onSaved: (newValue) {
              authobj.userEmail = newValue!;
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
                          _onSignInPressed(context, authobj);
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
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SecureSignUpScreen.routeName);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Register now ",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
