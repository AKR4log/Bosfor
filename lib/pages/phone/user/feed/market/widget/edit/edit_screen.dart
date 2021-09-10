import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';
import 'package:provider/provider.dart';

class EditScreenMarket extends StatefulWidget {
  final String uidApp;
  EditScreenMarket({Key key, this.uidApp}) : super(key: key);

  @override
  _EditScreenMarketState createState() => _EditScreenMarketState();
}

class _EditScreenMarketState extends State<EditScreenMarket> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CloudFirestore>(context, listen: false);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            AppLocalizations.of(context).translate('h_edit'),
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton.icon(
                onPressed: () => state.addArchiveMarket(context, widget.uidApp),
                icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.black,
                ),
                label: Text(
                  AppLocalizations.of(context).translate('h_add_archive'),
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(prug(context,
                      'Данная технология требует рассмотрения от заказчика'));
                },
                icon: Icon(
                  Icons.trending_up_rounded,
                  color: Colors.black,
                ),
                label: Text(
                  'Продвигать',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(prug(context,
                      'Данная технология требует рассмотрения от заказчика'));
                },
                icon: Icon(
                  Icons.invert_colors_rounded,
                  color: Colors.black,
                ),
                label: Text(
                  'Покрасить обьявление',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ));
  }
}
