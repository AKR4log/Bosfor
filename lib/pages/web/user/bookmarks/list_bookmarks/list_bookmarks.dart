import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/tools/models/applications/bookmarks.dart';
import 'package:kz/tools/widgets/custom/container/bookmarks_container.dart';
import 'package:provider/provider.dart';

class ListBookmarksApplications extends StatefulWidget {
  ListBookmarksApplications({Key key}) : super(key: key);

  @override
  _ListBookmarksApplicationsState createState() =>
      _ListBookmarksApplicationsState();
}

class _ListBookmarksApplicationsState extends State<ListBookmarksApplications> {
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
    final bookmarksApplicatinos =
        Provider.of<List<BookmarksApplications>>(context);
    return bookmarksApplicatinos.length == 0
        ? Center(
            child: Container(
            height: 90,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(
                    'Нечего нет(',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                  ),
                ),
                Container(
                  child: Text(
                    AppLocalizations.of(context).translate('hint_text_1'),
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ))
        : GridView.builder(
            scrollDirection: Axis.vertical,
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5),
            itemCount: bookmarksApplicatinos.length,
            itemBuilder: (context, index) {
              return BookmarksApplicationContainer(
                  bookmarksApplicatinos: bookmarksApplicatinos[index]);
            },
          );
  }
}
