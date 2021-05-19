import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/market.dart';
import 'package:kz/tools/models/applications/transport.dart';

class TransportApplicationContainer extends StatefulWidget {
  final TransportApplication application;
  TransportApplicationContainer({Key key, this.application}) : super(key: key);

  @override
  _TransportApplicationContainerState createState() =>
      _TransportApplicationContainerState();
}

class _TransportApplicationContainerState
    extends State<TransportApplicationContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.application.a_uid_application),
    );
  }
}
