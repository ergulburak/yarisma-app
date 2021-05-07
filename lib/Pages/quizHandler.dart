import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/date_utils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/hexToColor.dart';

enum States { COMPETITION, MAIN, NULL }

class QuizHandler extends StatefulWidget {
  QuizHandler({required this.questionState});
  final DocumentReference questionState;
  @override
  _QuizHandlerState createState() => _QuizHandlerState();
}

class _QuizHandlerState extends State<QuizHandler> {
  TextStyle _textStyle = AppFont().getAppFont();

  States _states = States.MAIN;

  manager(BuildContext context) {
    if (_states == States.MAIN)
      return main(context); //home(context); düzenlenecek
    else if (_states == States.COMPETITION) return main(context);
  }

  @override
  Widget build(BuildContext context) {
    return manager(context);
  }

  Widget main(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.questionState.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!['state'] == "completed") {
            return Align(
              alignment: Alignment.center,
              child: InkWell(
                child: Stack(
                  children: [
                    FlareActor(
                      "assets/Loading.flr",
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: 'Alarm',
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Başla",
                        style: _textStyle.apply(
                          color: HexColor().getColor("#03fcc2"),
                          fontSizeDelta: 15,
                          fontWeightDelta: 2,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 0),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  print("bastın");
                },
              ),
            );
          } else {
            return Align(
              alignment: Alignment.center,
              child: Text(
                "Aktif quiz bulunmamaktadır.",
                style: _textStyle,
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
