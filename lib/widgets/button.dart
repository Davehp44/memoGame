import 'package:flutter/material.dart';

class Buttom extends StatefulWidget {
  Function() onPress;
  String title;
  Icon icon;
  Color color;

  Buttom(this.onPress, this.title, this.icon, this.color, {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtomState();
  }
}

class _ButtomState extends State<Buttom> {
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
