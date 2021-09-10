import 'package:flutter/material.dart';
import 'package:kz/pages/web/user/bookmarks/list_bookmarks/list_bookmarks.dart';
import 'package:kz/pages/web/user/creation/creation_application.dart';
import 'package:kz/pages/web/user/home/home_page.dart';
import 'package:kz/pages/web/user/messanger/chat/chats.dart';
import 'package:kz/pages/web/user/profile/profile.dart';
import 'package:kz/tools/models/applications/bookmarks.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class WebBookmarksPage extends StatefulWidget {
  static var routeName = '/bookmarks';
  WebBookmarksPage({Key key, GlobalKey<ScaffoldState> scaffoldKey})
      : super(key: key);

  @override
  _WebBookmarksPageState createState() => _WebBookmarksPageState();
}

class _WebBookmarksPageState extends State<WebBookmarksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverSafeArea(
                  top: false,
                  sliver: SliverAppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(255, 221, 97, 1),
                    actions: [
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(HomeWebPage.routeName),
                          icon: Icon(
                            Icons.home_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(WebBookmarksPage.routeName),
                          icon: Icon(
                            Icons.favorite_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(WebCreationApplication.routeName),
                          icon: Icon(
                            Icons.add_circle_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(ChatTab.routeName),
                          icon: Icon(
                            Icons.near_me_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15),
                        child: IconButton(
                          onPressed: () => Navigator.of(context)
                              .pushReplacementNamed(WebProfilePage.routeName),
                          icon: Icon(
                            Icons.account_circle_rounded,
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                      )
                    ],
                    title: Text(
                      'Bosfor',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        // fontFamily: "Comfortaa",
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.15),
            child: SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return StreamProvider<List<BookmarksApplications>>.value(
                    value: FeedState().allBookmarksApplications,
                    child: ListBookmarksApplications(),
                  );
                },
              ),
            ),
          ),
        ));
  }
}
