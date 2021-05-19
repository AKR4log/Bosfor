import 'package:flutter/material.dart';

class SetTextContainer extends StatefulWidget {
  TextEditingController textPost;
  bool getPhoto;
  SetTextContainer({Key key, this.getPhoto, this.textPost}) : super(key: key);

  @override
  _SetTextContainerState createState() => _SetTextContainerState();
}

class _SetTextContainerState extends State<SetTextContainer> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 75,
      right: 15,
      left: 15,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        height: widget.getPhoto ? 70 : 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: widget.textPost,
            cursorColor: Colors.white,
            maxLines: 2,
            keyboardType: TextInputType.text,
            style: TextStyle(
                fontSize: 16, fontFamily: "Nunito", color: Colors.white70),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10),
              isCollapsed: true,
              hintText: 'Введите сообщение',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
