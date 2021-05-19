import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kz/tools/models/applications/applications.dart';

class MyPostWidget extends StatefulWidget {
  final Application post;
  MyPostWidget({this.post});

  @override
  _MyPostWidgetState createState() => _MyPostWidgetState();
}

class _MyPostWidgetState extends State<MyPostWidget> {
  String image;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    FirebaseFirestore.instance
        .collection("transport")
        .doc(widget.post.m_uid_application)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          image = snapshot.get('m_photo');
        });
      }
    });
    FirebaseFirestore.instance
        .collection("property")
        .doc(widget.post.m_uid_application)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          image = snapshot.get('m_photo');
        });
      }
    });
    FirebaseFirestore.instance
        .collection("market")
        .doc(widget.post.m_uid_application)
        .get()
        .then((snapshot) {
      if (snapshot.data() != null) {
        setState(() {
          image = snapshot.get('m_photo');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showGeneralDialog(
          barrierDismissible: true,
          barrierLabel: '',
          barrierColor: Colors.black38,
          transitionDuration: Duration(milliseconds: 700),
          pageBuilder: (ctx, anim1, anim2) => BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 35 * anim1.value, sigmaY: 35 * anim1.value),
              child: FadeTransition(
                child: Center(
                  child: Container(
                    height: 450,
                    width: 300,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 300,
                            width: 300,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: CachedNetworkImage(
                                      imageUrl: image,
                                      cacheManager: DefaultCacheManager(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholderFadeInDuration:
                                          Duration(milliseconds: 500),
                                      placeholder: (context, url) => Container(
                                        color:
                                            Colors.grey[300].withOpacity(0.3),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.blue[300],
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Перейти',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.red[300],
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Удалить',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                opacity: anim1,
              )),
          transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: 35 * anim1.value, sigmaY: 35 * anim1.value),
                child: FadeTransition(
                  child: child,
                  opacity: anim1,
                ),
              ),
          context: context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: image != null
              ? CachedNetworkImage(
                  imageUrl: image,
                  cacheManager: DefaultCacheManager(),
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  placeholderFadeInDuration: Duration(milliseconds: 500),
                  placeholder: (context, url) => Container(
                    color: Colors.grey[300].withOpacity(0.3),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
              : SizedBox(),
        ),
      ),
    );
  }
}
