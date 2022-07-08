import 'package:flutter/material.dart';
import 'package:memogame/tools/tools.dart';

class ButtonLevelSelect extends StatefulWidget {
  Function(StateAppLevel st) onPress;
  String title;
  Icon icon;
  ValueNotifier<bool> isActive;
  StateAppLevel st;

  ButtonLevelSelect(this.onPress, this.title, this.icon, this.st, this.isActive,
      {Key? key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ButtonLevelSelectState();
  }
}

class _ButtonLevelSelectState extends State<ButtonLevelSelect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder(
          valueListenable: widget.isActive,
          builder: (context, value, child) {
            return FloatingActionButton.extended(
              onPressed: () {
                widget.isActive.value = true;
                widget.onPress.call(widget.st);
              },
              label: Text(widget.title),
              icon: widget.icon,
              backgroundColor:
                  (widget.isActive.value) ? Colors.blueAccent : Colors.black26,
            );
          }),
      margin: const EdgeInsets.all(10),
    );
  }
}
