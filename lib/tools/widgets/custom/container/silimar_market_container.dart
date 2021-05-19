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

class SilimarMarketApplicationContainer extends StatefulWidget {
  final MarketApplication application;
  SilimarMarketApplicationContainer({Key key, this.application})
      : super(key: key);

  @override
  _SilimarMarketApplicationContainerState createState() =>
      _SilimarMarketApplicationContainerState();
}

class _SilimarMarketApplicationContainerState
    extends State<SilimarMarketApplicationContainer> {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/WidgetMarket/' + widget.application.m_uid_application);
      },
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.025),
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: widget.application.m_photo == null ||
                widget.application.m_photo == ''
            ? Container()
            : Container(
                width: double.infinity,
                height: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.application.m_photo,
                    cacheManager: DefaultCacheManager(),
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.fitWidth,
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
      ),
    );
  }
}
