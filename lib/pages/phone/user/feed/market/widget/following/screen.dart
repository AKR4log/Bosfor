import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/feed/market/widget/following/list.dart';
import 'package:kz/tools/models/applications/liked.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:provider/provider.dart';

class ListFollowingMarket extends StatefulWidget {
  final String uidApp;
  ListFollowingMarket({Key key, this.uidApp}) : super(key: key);

  @override
  _ListFollowingMarketState createState() => _ListFollowingMarketState();
}

class _ListFollowingMarketState extends State<ListFollowingMarket> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
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
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Кому понравилось',
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
          body: SingleChildScrollView(
              child: StreamProvider<List<Liked>>.value(
            value:
                FeedState(uidApplicationMarket: widget.uidApp).followingMarket,
            child: ContainerListFollowingMarket(),
          ))),
    );
  }
}
