import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/pages/phone/user/feed/property/widget/screen_property.dart';
import 'package:kz/tools/database/database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/utility/utility.dart';
import 'package:provider/provider.dart';

class PropertyApplicationContainer extends StatefulWidget {
  final PropertyApplication application;
  PropertyApplicationContainer({Key key, this.application}) : super(key: key);

  @override
  _PropertyApplicationContainerState createState() =>
      _PropertyApplicationContainerState();
}

class _PropertyApplicationContainerState
    extends State<PropertyApplicationContainer> {
  bool outbox = false;

  init() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('bookmarks')
        .doc(widget.application.uid_property)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          outbox = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (kIsWeb) {
          Navigator.pushNamed(
            context,
            WidgetContainerProperty.routeName,
            arguments: ScreenArguments('args', widget.application.uid_property),
          );
        } else {
          Navigator.of(context)
              .pushNamed('/WidgetProperty/' + widget.application.uid_property);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.025),
          borderRadius: BorderRadius.circular(8),
        ),
        margin: EdgeInsets.all(2.5),
        child: Column(
          children: [
            widget.application.p_photo_1 == null ||
                    widget.application.p_photo_1 == ''
                ? Container()
                : Container(
                    width: double.infinity,
                    height: 170,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.application.p_photo_1,
                        cacheManager: DefaultCacheManager(),
                        imageBuilder: (context, imageProvider) => Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.only(right: 5, bottom: 5),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                        outbox
                                            ? Icons.favorite_rounded
                                            : Icons.favorite_border_rounded,
                                        color: Colors.white.withOpacity(0.85)),
                                    onPressed: () {
                                      final snackBarAdd = SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Icon(
                                                Icons.outbox_rounded,
                                                color: Colors.blue[400],
                                              ),
                                            ),
                                            Text(
                                              'Добавленно в избранное',
                                              style: TextStyle(
                                                  color: Colors.blue[400],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      );
                                      final snackBarDetele = SnackBar(
                                        backgroundColor: Colors.white,
                                        content: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 15),
                                              child: Icon(
                                                Icons.delete_forever_rounded,
                                                color: Colors.red[200],
                                              ),
                                            ),
                                            Text(
                                              'Удалено из избранного',
                                              style: TextStyle(
                                                  color: Colors.red[200],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      );
                                      var state = Provider.of<CloudFirestore>(
                                          context,
                                          listen: false);
                                      outbox
                                          ? state
                                              .deteleBookmarks(
                                                  context,
                                                  widget
                                                      .application.uid_property)
                                              .whenComplete(() {
                                              setState(() {
                                                outbox = false;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBarDetele);
                                            })
                                          : state
                                              .addBookmarks(
                                                  context,
                                                  widget
                                                      .application.uid_property)
                                              .whenComplete(() {
                                              setState(() {
                                                outbox = true;
                                              });
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBarAdd);
                                            });
                                    },
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        placeholderFadeInDuration: Duration(milliseconds: 500),
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300].withOpacity(0.3),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      widget.application.p_country_city != null
                          ? widget.application.p_country_city
                          : 'Не определенно',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 2.5),
                    child: Text(
                      widget.application.p_head,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    child: Text(
                      '₸ ${widget.application.p_price}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.red[400]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
