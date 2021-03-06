import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kz/app_localizations.dart';
import 'package:kz/pages/phone/user/chat/screen_chat.dart';
import 'package:kz/pages/web/user/bookmarks/bookmarks.dart';
import 'package:kz/pages/web/user/creation/creation_application.dart';
import 'package:kz/pages/web/user/home/home_page.dart';
import 'package:kz/pages/web/user/profile/profile.dart';
import 'package:kz/tools/database/utility_database.dart';

class ChatTab extends StatefulWidget {
  static var routeName = '/messanger';

  ChatTab({Key key}) : super(key: key);

  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  Stream chatRoomsStream;
  String uid = FirebaseAuth.instance.currentUser.uid;

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("lastMessageSendTs", descending: true)
        .where("users", arrayContains: uid)
        .snapshots();
  }

  Widget chatRoomsList() {
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return ChatRoomListTile(ds["lastMessage"], ds.id, uid,
                      ds["lastMessageSendBy"], ds["lastMessageSendTs"]);
                })
            : Center(child: Text('Здесь будут ваши сообщения'));
      },
    );
  }

  init() async {
    chatRoomsStream = await getChatRooms();
    setState(() {});
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color.fromRGBO(255, 221, 97, 1),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(HomeWebPage.routeName),
              icon: Icon(
                Icons.home_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(WebBookmarksPage.routeName),
              icon: Icon(
                Icons.favorite_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () => Navigator.of(context)
                  .pushReplacementNamed(WebCreationApplication.routeName),
              icon: Icon(
                Icons.add_circle_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(ChatTab.routeName),
              icon: Icon(
                Icons.near_me_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed(WebProfilePage.routeName),
              icon: Icon(
                Icons.account_circle_rounded,
                color: Colors.black,
                size: 28,
              ),
            ),
          )
        ],
        title: Text(
          AppLocalizations.of(context).translate('h_chats'),
          style: TextStyle(
              color: Colors.black87,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              fontFamily: "Comfortaa"),
        ),
      ),
      body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15),
          child: chatRoomsList()),
    );
  }
}

class ChatRoomListTile extends StatefulWidget {
  final String lastMessage,
      chatRoomId,
      uid,
      lastMessageSendBy,
      lastMessageSendTs;
  ChatRoomListTile(this.lastMessage, this.chatRoomId, this.uid,
      this.lastMessageSendBy, this.lastMessageSendTs);

  @override
  _ChatRoomListTileState createState() => _ChatRoomListTileState();
}

class _ChatRoomListTileState extends State<ChatRoomListTile> {
  String uriImage, name, surname, username, fullname;
  Map<String, Color> contactsColorMap = new Map();
  var baseColor;

  getThisUserInfo() async {
    username = widget.chatRoomId.replaceAll(widget.uid, "").replaceAll("_", "");
    QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo(username);
    name = querySnapshot.docs[0]['name'] ?? '';
    surname = querySnapshot.docs[0]['surname'] ?? '';
    uriImage = querySnapshot.docs[0]['uriImage'] ?? null;
    setState(() {});
  }

  colors() async {
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
      baseColor = _colorList[index];
    });
  }

  @override
  void initState() {
    getThisUserInfo();
    colors();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatScreen(
                      username,
                    )));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: uriImage != null && uriImage != ''
                        ? Container(
                            height: 45,
                            width: 45,
                            child: CachedNetworkImage(
                              imageUrl: uriImage,
                              // cacheManager: DefaultCacheManager(),
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
                          )
                        : Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                                color: baseColor,
                                borderRadius: BorderRadius.circular(45)),
                            child: Center(
                              child: Text(
                                (surname != null
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
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surname != null ? name + ' ' + surname : name,
                        style: TextStyle(fontSize: 16),
                      ),
                      Container(
                        child: Row(
                          children: [
                            widget.lastMessageSendBy == widget.uid
                                ? Text(
                                    AppLocalizations.of(context)
                                        .translate('hint_chats_you'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  )
                                : SizedBox(),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                strutStyle: StrutStyle(fontSize: 12.0),
                                text: TextSpan(
                                    style: TextStyle(color: Colors.black),
                                    text: widget.lastMessage),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
