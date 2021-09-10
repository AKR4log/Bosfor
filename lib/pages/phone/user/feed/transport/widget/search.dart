import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/widgets/custom/container/cnt_auto.dart';
import 'package:kz/tools/widgets/custom/container/market_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SearchScreenAuto extends StatefulWidget {
  SearchScreenAuto({Key key}) : super(key: key);

  @override
  _SearchScreenAutoState createState() => _SearchScreenAutoState();
}

class _SearchScreenAutoState extends State<SearchScreenAuto> {
  @override
  Widget build(BuildContext context) {
    final marketApplication = Provider.of<List<TransportApplication>>(context);
    return marketApplication == null
        ? Center(
            child: Text(
              'Нам ничего не удалось найти, введите другой поисковой ключ',
              textAlign: TextAlign.center,
            ),
          )
        : marketApplication.length >= 1
            ? Expanded(
                child: GridView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kIsWeb ? 4 : 2,
                      childAspectRatio: kIsWeb ? 1 : 0.7,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemCount: marketApplication.length,
                  itemBuilder: (context, index) {
                    return CNTAuto(application: marketApplication[index]);
                  },
                ),
              )
            : Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              );
  }
}
