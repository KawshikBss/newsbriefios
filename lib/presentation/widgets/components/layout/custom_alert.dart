import 'package:flutter/material.dart';

SnackBar showCustomAlert(String text, {Function? action, String? actionText}) =>
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      action: action != null
          ? SnackBarAction(
              label: actionText ?? '',
              onPressed: () {
                action();
              })
          : null,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.black,
    );
