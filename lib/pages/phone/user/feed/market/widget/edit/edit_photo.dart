// ignore_for_file: missing_return

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/tools/utility/utility.dart';

class EditPhoto extends StatefulWidget {
  final String uid;
  EditPhoto({Key key, this.uid}) : super(key: key);

  @override
  _EditPhotoState createState() => _EditPhotoState();
}

class _EditPhotoState extends State<EditPhoto> {
  PageController controllerPage;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments as ScreenArguments;
    return Scaffold(
        backgroundColor: Colors.white,
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: SliverSafeArea(
                    top: false,
                    sliver: SliverAppBar(
                      backgroundColor: Colors.transparent,
                      expandedHeight: 100,
                      leading: BackButton(
                        color: Colors.black,
                      ),
                      elevation: 0,
                      flexibleSpace: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Редактированиие',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Comfortaa"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: StreamBuilder<MarketApplication>(
                stream: FeedState(
                        uidApplicationMarket:
                            kIsWeb ? args.message : widget.uid)
                    .marketApplication,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    MarketApplication marketApplication = snapshot.data;
                    List<String> images = [
                      marketApplication.m_photo_1,
                      if (marketApplication.m_photo_2 != null)
                        marketApplication.m_photo_2,
                      if (marketApplication.m_photo_3 != null)
                        marketApplication.m_photo_3,
                      if (marketApplication.m_photo_4 != null)
                        marketApplication.m_photo_4,
                      if (marketApplication.m_photo_5 != null)
                        marketApplication.m_photo_5,
                    ];
                    return PageView.builder(
                        physics: BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        itemCount: images.length,
                        allowImplicitScrolling: true,
                        pageSnapping: true,
                        controller: controllerPage,
                        itemBuilder: (context, position) {
                          return Stack(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.black,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 2.5),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: CachedNetworkImage(
                                    imageUrl: images[position],
                                    cacheManager: DefaultCacheManager(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: kIsWeb
                                                ? BoxFit.fitWidth
                                                : BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
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
                              ),
                            ],
                          );
                        });
                  }
                })));
  }
}
