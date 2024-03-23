import 'package:flutter/material.dart';

SnackBar buildSnackBar(
  Widget content,
) {
  return SnackBar(
      elevation: 3,
      showCloseIcon: true,
      backgroundColor: const Color.fromRGBO(35, 50, 73, 1),
      closeIconColor: const Color.fromRGBO(248, 250, 252, 1),
      duration: const Duration(milliseconds: 3000),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      content: content);
}
