import 'package:flutter/material.dart';
import 'package:maktaba/utils/app_utils.dart';

class ConfirmExit extends StatelessWidget {
  const ConfirmExit({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppUtils.mainBlue(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(
        'Going Already?',
        style: TextStyle(
          color: AppUtils.mainWhite(context),
        ),
      ),
      content: Text(
        'Do you really want to exit the app?',
        style: TextStyle(
          color: AppUtils.mainWhite(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'Cancel',
            style: TextStyle(color: AppUtils.mainWhite(context)),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ButtonStyle(
              elevation: WidgetStatePropertyAll(5),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
              backgroundColor:
                  WidgetStatePropertyAll(AppUtils.mainWhite(context)),
              padding: WidgetStatePropertyAll(EdgeInsets.all(5))),
          child: Text(
            'Exit',
            style: TextStyle(color: AppUtils.mainBlue(context)),
          ),
        ),
      ],
    );
  }
}
