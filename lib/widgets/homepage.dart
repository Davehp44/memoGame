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

  StateAppLevel stateAppLevel = StateAppLevel.easy;
  int rows = 4;
  int columns = 4;
  late ButtonLevelSelect levelEasy;
  late ButtonLevelSelect levelMedium;
  late ButtonLevelSelect levelHard;
  Timer? _timer;
  int _start = 59;
  int pair = 0;
  int move = 0;

  @override
  void initState() {
    levelEasy = ButtonLevelSelect(
        _onPressLevel,
        easy,
        const Icon(Icons.earbuds_sharp),
        StateAppLevel.easy,
        ValueNotifier(true));
    levelMedium = ButtonLevelSelect(
        _onPressLevel,
        medium,
        const Icon(Icons.earbuds_battery_sharp),
        StateAppLevel.medium,
        ValueNotifier(false));
    levelHard = ButtonLevelSelect(
        _onPressLevel,
        hard,
        const Icon(Icons.edit_attributes_sharp),
        StateAppLevel.hard,
        ValueNotifier(false));
    super.initState();
  }

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
                        margin: const EdgeInsets.only(
                            top: 100, left: 40, right: 40, bottom: 100),
                      ),
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [levelEasy, levelMedium, levelHard],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          if (stateApp == StateApp.play)
            Flexible(
                flex: 5,
                child: Container(
                  color: Colors.black12,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Center(
                            child: Container(
                              child: Text(
                                "$_start",
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 20),
                              ),
                              margin: const EdgeInsets.all(10),
                            ),
                          )),
                      Expanded(
                          flex: 5,
                          child: Center(
                            child: GridView.count(
                              crossAxisCount: columns,
                              primary: false,
                              shrinkWrap: true,
                              children: List.generate(rows * columns, (index) {
                                return Center(
                                  child: _itemListNumber[index],
                                );
                              }),
                            ),
                          )),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: Container(
                              child: Text(
                                "Movimientos: $move",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.blueAccent),
                              ),
                              margin: const EdgeInsets.all(5),
                            ),
                          )),
                          Expanded(
                              child: Center(
                            child: Container(
                              child: Text(
                                "Parejas: $pair",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.blueAccent),
                              ),
                              margin: const EdgeInsets.all(5),
                            ),
                          )),
                        ],
                      )
                    ],
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
        rows * columns,
        _onPressItem,
      );
      for (var element in _itemListNumber) {
        element.state.value = StateItemListNumber.none;
      }
    });
    startTimer(_start = 59);
    pair = getPair(rows, columns);
    move = 0;
  }

  void _onPressHome() {
    setState(() {
      stateApp = StateApp.none;
    });
  }

  void _onPressLevel(StateAppLevel? st) {
    switch (st!) {
      case StateAppLevel.easy:
        levelMedium.isActive.value = false;
        levelHard.isActive.value = false;
        rows = 4;
        columns = 4;
        break;
      case StateAppLevel.medium:
        levelEasy.isActive.value = false;
        levelHard.isActive.value = false;
        rows = 5;
        columns = 4;
        break;
      case StateAppLevel.hard:
        levelEasy.isActive.value = false;
        levelMedium.isActive.value = false;
        rows = 6;
        columns = 5;
        break;
    }
    stateAppLevel = st;
  }

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
      setState(() {
        pair = pair - 1;
        move = move + 1;
      });
    } else if (item1 != null && item2 != null) {
      item1.state.value = StateItemListNumber.incorrect;
      item2.state.value = StateItemListNumber.incorrect;
      setState(() {
        move = move + 1;
      });
      Timer(const Duration(milliseconds: 500), () {
        item1?.state.value = StateItemListNumber.none;
        item2?.state.value = StateItemListNumber.none;
      });
    }

    if (pair == 0) {
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
    }
  }

  void startTimer(int t) {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          if (t < 1) {
            _start = 59;
            _onPressReset();
          } else {
            _start = t - 1;
            t = t - 1;
          }
        },
      ),
    );
  }
}
