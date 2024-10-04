import 'package:flutter/material.dart';
import 'package:koul_network/model/koul_account/transaction.dart';

Widget buildTransactionDetailBox({
  required BuildContext context,
  required Transaction transactionData,
  required Function() rightButtonFun,
  required String rightButtonText,
  required IconData rightButtonIcon,
}) {
  final screenSize = MediaQuery.sizeOf(context);
  return Container(
    height: screenSize.height * 0.47,
    width: double.infinity,
    margin: EdgeInsets.symmetric(
        horizontal: screenSize.height * 0.013,
        vertical: screenSize.height * 0.0325),
    constraints: BoxConstraints(
      maxHeight: screenSize.height * 0.47,
      maxWidth: double.infinity,
    ),
    decoration: BoxDecoration(
      color: Theme.of(context).appBarTheme.backgroundColor,
      borderRadius: BorderRadius.circular(16),
      border:
          Border.all(color: Colors.white, width: screenSize.height * 0.00100),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenSize.height * 0.0065,
              vertical: screenSize.height * 0.0062),
          child: Row(
            children: [
              Image.asset(
                "assets/koul_signup_image.png",
                height: screenSize.height * 0.0455,
                width: screenSize.height * 0.0455,
              ),
              SizedBox(
                width: screenSize.height * 0.0065,
              ),
              Text(
                "Koul Network",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenSize.height * 0.012,
              vertical: screenSize.height * 0.0062),
          child: helper(context, transactionData, screenSize),
        ),
        SizedBox(
          height: screenSize.height * 0.020,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.height * 0.002),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: screenSize.height * 0.0585,
                width: screenSize.height * 0.210,
                child: TextButton.icon(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                  ),
                  label: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      "Take screeshot",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  icon: const Icon(Icons.screenshot),
                ),
              ),
              SizedBox(
                height: screenSize.height * 0.0585,
                width: screenSize.height * 0.210,
                child: TextButton.icon(
                  onPressed: rightButtonFun,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 66, 66, 66),
                  ),
                  label: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      rightButtonText,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                  icon: Icon(rightButtonIcon),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

Widget helper(
    BuildContext context, Transaction transactionData, Size screenSize) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Transaction ID",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(
        transactionData.transactionId,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      SizedBox(
        height: screenSize.height * 0.020,
      ),
      Text(
        "To: ${transactionData.to.name.replaceFirst(transactionData.to.name[0], transactionData.to.name[0].toUpperCase())}",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(
        transactionData.to.koulId,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      SizedBox(
        height: screenSize.height * 0.020,
      ),
      Text(
        "From: ${transactionData.from.name.replaceFirst(transactionData.from.name[0], transactionData.from.name[0].toUpperCase())}",
        style: Theme.of(context).textTheme.titleMedium,
      ),
      Text(
        transactionData.from.koulId,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ],
  );
}
