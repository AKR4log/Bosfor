import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/database/database.dart';
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
      body: Center(
        child: TextButton(
          onPressed: () => state.addArchiveMarket(context, widget.uidApp),
          child: Text(AppLocalizations.of(context).translate('h_add_archive')),
        ),
      ),
    );
  }
}
