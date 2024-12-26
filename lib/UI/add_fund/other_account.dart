import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class OtherAccount extends StatelessWidget {
  static const routeName = "otheraccount";
  const OtherAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(
          "Payee's Account Detail",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Lottie.asset(
              "assets/accountdetail.json",
              height: 200,
              width: double.infinity,
              repeat: false,
            ),
            TextFormField(
              decoration: InputDecoration(
                label: Text("Payee's Koul ID"),
                border: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white38,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
              maxLength: 24 == 0 ? 100 : 24,
              buildCounter: (context,
                  {required currentLength,
                  required isFocused,
                  required maxLength}) {
                return 24 == 0
                    ? null
                    : Text(
                        '$currentLength/$maxLength',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: InputDecoration(
                label: Text("Payee's Email ID"),
                border: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.black,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white38,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    width: 2,
                    color: Colors.red,
                  ),
                ),
                floatingLabelStyle: Theme.of(context).textTheme.titleMedium,
                labelStyle: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        TextButton.icon(
          onPressed: () {},
          label: Text("Verify"),
          icon: Icon(Icons.verified_user_outlined),
          style: TextButton.styleFrom(
            fixedSize: Size(
              screenSize.height * 1,
              screenSize.height * 0.071,
            ),
          ),
        ),
      ],
    );
  }
}
