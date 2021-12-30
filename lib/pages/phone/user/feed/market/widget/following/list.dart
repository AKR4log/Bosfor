import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/feed/market/widget/following/profile_container.dart';
import 'package:kz/tools/models/applications/liked.dart';
import 'package:kz/tools/models/user/user.dart';
import 'package:provider/provider.dart';

class ContainerListFollowingMarket extends StatefulWidget {
  ContainerListFollowingMarket({Key key}) : super(key: key);

  @override
  _ContainerListFollowingMarketState createState() =>
      _ContainerListFollowingMarketState();
}

class _ContainerListFollowingMarketState
    extends State<ContainerListFollowingMarket> {
  @override
  Widget build(BuildContext context) {
    final marketApplication = Provider.of<List<Liked>>(context);
    return marketApplication.length == 0
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : ListView.separated(
            scrollDirection: Axis.vertical,
            itemCount: marketApplication.length,
            itemBuilder: (context, index) {
              return ProfileContainer(application: marketApplication[index]);
            },
            separatorBuilder: (context, index) {
              return Container();
            },
          );
  }
}
