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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('h_active_application'),
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: StreamProvider<List<Application>>.value(
        value: FeedState().allApplicationsAuthUser,
        child: MyPostList(),
      ),
    );
  }
}
