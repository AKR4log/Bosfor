import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/bookmarks/list_bookmarks/list_bookmarks.dart';
import 'package:kz/tools/models/applications/bookmarks.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class BookmarksPage extends StatefulWidget {
  BookmarksPage({Key key, GlobalKey<ScaffoldState> scaffoldKey})
      : super(key: key);

  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
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
                    backgroundColor: Colors.transparent,
                    expandedHeight: 100,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    flexibleSpace: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate('h_bookmarks'),
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Comfortaa"),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.trending_up_outlined))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
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
        ));
  }
}
