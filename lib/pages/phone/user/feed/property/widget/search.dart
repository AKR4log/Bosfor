import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/widgets/custom/container/market_container.dart';
import 'package:kz/tools/widgets/custom/container/property_container.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SearchScreenProperty extends StatefulWidget {
  SearchScreenProperty({Key key}) : super(key: key);

  @override
  _SearchScreenPropertyState createState() => _SearchScreenPropertyState();
}

class _SearchScreenPropertyState extends State<SearchScreenProperty> {
  @override
  Widget build(BuildContext context) {
    final marketApplication = Provider.of<List<PropertyApplication>>(context);
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
                    return PropertyApplicationContainer(
                        application: marketApplication[index]);
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
