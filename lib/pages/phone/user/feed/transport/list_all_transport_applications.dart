import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/transport.dart';
import 'package:kz/tools/widgets/custom/container/transport_container.dart';
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
    return Column(
      children: [
        Expanded(
          child: transportApplication.length == 0
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  itemCount: transportApplication.length,
                  itemBuilder: (context, index) {
                    return TransportApplicationContainer(
                        application: transportApplication[index]);
                  },
                ),
        ),
      ],
    );
  }
}
