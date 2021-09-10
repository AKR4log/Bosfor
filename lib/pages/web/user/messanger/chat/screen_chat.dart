import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kz/tools/database/utility_database.dart';
import 'package:kz/tools/utility/utility.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  static var routeName = '/chat_room';

  final String chatWithUsername;
  ChatScreen({
    this.chatWithUsername,
  });
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String chatRoomId, messageId = "";
  dynamic baseColorTo, baseColorFrom;
  Stream messageStream;
  String myUserName = FirebaseAuth.instance.currentUser.uid,
      avatarsUser,
      name,
      surname,
      myName,
      mySurname;
  TextEditingController messageTextEdittingController = TextEditingController();
  String downloadURI;
  double _progress;
  File image;
  bool uploaded = false, selectedImage = false, waiting = false, error = false;
  Future<File> imageFile;
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  getMyInfoFromSharedPreference() async {
    chatRoomId = getChatRoomIdByUsernames(widget.chatWithUsername, myUserName);
  }

  init() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.chatWithUsername)
        .get()
        .then((value) {
      if (value.data() != null) {
        setState(() {
          name = value.data()['name'];
          surname = value.data()['surname'];
          avatarsUser = value.data()['uriImage'];
        });
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      setState(() {
        myName = value.get('name');
        mySurname = value.get('surname');
      });
    });
  }

  getChatRoomIdByUsernames(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('llogo');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  addMessage(bool sendClicked) {
    if (messageTextEdittingController.text != "") {
      String message = messageTextEdittingController.text;

      if (messageId == "") {
        messageId = Uuid().v4();
      }

      var lastMessageTs = DateTime.now().toUtc().toString();

      Map<String, dynamic> messageInfoMap = {
        "message": message,
        "sendBy": myUserName,
        "ts": lastMessageTs,
      };

      // remove the text in the message input field
      DatabaseMethods().addMessage(chatRoomId, messageId, messageInfoMap);
      createPush(message, '$myName $mySurname', widget.chatWithUsername);

      Map<String, dynamic> lastMessageInfoMap = {
        "lastMessage": message,
        "lastMessageSendTs": lastMessageTs,
        "lastMessageSendBy": myUserName
      };

      DatabaseMethods().updateLastMessageSend(chatRoomId, lastMessageInfoMap);
      messageTextEdittingController.text = "";
      // make message id blank to get regenerated on next message send
      messageId = "";
    }

    //messageId
    if (messageId == "") {
      messageId = Uuid().v4();
    }
  }

  Widget chatMessageTile(String message, bool sendByMe, time) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              minWidth: 35.0,
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight:
                    sendByMe ? Radius.circular(5) : Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: sendByMe ? Radius.circular(15) : Radius.circular(5),
              ),
              color: sendByMe ? Colors.blue[500] : Colors.blue[300],
            ),
            padding: image != null ? EdgeInsets.all(3) : EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(message,
                      style: TextStyle(
                          fontSize: image != null ? 13 : 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w500)),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    getTimeMessage(context, time),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.w300),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: messageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.only(bottom: 70, top: 16),
                itemCount: snapshot.data.docs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return chatMessageTile(
                    ds["message"],
                    myUserName == ds["sendBy"],
                    ds["ts"],
                  );
                })
            : Center(child: CircularProgressIndicator());
      },
    );
  }

  getAndSetMessages() async {
    messageStream = await DatabaseMethods().getChatRoomMessages(chatRoomId);
    setState(() {});
  }

  colorsTo(name) async {
    List<Color> _colorList = [
      Colors.pink[400],
      Colors.pinkAccent,
      Colors.red[400],
      Colors.redAccent,
      Colors.deepOrange[400],
      Colors.deepOrangeAccent,
      Colors.orange[800],
      Colors.orangeAccent[700],
      Colors.amber[900],
      Colors.lime[800],
      Colors.lightGreen[700],
      Colors.green[600],
      Colors.teal[400],
      Colors.cyan[600],
      Colors.lightBlue[600],
      Colors.lightBlueAccent[700],
      Colors.blue[600],
      Colors.blueAccent,
      Colors.indigo[400],
      Colors.indigoAccent,
      Colors.purple[400],
      Colors.purpleAccent[400],
      Colors.deepPurple[400],
      Colors.deepPurpleAccent,
      Colors.blueGrey[400],
      Colors.brown[400],
      Colors.grey[600],
    ];

    var hash = name.hashCode;
    var index = hash % _colorList.length;
    setState(() {
      baseColorTo = _colorList[index];
    });
    print(index);
  }

  doThisOnLaunch() async {
    await getMyInfoFromSharedPreference();
    getAndSetMessages();
  }

  createPush(body, title, uid) async {
    var bodys = {
      'notification': {'body': '$body', 'title': '$title'},
      'priority': 'high',
      'data': {
        'clickaction': 'FLUTTERNOTIFICATIONCLICK',
        'id': '1',
        'status': 'done'
      },
      'to': '/topics/$uid'
    };
    print(jsonEncode(bodys));
    await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(bodys),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAQc6iwA8:APA91bFDBfxC7vLQS4KuepsgMvxVSZP3NTH4GA2B8hyDmiXbDK5PZGRTRqLbVrl2KQA7cbb-clFo99JCjIOWyKrgVZwvHFcRXmR0453CuIl1Arfvo57V0XmiUfXqjQHC49QHHXYfkQ9D',
        }).then((response) {
      if (response.statusCode == 201) {
        print(response.body);
      } else {
        throw Exception('Failed auth');
      }
    });
  }

  @override
  void initState() {
    configLocalNotification();
    init();
    colorsTo(name);
    doThisOnLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 249, 1),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: SizedBox(
            width: 45,
            height: 45,
            child: Stack(
              alignment: Alignment.center,
              children: [
                avatarsUser != null && avatarsUser != ''
                    ? Positioned(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: Container(
                            width: 45,
                            height: 45,
                            child: CachedNetworkImage(
                              imageUrl: avatarsUser,
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
                                color: Colors.grey[300].withOpacity(0.3),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                        ),
                      )
                    : Positioned(
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                              color: baseColorTo,
                              borderRadius: BorderRadius.circular(45)),
                          child: Center(
                            child: Text(
                              (surname != null || surname[0] != ''
                                      ? name[0] + surname[0]
                                      : name[0])
                                  .toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
              ],
            )),
      ),
      body: Container(
        child: Stack(
          children: [
            chatMessages(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.white.withOpacity(0.8),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: messageTextEdittingController,
                      // onChanged: (value) {
                      //   addMessage(false);
                      // },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "type a message",
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(0.6))),
                    )),
                    GestureDetector(
                      onTap: () {
                        addMessage(true);
                      },
                      child: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
