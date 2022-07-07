import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memogame/tools/stringsvalues.dart';
import 'package:memogame/tools/tools.dart';
import 'package:memogame/widgets/button.dart';
import 'package:memogame/widgets/buttonNivelSelect.dart';
import 'package:memogame/widgets/itemlistnumber.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  StateApp stateApp = StateApp.none;
  List<ItemListNumber> _itemListNumber = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          if (stateApp == StateApp.none)
            Flexible(
                flex: 5,
                child: Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                            appName,
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 50),
                          ),
                        ),
                        margin: const EdgeInsets.all(30),
                      ),
                      Flexible(
                          child: ButtomNivel(_onPressNivel, reset,
                              const Icon(Icons.restart_alt), Colors.black26)),
                    ],
                  ),
                )),
          if (stateApp == StateApp.play)
            Flexible(
                flex: 5,
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: GridView.count(
                      crossAxisCount: 5,
                      children: List.generate(30, (index) {
                        return Center(
                          child: _itemListNumber[index],
                        );
                      }),
                    ),
                  ),
                )),
          Flexible(
              flex: 1,
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (stateApp == StateApp.none)
                      Flexible(
                          child: Buttom(_onPressPlay, play,
                              const Icon(Icons.play_arrow), Colors.blueAccent)),
                    if (stateApp == StateApp.play)
                      Flexible(
                          child: Buttom(
                              _onPressReset,
                              reset,
                              const Icon(Icons.restart_alt),
                              Colors.blueAccent)),
                    if (stateApp == StateApp.play)
                      const SizedBox(
                        width: 10,
                      ),
                    if (stateApp == StateApp.play)
                      Flexible(
                          child: Buttom(_onPressHome, home,
                              const Icon(Icons.home), Colors.blueAccent)),
                  ],
                ),
              )),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onPressPlay() {
    setState(() {
      stateApp = StateApp.play;
    });
    _onPressReset();
  }

  void _onPressReset() {
    setState(() {
      _itemListNumber = shuffleItems(
        30,
        _onPressItem,
      );
      for (var element in _itemListNumber) {
        element.state.value = StateItemListNumber.none;
      }
    });
  }

  void _onPressHome() {
    setState(() {
      stateApp = StateApp.none;
    });
  }

  void _onPressNivel() {}

  void _onPressItem() {
    ItemListNumber? item1;
    ItemListNumber? item2;
    for (var element in _itemListNumber) {
      if (element.state.value == StateItemListNumber.verify && item1 == null) {
        item1 = element;
      } else if (element.state.value == StateItemListNumber.verify &&
          item2 == null) {
        item2 = element;
        break;
      }
    }
    if (item1 != null && item2 != null && item1.number == item2.number) {
      item1.state.value = StateItemListNumber.complete;
      item2.state.value = StateItemListNumber.complete;
    } else if (item1 != null && item2 != null) {
      item1.state.value = StateItemListNumber.incorrect;
      item2.state.value = StateItemListNumber.incorrect;
      Timer(const Duration(milliseconds: 500), () {
        item1?.state.value = StateItemListNumber.none;
        item2?.state.value = StateItemListNumber.none;
      });
    }
  }
}
