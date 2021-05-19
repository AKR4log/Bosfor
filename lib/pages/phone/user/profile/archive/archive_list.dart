import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/profile/archive/widgets/list.dart';
import 'package:kz/tools/models/applications/applications.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class ArchiveList extends StatefulWidget {
  ArchiveList({Key key}) : super(key: key);

  @override
  _ArchiveListState createState() => _ArchiveListState();
}

class _ArchiveListState extends State<ArchiveList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).translate('h_arcive'),
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Builder(
          builder: (BuildContext context) {
            return StreamProvider<List<Application>>.value(
              value: FeedState().allArchiveApplicationsAuthUser,
              child: ListArchiveApp(),
            );
          },
        ),
      ),
    );
  }
}
