import 'package:flutter/material.dart';
import '../common/navigator.dart';

Future<dynamic> showDialogBox(String message) {
  return showDialog(
    context: NavigationService.navigatorKey.currentContext!,
    builder: (context) {
      return AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      );
    },
  );
}


