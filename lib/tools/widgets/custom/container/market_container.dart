import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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
        Navigator.of(context).pushNamed('/WidgetMarket/' + widget.application.m_uid_application);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.025),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Column(
          children: [
            widget.application.m_photo == null ||
                    widget.application.m_photo == ''
                ? Container()
                : Container(
                    width: double.infinity,
                    height: 170,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: widget.application.m_photo,
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
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black.withOpacity(0.03),
                                ),
                                margin: EdgeInsets.only(right: 5, top: 5),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(Icons.outbox_rounded,
                                        color: outbox
                                            ? Colors.black26
                                            : Colors.white),
                                    onPressed: () {
                                      final snackBarAdd = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.blueAccent[300],
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.outbox_rounded,
                                              color: Colors.blue[200],
                                            ),
                                            Text(
                                              'Добавленно в избранное',
                                              style: TextStyle(
                                                  color: Colors.blue[200],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      );
                                      final snackBarDetele = SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.blueAccent[300],
                                        content: Row(
                                          children: [
                                            Icon(
                                              Icons.delete_forever_rounded,
                                              color: Colors.red[200],
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
                    child: Text(
                      widget.application.m_negotiated_price != false
                          ? 'Договорная цена'
                          : widget.application.m_will_give_free != false
                          ? 'Отдам даром'
                          : '₸${widget.application.m_price}',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.application.m_heading,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    child: Text(
                      widget.application.m_address != null
                          ? widget.application.m_address
                          : widget.application.m_region != null
                          ? widget.application.m_region
                          : 'Не определенно',
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
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
