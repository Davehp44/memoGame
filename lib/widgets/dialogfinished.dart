import 'package:flutter/material.dart';
import 'package:memogame/tools/stringsvalues.dart';
import 'package:memogame/tools/tools.dart';

class DialogFinish extends StatelessWidget {
  StateGameFinished stateGameFinishedFinish;

  DialogFinish(this.stateGameFinishedFinish, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 1,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              (stateGameFinishedFinish == StateGameFinished.success)
                  ? congratulation
                  : failGame,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: (stateGameFinishedFinish == StateGameFinished.success)
                      ? Colors.blueAccent
                      : Colors.redAccent),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
