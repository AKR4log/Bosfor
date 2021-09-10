import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/profile/post.dart';
import 'package:kz/tools/models/applications/applications.dart';
import 'package:provider/provider.dart';

class MyPostList extends StatefulWidget {
  MyPostList({Key key}) : super(key: key);

  @override
  _MyPostListState createState() => _MyPostListState();
}

class _MyPostListState extends State<MyPostList> {
  @override
  Widget build(BuildContext context) {
    final myPosts = Provider.of<List<Application>>(context);
    if (myPosts.length == 0) {
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
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: GridView.builder(
          scrollDirection: Axis.vertical,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5),
          itemBuilder: (context, i) {
            return MyPostWidget(
              post: myPosts[i],
            );
          },
          itemCount: myPosts.length,
        ),
      );
    }
  }
}
