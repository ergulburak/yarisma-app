import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:yarisma_app/Entities/scoreHandler.dart';
import 'package:yarisma_app/Services/color.dart';
import 'package:yarisma_app/Services/dateUtils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Widgets/askQuestion.dart';
import 'package:yarisma_app/Entities/quiz.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Widgets/cooldownScreen.dart';

enum States { COMPETITION, HANDLER, NULL, COOLDOWN, END }

const int maxFailedLoadAttempts = 3;

class QuizHandler extends StatefulWidget {
  QuizHandler({
    required this.questionState,
    required this.stateInfo,
  });
  final DocumentReference questionState;
  final ValueChanged<String> stateInfo;
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
    quizLoad();
    super.initState();
    _createInterstitialAd();
  }

  void quizLoad() {
    widget.questionState.get().then((value) {
      if (value.exists) _quiz = Quiz.fromFirestore(value);
    });
  }

  @override
  void dispose() {
    _states = States.NULL;
    super.dispose();
    _interstitialAd?.dispose();
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
                  'weekScore': globals.scoreHandler!.point,
                  'lastWeek': globals.scoreHandler!.quizName
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
    _showInterstitialAd();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: 100),
        child: Column(
          children: [
            Container(
              height: globals.telefonHeight! * .45,
              width: globals.telefonWidth,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "TEBRİKLER",
                      style: _textStyle.apply(
                        fontSizeDelta: 20,
                        fontWeightDelta: 3,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      alignment: Alignment.center,
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: ExactAssetImage("assets/confetti@1x.png"),
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.bottomCenter),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      alignment: Alignment.center,
                      width: globals.telefonWidth,
                      height: 50,
                      duration: Duration(milliseconds: 100),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Doğru Sayısı: " +
                                globals.scoreHandler!.correctCount.toString(),
                            textAlign: TextAlign.center,
                            style: _textStyle.apply(
                              color: Colors.black,
                              fontSizeDelta: 3,
                              fontWeightDelta: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      alignment: Alignment.center,
                      width: globals.telefonWidth,
                      height: 50,
                      duration: Duration(milliseconds: 100),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Yanlış Sayısı: " +
                                globals.scoreHandler!.wrongCount.toString(),
                            textAlign: TextAlign.center,
                            style: _textStyle.apply(
                              color: Colors.black,
                              fontSizeDelta: 3,
                              fontWeightDelta: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: AnimatedContainer(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      alignment: Alignment.center,
                      width: globals.telefonWidth,
                      height: 50,
                      duration: Duration(milliseconds: 100),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Puan: " + globals.scoreHandler!.point.toString(),
                            textAlign: TextAlign.center,
                            style: _textStyle.apply(
                              color: Colors.black,
                              fontSizeDelta: 3,
                              fontWeightDelta: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-8337349993896228/3054411976",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Widget handler(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: widget.questionState.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              "Bağlantı hatası.",
              style: _textStyle,
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Align(
            alignment: Alignment.center,
            child: Text(
              "Aktif quiz bulunamadı.",
              style: _textStyle,
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.active) {
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
              quizLoad();
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
                              color: AppColors().allPointColor,
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
        }

        return Align(
          alignment: Alignment.center,
          child: Text(
            "Bağlantı kuruluyor.",
            style: _textStyle,
          ),
        );
      },
    );
  }
}
