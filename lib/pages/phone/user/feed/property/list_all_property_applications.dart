import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/property.dart';
import 'package:kz/tools/widgets/custom/container/property_container.dart';
import 'package:provider/provider.dart';

class ListPropertyApplications extends StatefulWidget {
  ListPropertyApplications({Key key}) : super(key: key);

  @override
  _ListPropertyApplicationsState createState() =>
      _ListPropertyApplicationsState();
}

class _ListPropertyApplicationsState extends State<ListPropertyApplications> {
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
          .collection('property')
          .orderBy('authorApplicationUid')
          .limit(documentLimit)
          .get();
    } else {
      querySnapshot = await firestore
          .collection('property')
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
    final propertyApplication =
        Provider.of<List<PropertyApplication>>(context);
    return Column(
      children: [
        Expanded(
          child: propertyApplication.length == 0
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )
              : ListView.builder(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  itemCount: propertyApplication.length,
                  itemBuilder: (context, index) {
                    return PropertyApplicationContainer(
                        application: propertyApplication[index]);
                  },
                ),
        ),
      ],
    );
  }
}
