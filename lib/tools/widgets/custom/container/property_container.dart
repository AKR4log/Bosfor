import 'package:flutter/material.dart';
import 'package:kz/tools/models/applications/property.dart';

class PropertyApplicationContainer extends StatefulWidget {
  final PropertyApplication application;
  PropertyApplicationContainer({Key key, this.application}) : super(key: key);

  @override
  _PropertyApplicationContainerState createState() =>
      _PropertyApplicationContainerState();
}

class _PropertyApplicationContainerState
    extends State<PropertyApplicationContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.application.uid_property),
    );
  }
}
