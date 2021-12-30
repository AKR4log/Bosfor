import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/feed/property/widget/search.dart';
import 'package:kz/pages/phone/user/feed/transport/widget/search.dart';
import 'package:kz/tools/constant/name_category.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/widgets/custom/checkbox/custom_checkbox.dart';
import 'package:kz/tools/widgets/custom/container/cnt_auto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:kz/tools/widgets/custom/container/containers_custom.dart';
import 'package:kz/tools/widgets/custom/textfield/textFieldCustom.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class ListTransportApplications extends StatefulWidget {
  ListTransportApplications({Key key}) : super(key: key);

  @override
  _ListTransportApplicationsState createState() =>
      _ListTransportApplicationsState();
}

class _ListTransportApplicationsState extends State<ListTransportApplications> {
  bool isScrolled = false, fullpost = false;
  List<DocumentSnapshot> products = [];
  bool isLoading = false,
      only_foreign_cars = false,
      errorHosts = false,
      errorPriceForTerm = false,
      rent_auto = false;
  TextEditingController controllerEngineVolume = TextEditingController();
  TextEditingController controllerCarTax = TextEditingController();
  TextEditingController controllerHosts = TextEditingController();
  TextEditingController controllerPriceForTerm = TextEditingController();

  bool hasMore = true, errorCarTax = false;
  String search,
      rent_auto_term_val,
      rent_auto_payment_val,
      rent_auto_an_initial_fee_val,
      rent_auto_contract_val,
      rent_auto_casco_insurance_val;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  getProducts() async {
    if (!hasMore) {
      setState(() {
        fullpost = true;
      });
      return;
    }
    if (isLoading) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    QuerySnapshot querySnapshot;
    if (lastDocument == null) {
      querySnapshot = await firestore
          .collection('auto')
          .orderBy('authorApplicationUid')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('auto')
          .orderBy('authorApplicationUid')
          .startAfterDocument(lastDocument)
          .limit(documentLimit)
          .get();
      print(1);
    }
    if (querySnapshot.docs.length < documentLimit) {
      hasMore = false;
    }
    lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    products.addAll(querySnapshot.docs);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transportApplication =
        Provider.of<List<TransportApplication>>(context);
    return transportApplication.length == 0
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : Stack(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Поиск',
                              ),
                              onChanged: (txt) {
                                setState(() {
                                  search = txt;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color.fromRGBO(239, 239, 239, 1)),
                      width: double.infinity,
                    ),
                    search != null && search != ''
                        ? StreamProvider<List<TransportApplication>>.value(
                            value: FeedState(searchText: search).searchAuto,
                            child: SearchScreenAuto(),
                          )
                        : Expanded(
                            child: GridView.builder(
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              controller: _scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: kIsWeb ? 4 : 2,
                                      childAspectRatio: kIsWeb ? 1 : 0.7,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2),
                              itemCount: transportApplication.length,
                              itemBuilder: (context, index) {
                                return CNTAuto(
                                    application: transportApplication[index]);
                              },
                            ),
                          ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(239, 239, 239, 1)),
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(15),
                        ),
                      ))),
                  onPressed: () => mdlSearch(context),
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.filter_alt_rounded,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Фильтр поиска',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.expand_less_rounded,
                          color: Colors.black,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
  }

  mdlSearch(
    BuildContext context,
  ) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      )),
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) {
        return DraggableScrollableActuator(
            child: DraggableScrollableSheet(
          minChildSize: 0.3,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 75,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black54.withOpacity(0.4)),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Фильтр поиска',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        Text('Выбирете нужный пункт',
                            style: TextStyle(fontSize: 17))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    height: 45,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Icon(Icons.search),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Поиск',
                            ),
                            onChanged: (txt) {
                              setState(() {
                                search = txt;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromRGBO(239, 239, 239, 1)),
                    width: double.infinity,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: twoColumnsContainer(
                              AppCheckbox(
                                value: only_foreign_cars,
                                onChanged: (val) {
                                  setState(() {
                                    only_foreign_cars = val;
                                  });
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Только иномарки',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: textFieldtwo(
                            controllerEngineVolume,
                            false,
                            AppLocalizations.of(context)
                                .translate('h_m_engine_volume'),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: textFieldtwo(
                            controllerCarTax,
                            errorCarTax,
                            'Налог на авто',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: textFieldtwo(
                            controllerHosts,
                            errorHosts,
                            'Было хозяев',
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: twoColumnsContainer(
                              AppCheckbox(
                                value: rent_auto,
                                onChanged: (val) {
                                  setState(() {
                                    rent_auto = val;
                                    only_foreign_cars = false;
                                  });
                                  controllerCarTax.clear();
                                  controllerHosts.clear();
                                  controllerEngineVolume.clear();
                                },
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  'Аренда авто',
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                ),
                              )),
                        ),
                        rent_auto
                            ? Container(
                                child: Column(
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Выберите срок проживания',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            value: rent_auto_term_val,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              errorStyle: TextStyle(
                                                  color: Colors.yellow),
                                            ),
                                            hint: Text('Выберите срок'),
                                            items: rent_auto_term.map((map) {
                                              return DropdownMenuItem(
                                                child: Text(AppLocalizations.of(
                                                        context)
                                                    .translate(map['value'])),
                                                value: map['value'],
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                rent_auto_term_val = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: textFieldtwo(
                                        controllerPriceForTerm,
                                        errorPriceForTerm,
                                        'Цена за указанный срок',
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Оплата',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            value: rent_auto_payment_val,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              errorStyle: TextStyle(
                                                  color: Colors.yellow),
                                            ),
                                            hint: Text('Выберите вид оплаты'),
                                            items: rent_auto_payment.map((map) {
                                              return DropdownMenuItem(
                                                child: Text(AppLocalizations.of(
                                                        context)
                                                    .translate(map['value'])),
                                                value: map['value'],
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                rent_auto_payment_val = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Первоначальный взнос',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            value: rent_auto_an_initial_fee_val,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              errorStyle: TextStyle(
                                                  color: Colors.yellow),
                                            ),
                                            hint: Text(
                                                'Выберите вид первоначального взноса'),
                                            items: rent_auto_an_initial_fee
                                                .map((map) {
                                              return DropdownMenuItem(
                                                child: Text(AppLocalizations.of(
                                                        context)
                                                    .translate(map['value'])),
                                                value: map['value'],
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                rent_auto_an_initial_fee_val =
                                                    val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    rent_auto_an_initial_fee_val == 'from_to'
                                        ? Container()
                                        : SizedBox(),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Договор',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            value: rent_auto_contract_val,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              errorStyle: TextStyle(
                                                  color: Colors.yellow),
                                            ),
                                            hint: Text('Выберите вид договора'),
                                            items:
                                                rent_auto_contract.map((map) {
                                              return DropdownMenuItem(
                                                child: Text(AppLocalizations.of(
                                                        context)
                                                    .translate(map['value'])),
                                                value: map['value'],
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                rent_auto_contract_val = val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Text(
                                              'Страхование КАСКО',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          DropdownButtonFormField(
                                            isExpanded: true,
                                            value:
                                                rent_auto_casco_insurance_val,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              errorStyle: TextStyle(
                                                  color: Colors.yellow),
                                            ),
                                            hint: Text(
                                                'Выберите вид страхование КАСКО'),
                                            items: rent_auto_casco_insurance
                                                .map((map) {
                                              return DropdownMenuItem(
                                                child: Text(AppLocalizations.of(
                                                        context)
                                                    .translate(map['value'])),
                                                value: map['value'],
                                              );
                                            }).toList(),
                                            onChanged: (val) {
                                              setState(() {
                                                rent_auto_casco_insurance_val =
                                                    val;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(255, 221, 97, 1)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        )),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Сохранить параметры поиска',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
      },
    );
  }
}
