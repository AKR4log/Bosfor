import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/reviews.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/utility/utility.dart';

class ReviewContainer extends StatefulWidget {
  final Review review;
  ReviewContainer({Key key, this.review}) : super(key: key);

  @override
  _ReviewContainerState createState() => _ReviewContainerState();
}

class _ReviewContainerState extends State<ReviewContainer> {
  dynamic baseColor;

  colors() async {
    List<Color> _colorList = [
      Colors.pink[400],
      Colors.pinkAccent,
      Colors.red[400],
      Colors.redAccent,
      Colors.deepOrange[400],
      Colors.deepOrangeAccent,
      Colors.orange[800],
      Colors.orangeAccent[700],
      Colors.amber[900],
      Colors.lime[800],
      Colors.lightGreen[700],
      Colors.green[600],
      Colors.teal[400],
      Colors.cyan[600],
      Colors.lightBlue[600],
      Colors.lightBlueAccent[700],
      Colors.blue[600],
      Colors.blueAccent,
      Colors.indigo[400],
      Colors.indigoAccent,
      Colors.purple[400],
      Colors.purpleAccent[400],
      Colors.deepPurple[400],
      Colors.deepPurpleAccent,
      Colors.blueGrey[400],
      Colors.brown[400],
      Colors.grey[600],
    ];

    var hash = widget.review.uidUser.hashCode;
    var index = hash % _colorList.length;
    setState(() {
      baseColor = _colorList[index];
    });
    return _colorList[index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[50], borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder<UserData>(
              stream: FeedState(uidUser: widget.review.uidUser).qUser,
              // ignore: missing_return
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  UserData userData = snapshot.data;
                  return TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed('/UserScreen/' + widget.review.uidUser),
                    child: Container(
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              userData.u_uri_avatars != null &&
                                      userData.u_uri_avatars != ''
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(45),
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        child: CachedNetworkImage(
                                          imageUrl: userData.u_uri_avatars,
                                          cacheManager: DefaultCacheManager(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholderFadeInDuration:
                                              Duration(milliseconds: 500),
                                          placeholder: (context, url) =>
                                              Container(
                                            color: Colors.grey[300]
                                                .withOpacity(0.3),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  : ClipRRect(
                                      child: Container(
                                        width: 35,
                                        height: 35,
                                        decoration: BoxDecoration(
                                            color: baseColor,
                                            borderRadius:
                                                BorderRadius.circular(40)),
                                        child: Center(
                                          child: Text(
                                              (userData.u_surname != ''
                                                      ? userData.u_name[0] +
                                                          userData.u_surname[0]
                                                      : userData.u_name[0])
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  userData.u_name,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            getChatTime(context, widget.review.dateCreations),
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
            child: Text(
              widget.review.txt,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
