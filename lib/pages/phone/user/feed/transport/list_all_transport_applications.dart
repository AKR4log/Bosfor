import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/pages/phone/user/feed/property/widget/search.dart';
import 'package:kz/pages/phone/user/feed/transport/widget/search.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/state/feed_state.dart';
import 'package:kz/tools/widgets/custom/container/cnt_auto.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
  bool isLoading = false;
  bool hasMore = true;
  String search;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // init();
  }

  // init() {
  //   _scrollController.addListener(() {
  //     double maxScroll = _scrollController.position.maxScrollExtent;
  //     double currentScroll = _scrollController.position.pixels;
  //     double delta = MediaQuery.of(context).size.height * 0.20;
  //     if (maxScroll - currentScroll <= delta) {
  //       getProducts();
  //     }
  //   });
  // }

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
        //       : Stack(
        //           children: [
        //             SizedBox(
        //               child: Column(
        //                 children: [
        //                   Container(
        //                     margin:
        //                         EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        //                     height: 45,
        //                     padding: EdgeInsets.symmetric(horizontal: 15),
        //                     child: Row(
        //                       children: [
        //                         Icon(Icons.search),
        //                         SizedBox(
        //                           width: 10,
        //                         ),
        //                         Expanded(
        //                           child: TextField(
        //                             decoration: InputDecoration(
        //                               border: InputBorder.none,
        //                               hintText: 'Поиск',
        //                             ),
        //                             onChanged: (txt) {
        //                               setState(() {
        //                                 search = txt;
        //                               });
        //                             },
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(25),
        //                         color: Color.fromRGBO(239, 239, 239, 1)),
        //                     width: double.infinity,
        //                   ),
        //                   search != null && search != ''
        //                       ? StreamProvider<List<TransportApplication>>.value(
        //                           value: FeedState(searchText: search).searchAuto,
        //                           child: SearchScreenAuto(),
        //                         )
        //                       : Expanded(
        //                           child: GridView.builder(
        //                             physics: BouncingScrollPhysics(
        //                                 parent: AlwaysScrollableScrollPhysics()),
        //                             controller: _scrollController,
        //                             gridDelegate:
        //                                 SliverGridDelegateWithFixedCrossAxisCount(
        //                                     crossAxisCount: kIsWeb ? 4 : 2,
        //                                     childAspectRatio: kIsWeb ? 1 : 0.7,
        //                                     crossAxisSpacing: 2,
        //                                     mainAxisSpacing: 2),
        //                             itemCount: transportApplication.length,
        //                             itemBuilder: (context, index) {
        //                               return CNTAuto(
        //                                   application: transportApplication[index]);
        //                             },
        //                           ),
        //                         ),
        //                 ],
        //               ),
        //             ),
        //             Align(
        //               alignment: Alignment.bottomCenter,
        //               child: TextButton(
        //                 style: ButtonStyle(
        //                     backgroundColor: MaterialStateProperty.all(
        //                         Color.fromRGBO(239, 239, 239, 1)),
        //                     padding: MaterialStateProperty.all(EdgeInsets.zero),
        //                     shape: MaterialStateProperty.all(RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.vertical(
        //                         top: Radius.circular(15),
        //                       ),
        //                     ))),
        //                 onPressed: () => mdlSearch(context),
        //                 child: Container(
        //                   height: 50,
        //                   padding: EdgeInsets.symmetric(horizontal: 15),
        //                   width: double.infinity,
        //                   child: Row(
        //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                     children: [
        //                       Row(
        //                         children: [
        //                           Icon(
        //                             Icons.filter_alt_rounded,
        //                             color: Colors.black,
        //                           ),
        //                           SizedBox(
        //                             width: 10,
        //                           ),
        //                           Text(
        //                             'Фильтр поиска',
        //                             style: TextStyle(
        //                               fontSize: 18,
        //                               color: Colors.black,
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                       Icon(
        //                         Icons.expand_less_rounded,
        //                         color: Colors.black,
        //                       )
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             )
        //           ],
        //         );
        // }
        : Container(
            child: Text(
                'На ремонте из-за поломки, из-за торопления по функции 360'),
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
            return Column(
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
              ],
            );
          },
        ));
      },
    );
  }
}
