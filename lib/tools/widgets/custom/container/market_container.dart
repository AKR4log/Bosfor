import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/feed/market/widget/widget_screen_market.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/tools/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketApplicationContainer extends StatefulWidget {
  final MarketApplication application;
  MarketApplicationContainer({Key key, this.application}) : super(key: key);

  @override
  _MarketApplicationContainerState createState() =>
      _MarketApplicationContainerState();
}

class _MarketApplicationContainerState
    extends State<MarketApplicationContainer> {
  bool outbox = false;

  init() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('bookmarks')
        .doc(widget.application.m_uid_application)
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

  Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (kIsWeb) {
          Navigator.pushNamed(
            context,
            WidgetContainerMarket.routeName,
            arguments:
                ScreenArguments('args', widget.application.m_uid_application),
          );
        } else {
          Navigator.of(context).pushNamed(
              '/WidgetMarket/' + widget.application.m_uid_application);
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
            widget.application.m_photo_1 == null ||
                    widget.application.m_photo_1 == ''
                ? Container()
                : Container(
                    width: double.infinity,
                    height: 170,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.application.m_photo_1,
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
                                                  widget.application
                                                      .m_uid_application)
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
                                                  widget.application
                                                      .m_uid_application)
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
                    margin: EdgeInsets.symmetric(vertical: 2.5),
                    child: Text(
                      widget.application.m_heading,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.application.m_negotiated_price != false
                          ? 'Договорная цена'
                          : widget.application.m_will_give_free != false
                              ? 'Отдам даром'
                              : '₸ ${widget.application.m_price}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.application.m_address != null
                              ? widget.application.m_address
                              : widget.application.m_region != null
                                  ? widget.application.m_region
                                  : 'Не определенно',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        Text(
                          getChatTime(context,
                              widget.application.m_date_creation_application),
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w400),
                        )
                      ],
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
