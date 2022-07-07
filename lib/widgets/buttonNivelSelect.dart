import 'package:flutter/material.dart';

class ButtomNivel extends StatefulWidget {
  Function() onPress;
  String title;
  Icon icon;
  Color color;

  ButtomNivel(this.onPress, this.title, this.icon, this.color, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtomNivelState();
  }
}

class _ButtomNivelState extends State<ButtomNivel> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: widget.onPress,
      label: Text(widget.title),
      icon: widget.icon,
      backgroundColor: widget.color,
    );
  }
}
