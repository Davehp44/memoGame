import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memogame/tools/tools.dart';

class ItemListNumber extends StatefulWidget {
  Function() onPress;
  int number;
  StateItemListNumber state = StateItemListNumber.none;

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
        setState(() {
          if (widget.state == StateItemListNumber.none) {
            widget.state = StateItemListNumber.verify;
            Timer(const Duration(milliseconds: 200), () async {
              print("verify");
              widget.state = await widget.onPress.call();
            });
          }
        });
      },
      child: Stack(
        children: [
          if (widget.state == StateItemListNumber.complete)
            Container(
              color: Colors.green,
              margin: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  widget.number.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          if (widget.state == StateItemListNumber.incorrect)
            Container(
              color: Colors.red,
              margin: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  widget.number.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          if (widget.state == StateItemListNumber.verify)
            Container(
              color: Colors.black38,
              margin: const EdgeInsets.all(10),
              child: Center(
                child: Text(
                  widget.number.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          if (widget.state == StateItemListNumber.none)
            Container(
              color: Colors.black38,
              margin: const EdgeInsets.all(10),
            )
        ],
      ),
    );
  }
}
