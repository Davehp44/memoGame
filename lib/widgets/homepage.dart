import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:memogame/tools/stringsValues.dart';
import 'package:memogame/tools/tools.dart';
import 'package:memogame/widgets/button.dart';
import 'package:memogame/widgets/itemListNumber.dart';

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
                flex: 3,
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: Text(appName),
                  ),
                )),
          if (stateApp == StateApp.play)
            Flexible(
                flex: 3,
                child: Container(
                  color: Colors.black12,
                  child: Center(
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(12, (index) {
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
        12,
        _onPressItem,
      );
      for (var element in _itemListNumber) {
        element.state = StateItemListNumber.none;
      }
    });
  }

  void _onPressHome() {
    setState(() {
      stateApp = StateApp.none;
    });
  }

  StateItemListNumber _onPressItem() {
    ItemListNumber? item1;
    ItemListNumber? item2;
    for (var element in _itemListNumber) {
      if (element.state == StateItemListNumber.verify && item1 == null) {
        item1 = element;
      } else if (element.state == StateItemListNumber.verify && item2 == null) {
        item2 = element;
        break;
      }
    }

    StateItemListNumber s = StateItemListNumber.verify;
    setState(() {
      if (item1 != null && item2 != null && item1.number == item2.number) {
        item1.state = StateItemListNumber.complete;
        item2.state = StateItemListNumber.complete;
        print(s.name);
        s = StateItemListNumber.complete;
      } else if (item1 != null && item2 != null) {
        item1.state = StateItemListNumber.incorrect;
        item2.state = StateItemListNumber.incorrect;
        s = StateItemListNumber.incorrect;
        print(s.name);
        // Timer(const Duration(seconds: 1), () {
        //   item1?.state = StateItemListNumber.none;
        //   item2?.state = StateItemListNumber.none;
        //   print("reset to none");
        // });
      }
    });

    return s;
  }
}
