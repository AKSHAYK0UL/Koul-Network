import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

void buildOpenSettingDialogBox({
  required BuildContext context,
  required String title,
  required String content,
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
        content: Text(content),
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
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.transparent),
            onPressed: () async {
              await perm.openAppSettings();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: Text(
              "Open Setting",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          )
        ],
      );
    },
  );
}
