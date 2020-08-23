import 'package:flutter/material.dart';

cirularAlertDialog(BuildContext context) async {
  return showDialog(
    barrierDismissible: false,
    context: context,
    child: AlertDialog(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 10,
          ),
          Text("Preparing document..."),
        ],
      ),
    ),
  );
}
