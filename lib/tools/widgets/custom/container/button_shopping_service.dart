import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget button_shop_service(String title, IconData icon) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[300].withOpacity(0.05)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Color.fromRGBO(255, 221, 65, 1), fontWeight: FontWeight.bold),
        ),
        Icon(icon, color: Color.fromRGBO(255, 221, 65, 1))
      ],
    ),
  );
}
