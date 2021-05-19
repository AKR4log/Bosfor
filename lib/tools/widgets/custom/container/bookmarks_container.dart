import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/models/applications/bookmarks.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/tools/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarksApplicationContainer extends StatefulWidget {
  final BookmarksApplications bookmarksApplicatinos;
  BookmarksApplicationContainer({Key key, this.bookmarksApplicatinos})
      : super(key: key);

  @override
  _BookmarksApplicationContainerState createState() =>
      _BookmarksApplicationContainerState();
}

class _BookmarksApplicationContainerState
    extends State<BookmarksApplicationContainer> {
  String m_photo, m_address, m_region, m_price, m_heading;
  bool m_negotiated_price = false, m_will_give_free = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    FirebaseFirestore.instance
        .collection("transport")
        .doc(widget.bookmarksApplicatinos.uidApplications)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          m_photo = snapshot.get('m_photo');
          m_address = snapshot.get('m_address');
          m_region = snapshot.get('m_region');
          m_price = snapshot.get('m_price');
          m_heading = snapshot.get('m_heading');
          m_negotiated_price = snapshot.get('m_negotiated_price');
          m_will_give_free = snapshot.get('m_will_give_free');
        });
      }
    });
    FirebaseFirestore.instance
        .collection("property")
        .doc(widget.bookmarksApplicatinos.uidApplications)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          m_photo = snapshot.get('m_photo');
          m_address = snapshot.get('m_address');
          m_region = snapshot.get('m_region');
          m_price = snapshot.get('m_price');
          m_heading = snapshot.get('m_heading');
          m_negotiated_price = snapshot.get('m_negotiated_price');
          m_will_give_free = snapshot.get('m_will_give_free');
        });
      }
    });
    FirebaseFirestore.instance
        .collection("market")
        .doc(widget.bookmarksApplicatinos.uidApplications)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          m_photo = snapshot.get('m_photo');
          m_address = snapshot.get('m_address');
          m_region = snapshot.get('m_region');
          m_price = snapshot.get('m_price');
          m_heading = snapshot.get('m_heading');
          m_negotiated_price = snapshot.get('m_negotiated_price');
          m_will_give_free = snapshot.get('m_will_give_free');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
            '/WidgetMarket/' + widget.bookmarksApplicatinos.uidApplications);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.025),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            m_photo == null || m_photo == ''
                ? Container()
                : Container(
                    width: double.infinity,
                    height: 170,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: CachedNetworkImage(
                        imageUrl: m_photo,
                        cacheManager: DefaultCacheManager(),
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholderFadeInDuration: Duration(milliseconds: 500),
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300].withOpacity(0.3),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
            m_heading != null
                ? Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            m_negotiated_price
                                ? 'Договорная цена'
                                : m_will_give_free
                                ? 'Отдам даром'
                                : '₸${m_price ?? ''}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Container(
                          child: Text(
                            m_heading ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          child: Text(
                            m_address != ''
                                ? m_address ?? ''
                                : m_region != ''
                                ? m_region ?? ''
                                : 'Не определенно',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}