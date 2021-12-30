import 'package:flutter/material.dart';

class CashProfile extends StatefulWidget {
  CashProfile({Key key}) : super(key: key);

  @override
  _CashProfileState createState() => _CashProfileState();
}

class _CashProfileState extends State<CashProfile> {
  @override
  Widget build(BuildContext context) {
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
                      pinned: true,
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
                                'Кошелёк',
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
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey[50]),
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ваш кошелёк',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              'Ваш баланс: ',
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              'НЕТ СОЕДИНЕНИЯ',
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {},
                                child: Text('Вывести деньги')),
                            TextButton(
                                onPressed: () {},
                                child: Text('Пополнить баланс')),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
