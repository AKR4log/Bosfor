import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/main.dart';

class EditsLang extends StatefulWidget {
  EditsLang({Key key}) : super(key: key);

  @override
  _EditsLangState createState() => _EditsLangState();
}

class _EditsLangState extends State<EditsLang> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).translate('h_edit_lang'),
          style: TextStyle(color: Colors.black),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
                onPressed: () {
                  Locale newLocale = Locale('en', 'US');
                  MyHome.setLocale(context, newLocale);
                },
                child: Text(AppLocalizations.of(context).translate('en'))),
            TextButton(
                onPressed: () {
                  Locale newLocale = Locale('kk', 'KK');
                  MyHome.setLocale(context, newLocale);
                },
                child: Text(AppLocalizations.of(context).translate('kz'))),
            TextButton(
                onPressed: () {
                  Locale newLocale = Locale('ru', 'Ru');
                  MyHome.setLocale(context, newLocale);
                },
                child: Text(AppLocalizations.of(context).translate('ru'))),
          ],
        ),
      ),
    );
  }
}
