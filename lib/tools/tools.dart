import 'dart:math';

import 'package:memogame/widgets/itemlistnumber.dart';

enum StateApp { play, none }

enum StateAppLevel { easy, medium, hard }

enum StateItemListNumber { complete, verify, none, incorrect }

List<ItemListNumber> shuffleItems(int count, Function() onPress) {
  int max = count ~/ 2;
  var numbers = [];
  for (var i = 0; i < max; i++) {
    numbers.add(Random().nextInt(1000));
  }
  List<ItemListNumber> items = [];
  List<ItemListNumber> aux = [];

  for (var i = 0; i < max; i++) {
    aux.add(ItemListNumber(onPress, numbers[i]));
    aux.add(ItemListNumber(onPress, numbers[i]));
  }
  items.clear();
  items.addAll(aux);
  return items.toList()..shuffle();
}

int getPair(int a, int b) {
  return (a * b) ~/ 2;
}
