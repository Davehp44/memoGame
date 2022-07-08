import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memogame/tools/tools.dart';

class ItemListNumber extends StatefulWidget {
  Function() onPress;
  int number;
  ValueNotifier<StateItemListNumber> state =
      ValueNotifier(StateItemListNumber.none);

  ItemListNumber(this.onPress, this.number, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ItemListNumber();
  }
}

class _ItemListNumber extends State<ItemListNumber> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.state.value == StateItemListNumber.none) {
          widget.state.value = StateItemListNumber.verify;
          Timer(const Duration(milliseconds: 200), () {
            widget.onPress.call();
          });
        }
      },
      child: ValueListenableBuilder(
          valueListenable: widget.state,
          builder: (context, value, child) {
            Widget item;
            if (widget.state.value == StateItemListNumber.complete) {
              item = Container(
                color: Colors.green,
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    widget.number.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            } else if (widget.state.value == StateItemListNumber.incorrect) {
              item = Container(
                color: Colors.red,
                margin: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    widget.number.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            } else if (widget.state.value == StateItemListNumber.verify) {
              item = Container(
                color: Colors.black38,
                margin: const EdgeInsets.all(5),
                child: Center(
                  child: Text(
                    widget.number.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              );
            } else {
              item = Container(
                color: Colors.black38,
                margin: const EdgeInsets.all(5),
              );
            }

            return item;
          }),
    );
  }
}
