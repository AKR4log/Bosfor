import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/widgets/custom/container/market_container.dart';
import 'package:provider/provider.dart';

class ListMarketApplications extends StatefulWidget {
  ListMarketApplications({Key key}) : super(key: key);

  @override
  _ListMarketApplicationsState createState() => _ListMarketApplicationsState();
}

class _ListMarketApplicationsState extends State<ListMarketApplications> {
  bool isScrolled = false, fullpost = false;
  List<DocumentSnapshot> products = [];
  bool isLoading = false;
  bool hasMore = true;
  int documentLimit = 10;
  DocumentSnapshot lastDocument;
  ScrollController _scrollController = ScrollController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.20;
      if (maxScroll - currentScroll <= delta) {
        getProducts();
      }
    });
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
          .collection('market')
          .orderBy('m_uid_user_by_application')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('market')
          .orderBy('m_uid_user_by_application')
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
    final marketApplication = Provider.of<List<MarketApplication>>(context);
    return marketApplication.length == 0
        ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          )
        : GridView.builder(
            scrollDirection: Axis.vertical,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2),
            itemCount: marketApplication.length,
            itemBuilder: (context, index) {
              return MarketApplicationContainer(
                  application: marketApplication[index]);
            },
          );
  }
}
