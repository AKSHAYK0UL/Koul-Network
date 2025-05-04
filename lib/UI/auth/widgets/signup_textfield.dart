import 'package:flutter/material.dart';
import 'package:bulleted_list/bulleted_list.dart';
import 'package:koul_network/UI/auth/screens/signin.dart';
import 'package:koul_network/core/helpers/helper_functions/password_checker.dart';
import 'package:koul_network/core/helpers/helper_functions/show_model_sheet.dart';
import 'package:koul_network/core/helpers/helper_functions/sim_info.dart';
import 'package:koul_network/model/auth_request_signup.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_card_info/sim_info.dart';

final _formkey = GlobalKey<FormState>();
String passwordValue = "";

void _onSignUpPressed(BuildContext context, SignUpClass authObject) async {
  final isFormValid = _formkey.currentState!.validate();

  if (!isFormValid) {
    return;
  }
  _formkey.currentState!.save();
  PermissionStatus phone = await Permission.phone.status;
  if (!context.mounted) return;
  if (phone.isPermanentlyDenied) {
    List<SimInfo> siminfo = [];
    buildBottomSheet(context, authObject, siminfo, "email");
    return;
  }
  getSimCardsData(context).then((siminfo) {
    buildBottomSheet(context, authObject, siminfo, "email");
  });
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          "Please note",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BulletedList(
              bulletColor: Colors.white,
              crossAxisAlignment: CrossAxisAlignment.center,
              listOrder: ListOrder.ordered,
              listItems: const [
                "You can only set your username at the time of creating your account.",
                "Once set, your username cannot be changed.",
              ],
              style: Theme.of(context).textTheme.displayMedium,
            )
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      );
    },
  );
}

List<String> domainList = [
  "@gmail.com",
  "@yahoo.com",
  "@outlook.com",
  "@aol.com",
  "@icloud.com",
  "@yandex.ru",
  "@ya.ru",
  "@protonmail.com",
  "@zoho.com",
  "@yandex.com",
];
List<Widget> generateListOfDomain(BuildContext context) {
  final screenSize = MediaQuery.sizeOf(context);

  return List.generate(
    domainList.length,
    (index) => Padding(
      padding: EdgeInsets.symmetric(horizontal: screenSize.height * 0.0035),
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          domainList[index],
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ),
    ),
  );
}

void _allowedEmailDomain(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.grey.shade900,
        title: Text(
          "Please note",
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "To proceed, please use an email address from one of the following domains:\n",
              style: Theme.of(context).textTheme.displayMedium,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: [
                ...generateListOfDomain(context),
              ],
            ),
            Text(
              "\nIf you have any questions or need assistance, please contact us @koulnetwork.uk.",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      );
    },
  );
}

final _nameFocusNode = FocusNode();
final _emailFocusNode = FocusNode();
final _passwordFocusNode = FocusNode();
final _confirmPasswordFocusNode = FocusNode();

Widget buildTextFieldSignUp({
  required BuildContext context,
  required bool Function() password,
  required bool Function() confirmPassword,
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
              suffixIcon: IconButton(
                onPressed: () => _showDialog(context),
                icon: Icon(
                  Icons.info,
                  color: Theme.of(context).textTheme.titleMedium!.color,
                ),
              ),
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
              suffixIcon: IconButton(
                  onPressed: () => _allowedEmailDomain(context),
                  icon: Icon(
                    Icons.info,
                    color: Theme.of(context).textTheme.titleMedium!.color,
                  )),
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
            textInputAction: TextInputAction.next,
            focusNode: _emailFocusNode,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(_passwordFocusNode);
            },
            onSaved: (newValue) {
              authobj.userEmail = newValue!;
            },
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
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
              hintText: 'Password',
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
            child: ElevatedButton.icon(
              onPressed: () {
                FocusManager.instance.primaryFocus!.unfocus();
                _onSignUpPressed(context, authobj);
              },
              icon: Icon(
                Icons.arrow_forward,
                size: screenSize.height * 0.0315,
                color: Theme.of(context).textTheme.titleLarge!.color,
              ),
              label: Text(
                "Next",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          ),
          SizedBox(
            height: screenSize.height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SignInScreen.routeName);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Already a member?",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
