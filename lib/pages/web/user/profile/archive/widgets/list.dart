import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/profile/archive/widgets/conel.dart';
import 'package:kz/tools/models/applications/applications.dart';
import 'package:provider/provider.dart';

class ListArchiveApp extends StatefulWidget {
  ListArchiveApp({Key key}) : super(key: key);

  @override
  _ListArchiveAppState createState() => _ListArchiveAppState();
}

class _ListArchiveAppState extends State<ListArchiveApp> {
  @override
  Widget build(BuildContext context) {
    final application = Provider.of<List<Application>>(context);
    if (application.length == 0) {
      return Center(
        child: Container(
          height: 45,
          width: 45,
          child: Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
          )),
        ),
      );
    } else {
      return Expanded(
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          // controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemCount: application.length,
          itemBuilder: (context, index) {
            return ContainerElevetation(
              application: application[index],
            );
          },
        ),
      );
    }
  }
}
