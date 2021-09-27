import 'dart:async';
import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:yarisma_app/Services/color.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Widgets/questionOptionButton.dart';

class AskQuestion extends StatefulWidget {
  AskQuestion({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.point,
    required this.callback,
  });
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctOption;
  final int point;
  final ValueChanged<String> callback;

  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  TextStyle _textStyle = AppFont().getAppFont();
  late Timer _timer;

  List<bool> jokerOptionBool = <bool>[false, false, false, false];
  List<int> jokerList = <int>[];

  double standbyTime = 0.0;
  double questionWaitingTime = 500;
  static const oneSec = const Duration(seconds: 1);

  bool isJokerUsed = false;
  @override
  void initState() {
    jokerList.add(0);
    jokerList.add(1);
    jokerList.add(2);
    jokerList.add(3);
    jokerList.remove(widget.correctOption - 1);
    jokerList.shuffle();
    _timer = new Timer.periodic(oneSec, (timer) {
      if (standbyTime == questionWaitingTime) {
        setState(() {
          timer.cancel();
          _scoreHandler(false);
        });
      } else {
        setState(() {
          standbyTime++;
        });
      }
    });
    super.initState();
  }

  double normalizedNum(val, max, min) {
    val = val - min;
    max = max - min;
    return 1 - (math.max(0, math.min(1, val / max)));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _scoreHandler(bool isCorrect) {
    if (isCorrect) {
      globals.scoreHandler!.correctCount += 1;
      globals.scoreHandler!.point += widget.point;
    } else {
      globals.scoreHandler!.wrongCount += 1;
    }
    widget.callback("question");
  }

  void _useJoker() {
    isJokerUsed = true;
    jokerOptionBool[jokerList.first] = true;
    jokerList.remove(jokerList.first);
    jokerOptionBool[jokerList.first] = true;
    globals.userData!.joker--;
    FirebaseFirestore.instance
        .collection("users")
        .doc(globals.userCollectionID)
        .update({'joker': globals.userData!.joker})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 85),
      child: Container(
        width: globals.telefonWidth,
        height: globals.telefonHeight,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: [0.5, 1.0],
                      colors: [
                        Colors.blueAccent.shade400,
                        Colors.blueAccent.shade700,
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  alignment: Alignment.center,
                  width: globals.telefonWidth,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            widget.question,
                            textAlign: TextAlign.center,
                            style: _textStyle.apply(
                              color: AppColors().questionColor,
                              fontSizeDelta: 3,
                              fontWeightDelta: 2,
                            ),
                          ),
                        ),
                      ),
                      if (!isJokerUsed)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                            child: InkWell(
                              onTap: () {
                                if (globals.userData!.joker > 0) {
                                  setState(() {
                                    _useJoker();
                                  });
                                } else {
                                  BotToast.showText(
                                      text: "Yeterli joker hakkınız yok.");
                                }
                              },
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                      image: ExactAssetImage(
                                          "assets/joker@1x.png"),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.bottomCenter),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!jokerOptionBool[0])
                      QuestionOptionButton(
                        optionText: widget.optionA,
                        isCorrect: widget.correctOption == 1 ? true : false,
                        answer: _scoreHandler,
                      ),
                    if (!jokerOptionBool[1])
                      QuestionOptionButton(
                        optionText: widget.optionB,
                        isCorrect: widget.correctOption == 2 ? true : false,
                        answer: _scoreHandler,
                      ),
                    if (!jokerOptionBool[2])
                      QuestionOptionButton(
                        optionText: widget.optionC,
                        isCorrect: widget.correctOption == 3 ? true : false,
                        answer: _scoreHandler,
                      ),
                    if (!jokerOptionBool[3])
                      QuestionOptionButton(
                        optionText: widget.optionD,
                        isCorrect: widget.correctOption == 4 ? true : false,
                        answer: _scoreHandler,
                      ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LinearPercentIndicator(
                  lineHeight: 14.0,
                  percent: normalizedNum(standbyTime, questionWaitingTime, 0.0),
                  linearStrokeCap: LinearStrokeCap.butt,
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.all(0),
                  alignment: MainAxisAlignment.center,
                  progressColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
