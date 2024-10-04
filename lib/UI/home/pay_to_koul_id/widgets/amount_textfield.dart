import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

Widget buildAmounttextField({
  required BuildContext context,
  required TextEditingController controller,
  required Size screenSize,
}) {
  return Center(
    child: IntrinsicWidth(
      stepWidth: 0,
      child: TextField(
        decoration: InputDecoration(
          prefix: Text(
            "₹ ",
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontSize: screenSize.height * 0.058),
          ),
          hintText: "0.00",
          hintStyle: Theme.of(context)
              .textTheme
              .headlineMedium!
              .copyWith(fontSize: screenSize.height * 0.0660),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
        ),
        inputFormatters: [
          CurrencyInputFormatter(
            thousandSeparator: ThousandSeparator.Comma,
            mantissaLength: 2,
            maxTextLength: 5,
          ),
        ],
        style: Theme.of(context)
            .textTheme
            .headlineMedium!
            .copyWith(fontSize: screenSize.height * 0.0660),
        autofocus: true,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 10,
        buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) =>
            null,
      ),
    ),
  );
}
