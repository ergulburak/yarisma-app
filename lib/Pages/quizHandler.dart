import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Entities/scoreHandler.dart';
import 'package:yarisma_app/Services/dateUtils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/hexToColor.dart';
import 'package:yarisma_app/Widgets/askQuestion.dart';
import 'package:yarisma_app/Entities/quiz.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Widgets/cooldownScreen.dart';
import 'package:yarisma_app/Pages/homePage.dart';

enum States { COMPETITION, HANDLER, NULL, COOLDOWN, END }

class QuizHandler extends StatefulWidget {
  QuizHandler({
    required this.questionState,
    required this.stateInfo,
    required this.finish,
  });
  final DocumentReference questionState;
  final ValueChanged<String> stateInfo;
  final ValueChanged<Screens> finish;
  @override
  _QuizHandlerState createState() => _QuizHandlerState();
}

class _QuizHandlerState extends State<QuizHandler> {
  TextStyle _textStyle = AppFont().getAppFont();
  late Quiz _quiz;
  States _states = States.HANDLER;

  manager(BuildContext context) {
    if (_states == States.HANDLER) {
      widget.stateInfo("HANDLER");
      return handler(context);
    } else if (_states == States.COMPETITION) {
      widget.stateInfo("COMPETITION");
      return askQuestion(context);
    } else if (_states == States.COOLDOWN) {
      widget.stateInfo("COMPETITION");
      return CooldownScreen(callback: whenTheTaskIsOver);
    } else if (_states == States.END) {
      widget.stateInfo("HANDLER");
      return end(context);
    } else if (_states == States.NULL) {
      widget.stateInfo("HANDLER");
      return Container();
    }
  }

  @override
  void initState() {
    _states = States.HANDLER;
    widget.questionState
        .get()
        .then((value) => _quiz = Quiz.fromFirestore(value));
    super.initState();
  }

  @override
  void dispose() {
    _states = States.NULL;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return manager(context);
  }

  whenTheTaskIsOver(String task) {
    if (task.contains("question")) {
      setState(() {
        _states = States.COOLDOWN;
        if (_quiz.questions.length > 1) {
          _quiz.questions.remove(_quiz.questions.first);
        } else {
          globals.userData!.scoreHandler!.forEach((element) {
            if (element.quizName.contains(globals.scoreHandler!.quizName)) {
              element.correctCount = globals.scoreHandler!.correctCount;
              element.wrongCount = globals.scoreHandler!.wrongCount;
              element.point = globals.scoreHandler!.point;
            }
          });
          globals.userData!.tickets--;
          globals.userData!.totalScore += globals.scoreHandler!.point;
          globals.userData!.allTrueAnswers +=
              globals.scoreHandler!.correctCount;
          globals.userData!.allWrongAnswers += globals.scoreHandler!.wrongCount;
          setState(() {
            FirebaseFirestore.instance
                .collection("users")
                .doc(globals.userCollectionID)
                .update({
                  'scoreHandler': json.encode(globals.userData!.scoreHandler),
                  'tickets': globals.userData!.tickets,
                  'totalScore': globals.userData!.totalScore,
                  'allTrueAnswers': globals.userData!.allTrueAnswers,
                  'allWrongAnswers': globals.userData!.allWrongAnswers,
                })
                .then((value) => print("User Updated"))
                .catchError((error) => print("Failed to update user: $error"));
            _states = States.END;
          });
        }
      });
    } else if (task.contains("cooldown")) {
      setState(() {
        _states = States.COMPETITION;
      });
    } else {}
  }

  Widget askQuestion(BuildContext context) {
    return AskQuestion(
      question: _quiz.questions.first.question,
      optionA: _quiz.questions.first.optionA,
      optionB: _quiz.questions.first.optionB,
      optionC: _quiz.questions.first.optionC,
      optionD: _quiz.questions.first.optionD,
      correctOption: _quiz.questions.first.correctOption,
      point: _quiz.questions.first.point,
      callback: whenTheTaskIsOver,
    );
  }

  Widget end(BuildContext context) {
    Timer(Duration(seconds: 5), () => widget.finish(Screens.LEADERBOARD));
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: globals.telefonHeight! * .5,
        width: globals.telefonWidth! - 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        alignment: Alignment.center,
        child: Container(
          width: globals.telefonWidth! * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Sonuç",
                    style: _textStyle.apply(
                      fontSizeDelta: 20,
                      fontWeightDelta: 3,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Doğru Sayısı: " +
                        globals.scoreHandler!.correctCount.toString(),
                    style: _textStyle.apply(
                      fontSizeDelta: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Yanlış Sayısı: " +
                        globals.scoreHandler!.wrongCount.toString(),
                    style: _textStyle.apply(
                      fontSizeDelta: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Puan: " + globals.scoreHandler!.point.toString(),
                    style: _textStyle.apply(
                      fontSizeDelta: 30,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget handler(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.questionState.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          bool isEnter = false;
          if (globals.userData!.scoreHandler == null) {
          } else {
            globals.userData!.scoreHandler!.forEach((element) {
              if (element.quizName.contains(
                  CustomDateUtils.currentWeek().toString() +
                      "+" +
                      DateTime.now().year.toString())) {
                isEnter = true;
              }
            });
          }
          if (!isEnter) {
            if (globals.userData!.tickets > 0) {
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
                      setState(() {
                        globals.scoreHandler = new ScoreHandler(
                          quizName: CustomDateUtils.currentWeek().toString() +
                              "+" +
                              DateTime.now().year.toString(),
                          correctCount: 0,
                          wrongCount: 0,
                          point: 0,
                        );
                        _states = States.COMPETITION;
                      });
                      if (globals.userData!.scoreHandler == null) {
                        globals.userData!.scoreHandler = <ScoreHandler>[];
                      }
                      globals.userData!.scoreHandler!
                          .add(globals.scoreHandler!);

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(globals.userCollectionID)
                          .update({
                            'scoreHandler':
                                json.encode(globals.userData!.scoreHandler),
                          })
                          .then((value) => print("User Updated"))
                          .catchError((error) =>
                              print("Failed to update user: $error"));
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
              return Align(
                alignment: Alignment.center,
                child: Text(
                  "Yeterli bilet yok.(Profil sekmesinde '+' butonuna basarak reklam karşılığı bilet kazanılır.)",
                  style: _textStyle,
                ),
              );
            }
          } else {
            return Align(
              alignment: Alignment.center,
              child: Text(
                "Bu haftanın quizine katıldınız.",
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
