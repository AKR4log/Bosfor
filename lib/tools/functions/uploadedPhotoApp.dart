import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:uuid/uuid.dart';

Future<void> uploadPhoto(
    BuildContext context,
    String batabase,
    File image,
    Function waitingStart(),
    Function waitingEnd(),
    Function getUID(val)) async {
  String randomName;
  randomName = Uuid().v1();
  // var state = Provider.of<CloudFirestore>(context, listen: false);
  firebase_storage.Reference slideshowImageRef = firebase_storage
      .FirebaseStorage.instance
      .ref()
      .child('$batabase/$randomName.png');
  File _newFile = await FlutterNativeImage.compressImage(image.path,
      quality: 80, percentage: 80);
  firebase_storage.UploadTask slideshowRefTask =
      slideshowImageRef.putFile(_newFile);
  slideshowRefTask.snapshotEvents.listen((event) {}).onData((snapshot) {
    waitingStart();
    if (snapshot.state == firebase_storage.TaskState.success) {
      waitingEnd();
      slideshowImageRef.getDownloadURL().then((snapshot) {
        getUID(snapshot.toString());
      });
    }
  });
}
