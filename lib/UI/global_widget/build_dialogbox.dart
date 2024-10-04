import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';

void buildDialogBox({
  required BuildContext context,
  required String title,
  required Widget content,
  required String clipboardtext,
}) {
  showDialog(
    context: context,
    builder: (cotext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
        ),
        content: content,
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Close",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          clipboardtext.isNotEmpty
              ? TextButton(
                  style:
                      TextButton.styleFrom(backgroundColor: Colors.transparent),
                  onPressed: () {
                    Clipboard.setData(
                      ClipboardData(text: clipboardtext),
                    );
                    Navigator.of(context).pop();

                    buildSnackBar(context, "Copied to clipboard");
                  },
                  child: Text(
                    "Copy",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )
              : const SizedBox(),
        ],
      );
    },
  );
}
