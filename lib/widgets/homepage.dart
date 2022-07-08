import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:memogame/tools/stringsvalues.dart';
import 'package:memogame/tools/tools.dart';
import 'package:memogame/widgets/button.dart';
import 'package:memogame/widgets/buttonNivelSelect.dart';
import 'package:memogame/widgets/dialogfinished.dart';
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
  late ConfettiController _controllerBottomCenter;
  late DialogFinish dialogFinish;

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
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    dialogFinish = DialogFinish(StateGameFinished.success);
    super.initState();
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(
            children: [
              if (stateApp == StateApp.none)
                Flexible(
                    flex: 5,
                    child: Container(
                      color: Colors.black12,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 100, left: 40, right: 40, bottom: 100),
                            child: Center(
                              child: Text(
                                appName,
                                style: const TextStyle(
                                    color: Colors.blueAccent, fontSize: 50),
                              ),
                            ),
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
                                  margin: const EdgeInsets.all(10),
                                  child: Text(
                                    "$_start",
                                    style: const TextStyle(
                                        color: Colors.blueAccent, fontSize: 20),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 5,
                              child: Center(
                                child: GridView.count(
                                  crossAxisCount: columns,
                                  primary: false,
                                  shrinkWrap: true,
                                  children:
                                      List.generate(rows * columns, (index) {
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
                                  margin: const EdgeInsets.all(5),
                                  child: Text(
                                    "$moves$move",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blueAccent),
                                  ),
                                ),
                              )),
                              Expanded(
                                  child: Center(
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  child: Text(
                                    "$countPair$pair",
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.blueAccent),
                                  ),
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
                              child: Buttom(
                                  _onPressPlay,
                                  play,
                                  const Icon(Icons.play_arrow),
                                  Colors.blueAccent)),
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
          ),
          if (isFinished) dialogFinish,
          Align(
            alignment: Alignment.bottomCenter,
            child: ConfettiWidget(
              confettiController: _controllerBottomCenter,
              blastDirection: -pi / 2,
              emissionFrequency: 0.01,
              numberOfParticles: 20,
              maxBlastForce: 100,
              shouldLoop: false,
              minBlastForce: 80,
              gravity: 0.3,
            ),
          ),
        ],
      )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _onPressPlay() {
    setState(() {
      stateApp = StateApp.play;
      _onPressReset();
    });
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
      startTimer(_start = 59);
      pair = getPair(rows, columns);
      move = 0;
      _controllerBottomCenter.stop();
      isFinished = false;
    });
  }

  void _onPressHome() {
    setState(() {
      stateApp = StateApp.none;
      _controllerBottomCenter.stop();
      isFinished = false;
      if (_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
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
      _controllerBottomCenter.play();
      dialogFinish.stateGameFinishedFinish = StateGameFinished.success;
      isFinished = true;
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
            _start = 0;
            dialogFinish.stateGameFinishedFinish = StateGameFinished.fail;
            isFinished = true;
            _timer!.cancel();
            _timer = null;
          } else {
            _start = t - 1;
            t = t - 1;
          }
        },
      ),
    );
  }
}
