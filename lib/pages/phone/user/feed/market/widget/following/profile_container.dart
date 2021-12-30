import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/tools/models/applications/liked.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';

class ProfileContainer extends StatefulWidget {
  final Liked application;
  ProfileContainer({Key key, this.application}) : super(key: key);

  @override
  _ProfileContainerState createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
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

    var hash = widget.application.uidUser.hashCode;
    var index = hash % _colorList.length;
    setState(() {
      baseColor = _colorList[index];
    });
    return _colorList[index];
  }

  @override
  void initState() {
    colors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
        stream: FeedState(uidUser: widget.application.uidUser).qUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return TextButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed('/UserScreen/' + widget.application.uidUser),
              child: Container(
                height: 55,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            userData.name,
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Показать все объявления',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                    userData.uriImage != null && userData.uriImage != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(45),
                            child: Container(
                              width: 55,
                              height: 55,
                              child: CachedNetworkImage(
                                imageUrl: userData.uriImage,
                                cacheManager: DefaultCacheManager(),
                                imageBuilder: (context, imageProvider) =>
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
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300].withOpacity(0.3),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          )
                        : ClipRRect(
                            child: Container(
                              width: 55,
                              height: 55,
                              decoration: BoxDecoration(
                                  color: baseColor,
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Text(
                                    (userData.surname != ''
                                            ? userData.name[0] +
                                                userData.surname[0]
                                            : userData.name[0])
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
