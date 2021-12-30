import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/models/applications/bookmarks.dart';
import 'package:kz/tools/widgets/custom/container/bookmarks_container.dart';
import 'package:provider/provider.dart';

class ListBookmarksApplications extends StatefulWidget {
  final bool payContainer;
  ListBookmarksApplications({Key key, this.payContainer}) : super(key: key);

  @override
  _ListBookmarksApplicationsState createState() =>
      _ListBookmarksApplicationsState();
}

class _ListBookmarksApplicationsState extends State<ListBookmarksApplications> {
  @override
  Widget build(BuildContext context) {
    final bookmarksApplicatinos =
        Provider.of<List<BookmarksApplications>>(context);
    return bookmarksApplicatinos.length == 0
        ? Center(
            child: Container(
            height: 90,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Нечего нет(',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                ),
                Container(
                  child: Text(
                    AppLocalizations.of(context).translate('hint_text_1'),
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ))
        : GridView.builder(
            scrollDirection: Axis.vertical,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemCount: bookmarksApplicatinos.length,
            itemBuilder: (context, index) {
              return BookmarksApplicationContainer(
                bookmarksApplicatinos: bookmarksApplicatinos[index],
              );
            },
          );
  }
}
