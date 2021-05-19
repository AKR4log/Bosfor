// import 'package:fancy_bottom_navigation/internal/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/state/app_state.dart';
import 'package:kz/tools/widgets/custom/nav/tab.dart';
import 'package:provider/provider.dart';
// import 'customBottomNavigationBar.dart';

class BottomMenubar extends StatefulWidget {
  const BottomMenubar({this.pageController});
  final PageController pageController;
  _BottomMenubarState createState() => _BottomMenubarState();
}

class _BottomMenubarState extends State<BottomMenubar> {
  PageController _pageController;
  int _selectedIcon = 0;
  @override
  void initState() {
    _pageController = widget.pageController;
    super.initState();
  }

  Widget _iconRow() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).bottomAppBarColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, -.1), blurRadius: 0)
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _icon(Icons.search_rounded, 0),
          _icon(Icons.outbox_rounded, 1),
          _icon(Icons.dashboard_customize_rounded, 2),
          _icon(Icons.mail, 3),
          _icon(
            Icons.data_usage_rounded,
            4,
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData iconData, int index) {
    var state = Provider.of<AppState>(
      context,
    );
    return Expanded(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: AnimatedAlign(
          duration: Duration(milliseconds: ANIM_DURATION),
          curve: Curves.easeIn,
          alignment: Alignment(0, ICON_ON),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: ANIM_DURATION),
            opacity: ALPHA_ON,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.all(0),
              alignment: Alignment(0, 0),
              icon: Icon(
                iconData,
                color: index == state.pageIndex
                    ? Color.fromRGBO(13, 6, 40, 1)
                    : Color.fromRGBO(13, 6, 40, 0.4),
                size: 27,
              ),
              onPressed: () {
                setState(() {
                  _selectedIcon = index;
                  state.setpageIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _iconRow();
  }
}
