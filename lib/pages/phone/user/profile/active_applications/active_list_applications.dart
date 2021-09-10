import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/profile/myPostList.dart';
import 'package:kz/tools/models/applications/applications.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class ActiveApplicationsAuthUser extends StatefulWidget {
  ActiveApplicationsAuthUser({Key key}) : super(key: key);

  @override
  _ActiveApplicationsAuthUserState createState() =>
      _ActiveApplicationsAuthUserState();
}

class _ActiveApplicationsAuthUserState
    extends State<ActiveApplicationsAuthUser> {
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
                    // pinned: true,
                    floating: true,
                    snap: true,
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    leading: BackButton(
                      color: Colors.black,
                    ),
                    flexibleSpace: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15, left: 25),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate('h_active_application'),
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Comfortaa"),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: StreamProvider<List<Application>>.value(
            value: FeedState().allApplicationsAuthUser,
            child: MyPostList(),
          ),
        ));
  }
}
