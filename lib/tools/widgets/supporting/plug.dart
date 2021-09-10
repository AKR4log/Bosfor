import 'package:flutter/material.dart';

Widget prug(
  BuildContext context,
  String label,
) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(label),
    action: SnackBarAction(
      label: 'Посмотреть',
      onPressed: () {
        Navigator.pushNamed(context, "/PlugScreen");
      },
    ),
  );
}

Widget plugWidget(String name, String status) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 20),
        ),
        Text(
          status,
          style: TextStyle(),
        )
      ],
    ),
  );
}
