import 'package:flutter/material.dart';

class SuccessUploadPhoto extends StatefulWidget {
  SuccessUploadPhoto({Key key}) : super(key: key);

  @override
  _SuccessUploadPhotoState createState() => _SuccessUploadPhotoState();
}

class _SuccessUploadPhotoState extends State<SuccessUploadPhoto> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(12, 206, 107, 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(12, 206, 107, 1),
                      borderRadius: BorderRadius.circular(25)),
                  margin: EdgeInsets.symmetric(vertical: 15),
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 75,
                  ),
                ),
                Text(
                  'Успешно загружено',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  margin: EdgeInsets.only(
                      bottom: 25,
                      top: MediaQuery.of(context).size.height * 0.35),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/HomePage");
                    },
                    child: Text(
                      'Понятно',
                      style: TextStyle(
                          color: Color.fromRGBO(12, 206, 107, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
