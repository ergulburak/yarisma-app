import 'dart:convert';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Entities/quiz.dart';
import 'package:yarisma_app/Entities/user_data.dart';
import 'package:yarisma_app/Services/date_utils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/hexToColor.dart';
import 'Services/authServices.dart' as authServices;
import 'Services/globals.dart' as globals;
import 'package:yarisma_app/Services/date_utils.dart' as dataUtils;

enum Screens { HOME, PROFIL, LEADERBOARD, PANEL, ADDQUESTION, MYQUESTIONS }

class HomePage extends StatefulWidget {
  HomePage({required this.auth});
  final FirebaseAuth auth;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle _textStyle = AppFont().getAppFont();
  Screens _screens = Screens.HOME;
  late UserData _userData;

  final formKey = GlobalKey<FormState>();
  final panelFormKey = GlobalKey<FormState>();
  double _height = globals.telefonHeight! * 0.45;
  double _width = globals.telefonWidth! - 70;

  final _question = TextEditingController();
  final _optionA = TextEditingController();
  final _optionB = TextEditingController();
  final _optionC = TextEditingController();
  final _optionD = TextEditingController();
  final _correctOption = TextEditingController();
  final _point = TextEditingController();

  final _panelWeek = TextEditingController();
  final _panelYear = TextEditingController();

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  setUserData() {
    if (globals.userData != null) _userData = globals.userData!;
  }

  sayfa(BuildContext context) {
    if (_screens == Screens.HOME)
      return home(context);
    else if (_screens == Screens.PROFIL)
      return profil(context);
    else if (_screens == Screens.LEADERBOARD)
      return leaderBoard(context);
    else if (_screens == Screens.MYQUESTIONS)
      return myQuestions(context);
    else if (_screens == Screens.ADDQUESTION)
      return addQuestion(context);
    else if (_screens == Screens.PANEL) return panel(context);
  }

  DocumentReference users = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: users.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          globals.userData = new UserData.fromFirestore(snapshot.data!);
          setUserData();
        } else if (snapshot.hasError) {
          print("null geldi.");
        }
        return WillPopScope(
          onWillPop: () async => showDialog(
            context: context,
            builder: (c) => AlertDialog(
              title: Text('Uyarı'),
              content: Text('Uygulamayı kapatmak istediğine emin misin?'),
              actions: [
                TextButton(
                  child: Text('Evet'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
                TextButton(
                  child: Text('Hayır'),
                  onPressed: () => Navigator.pop(c, false),
                ),
              ],
            ),
          ).then((value) => value ?? false),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                FlareActor(
                  "assets/Cosmos.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  animation: 'idle',
                ),
                sayfa(context),
                if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                    _screens != Screens.ADDQUESTION &&
                    _screens != Screens.MYQUESTIONS &&
                    _screens != Screens.PANEL)
                  SafeArea(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        child: Container(
                          height: 80,
                          width: globals.telefonWidth,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  authServices.AuthService().getUser() ?? "---",
                                  style: _textStyle.apply(fontSizeDelta: 25),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("PUAN",
                                            style: _textStyle.apply(
                                                fontSizeDelta: -2)),
                                        Text(
                                          _userData.totalScore.toString(),
                                          style: _textStyle.apply(
                                            fontSizeDelta: 5,
                                            color:
                                                HexColor().getColor("#03fcc2"),
                                            shadows: [
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 5,
                                              ),
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 10,
                                              ),
                                              Shadow(
                                                color: Colors.black,
                                                offset: Offset(0, 0),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(),
                if (MediaQuery.of(context).viewInsets.bottom == 0)
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.black.withOpacity(.5),
                        ),
                        child: IconButton(
                          color: Colors.black,
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ),
                          alignment: Alignment.center,
                          iconSize: 40,
                          onPressed: () {
                            showAdaptiveActionSheet(
                              context: context,
                              actions: <BottomSheetAction>[
                                if (globals.userData!.rank == "admin")
                                  BottomSheetAction(
                                    title: Text(
                                      'Panel',
                                      style: _textStyle,
                                    ),
                                    onPressed: () {
                                      _screens = Screens.PANEL;
                                      setState(() {});
                                      Navigator.pop(context, false);
                                    },
                                    leading: const Icon(
                                      Icons.settings_applications_sharp,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (globals.userData!.rank == "moderator" ||
                                    globals.userData!.rank == "admin")
                                  BottomSheetAction(
                                    title: Text(
                                      'Soru Ekle',
                                      style: _textStyle,
                                    ),
                                    onPressed: () {
                                      _screens = Screens.ADDQUESTION;
                                      setState(() {});
                                      Navigator.pop(context, false);
                                    },
                                    leading: const Icon(
                                      Icons.add_box,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                if (globals.userData!.rank == "moderator" ||
                                    globals.userData!.rank == "admin")
                                  BottomSheetAction(
                                    title: Text(
                                      'Sorularım',
                                      style: _textStyle,
                                    ),
                                    onPressed: () {
                                      _screens = Screens.MYQUESTIONS;
                                      setState(() {});
                                      Navigator.pop(context, false);
                                    },
                                    leading: const Icon(
                                      Icons.search_outlined,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                BottomSheetAction(
                                  title: Text(
                                    'Anasayfa',
                                    style: _textStyle,
                                  ),
                                  onPressed: () {
                                    _screens = Screens.HOME;
                                    setState(() {});
                                    Navigator.pop(context, false);
                                  },
                                  leading: const Icon(
                                    Icons.home,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                BottomSheetAction(
                                  title: Text(
                                    'Profil',
                                    style: _textStyle,
                                  ),
                                  onPressed: () {
                                    _screens = Screens.PROFIL;
                                    setState(() {});
                                    Navigator.pop(context, false);
                                  },
                                  leading: const Icon(
                                    Icons.portrait,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                BottomSheetAction(
                                  title: Text(
                                    'Lider Tablosu',
                                    style: _textStyle,
                                  ),
                                  onPressed: () {
                                    _screens = Screens.LEADERBOARD;
                                    setState(() {});
                                    Navigator.pop(context, false);
                                  },
                                  leading: const Icon(
                                    Icons.leaderboard,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                BottomSheetAction(
                                  title: Text(
                                    'Çıkış Yap',
                                    style: _textStyle,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (c) => AlertDialog(
                                        title: Text('Uyarı'),
                                        content: Text(
                                            'Çıkış yapmak istediğine emin misin?'),
                                        actions: [
                                          TextButton(
                                            child: Text('Evet'),
                                            onPressed: () {
                                              authServices.AuthService()
                                                  .signOut();
                                              Navigator.pop(context, false);
                                              Navigator.pushNamed(
                                                  context, '/login');
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Hayır'),
                                            onPressed: () =>
                                                Navigator.pop(c, false),
                                          ),
                                        ],
                                      ),
                                    ).then((value) => value ?? false);
                                  },
                                  leading: const Icon(
                                    Icons.exit_to_app,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget leaderBoard(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight! / 2,
      child: FlareActor(
        "assets/success-1.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'verified',
        callback: (name) {
          if (name == "verified") {
            Navigator.pop(context, false);
          }
        },
      ),
    );
  }

  Widget trueAnswer(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight! / 2,
      child: FlareActor(
        "assets/success-1.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'verified',
        callback: (name) {
          if (name == "verified") {
            Navigator.pop(context, false);
          }
        },
      ),
    );
  }

  Widget falseAnswer(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight! / 2,
      child: FlareActor(
        "assets/success_error.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'go',
        callback: (name) {
          if (name == "go") {
            Navigator.pop(context, false);
          }
        },
      ),
    );
  }

  List weekNum() {
    List weekNumbers = <String>[];
    for (int i = 0; i < 53; i++) {
      if (i >= dataUtils.DateUtils.currentWeek())
        weekNumbers.add("Week " + i.toString());
    }
    return weekNumbers;
  }

  Widget panel(BuildContext context) {
    CollectionReference myQuestion =
        FirebaseFirestore.instance.collection("pendingQuestions");
    return StreamBuilder<QuerySnapshot>(
      stream: myQuestion.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Onay Bekleyen Sorular",
                      style: _textStyle.apply(fontSizeDelta: 10.0),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return panelQuestionForm(
                          snapshot.data!.docs[index].data()!['question'],
                          snapshot.data!.docs[index].data()!['optionA'],
                          snapshot.data!.docs[index].data()!['optionB'],
                          snapshot.data!.docs[index].data()!['optionC'],
                          snapshot.data!.docs[index].data()!['optionD'],
                          snapshot.data!.docs[index].data()!['correctOption'],
                          snapshot.data!.docs[index].data()!['point'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }

  bool imageQuestion = false;
  Color dogruColor = Colors.green;
  Color yanlisColor = Colors.red;
  Color aColor = Colors.white;
  Color bColor = Colors.white;
  Color cColor = Colors.white;
  Color dColor = Colors.white;
  bool aSikki = false;
  bool bSikki = false;
  bool cSikki = false;
  bool dSikki = false;

  Widget home(BuildContext context) {
    /*return Align(
      alignment: Alignment.center,
      child: Text("Şuanda yarışma yok.", style: _textStyle),
    );*/
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight,
      child: FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.scaleDown,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              imageQuestion
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      alignment: Alignment.center,
                      width: globals.telefonWidth,
                      height: globals.telefonWidth)
                  : Container(),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  width: globals.telefonWidth,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Türkiyenin başkenti neresidir?Türkiyenin başkenti neresidir?Türkiyenin başkenti neresidir?Türkiyenin başkenti neresidir?Türkiyenin başkenti neresidir?Türkiyenin başkenti neresidir?Türkiyenin başkenti neresidir?",
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
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (aSikki) {
                        aColor = dogruColor;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              trueAnswer(context),
                        );
                      } else {
                        aColor = yanlisColor;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              falseAnswer(context),
                        );
                      }

                      print("Çalıştı.");
                    });
                  },
                  child: AnimatedContainer(
                    decoration: BoxDecoration(
                      color: aColor,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    alignment: Alignment.centerLeft,
                    width: globals.telefonWidth,
                    height: 50,
                    duration: Duration(milliseconds: 100),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "A) Ankara",
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
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.centerLeft,
                  width: globals.telefonWidth,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "A) Ankara",
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
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.centerLeft,
                  width: globals.telefonWidth,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "A) Ankara",
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
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.centerLeft,
                  width: globals.telefonWidth,
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "A) Ankara",
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
      ),
    );
  }

  Widget profil(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 90, 20, 10),
          child: AnimatedContainer(
            alignment: Alignment.topLeft,
            duration: Duration(milliseconds: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: (globals.telefonWidth! / 100) * 70,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "50/50 Joker sayın: " + _userData.joker.toString(),
                          style: _textStyle.apply(
                            fontSizeDelta: 5,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 5,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: (globals.telefonWidth! / 100) * 50,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Giriş Bileti: " + _userData.tickets.toString(),
                          style: _textStyle.apply(
                            fontSizeDelta: 5,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 5,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        child: Column(
                          children: [
                            Text(
                              _userData.ticketAdCounter.toString() + "/3",
                              style: _textStyle.apply(fontSizeDelta: -5),
                            ),
                            Icon(Icons.add, color: Colors.white, size: 30),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: (globals.telefonWidth! / 100) * 70,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Toplam doğru: " +
                              _userData.allTrueAnswers.toString(),
                          style: _textStyle.apply(
                            fontSizeDelta: 5,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 5,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      width: (globals.telefonWidth! / 100) * 70,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Toplam yanlış: " +
                              _userData.allWrongAnswers.toString(),
                          style: _textStyle.apply(
                            fontSizeDelta: 5,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 5,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 10,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: Offset(0, 0),
                                blurRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addQuestion(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Soru Ekle",
                      style: _textStyle.apply(
                          color: Colors.white,
                          fontSizeDelta: 10,
                          fontWeightDelta: 2)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _question,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    validator: qValidator([
                      IsRequired(msg: "Soru giriniz"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "Soru giriniz",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _optionA,
                    keyboardType: TextInputType.emailAddress,
                    validator: qValidator([
                      IsRequired(msg: "A şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "A şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _optionB,
                    validator: qValidator([
                      IsRequired(msg: "B şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "B şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _optionC,
                    validator: qValidator([
                      IsRequired(msg: "C şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "C şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _optionD,
                    validator: qValidator([
                      IsRequired(msg: "D şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "D şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _correctOption,
                    validator: qValidator([
                      IsRequired(msg: "Doğru şık"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "Doğru şık",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _point,
                    validator: qValidator([
                      IsRequired(msg: "Puan"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "Puan",
                      labelStyle: _textStyle.apply(color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Question question = new Question(
                            question: _question.text,
                            optionA: _optionA.text,
                            optionB: _optionB.text,
                            optionC: _optionC.text,
                            optionD: _optionD.text,
                            correctOption: int.parse(_correctOption.text),
                            point: int.parse(_point.text));
                        CollectionReference pendingQuestions = FirebaseFirestore
                            .instance
                            .collection("pendingQuestions");
                        DocumentReference user = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        pendingQuestions.add(question.toJson()).then((value) =>
                            {
                              if (globals.userData!.questions != null)
                                {
                                  globals.userData!.questions!.add(question),
                                  user.update({
                                    'questions': json
                                        .encode(globals.userData!.questions!)
                                  })
                                }
                              else
                                {
                                  globals.userData!.questions = <Question>[],
                                  globals.userData!.questions!.add(question),
                                  user.update({
                                    'questions': json
                                        .encode(globals.userData!.questions!)
                                  })
                                }
                            });
                        _question.clear();
                        _optionA.clear();
                        _optionB.clear();
                        _optionC.clear();
                        _optionD.clear();
                        _correctOption.clear();
                        _point.clear();
                        _screens = Screens.MYQUESTIONS;
                        setState(() {});
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Ekle",
                          style: _textStyle.apply(
                              color: Colors.black, fontSizeDelta: 6),
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget myQuestions(BuildContext context) {
    DocumentReference myQuestion = FirebaseFirestore.instance
        .collection("users")
        .doc(globals.userCollectionID);
    return StreamBuilder<DocumentSnapshot>(
      stream: myQuestion.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Question> myQuest =
              Quiz.parseQuestion(snapshot.data!["questions"].toString());
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sorularım",
                      style: _textStyle.apply(fontSizeDelta: 10.0),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: myQuest.length,
                      itemBuilder: (context, index) {
                        return userQuestionForm(
                          myQuest[index].question,
                          myQuest[index].optionA,
                          myQuest[index].optionB,
                          myQuest[index].optionC,
                          myQuest[index].optionD,
                          myQuest[index].correctOption,
                          myQuest[index].point,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }

  Widget userQuestionForm(String question, String optionA, String optionB,
      String optionC, String optionD, int correctOption, int point) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: _width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                question,
                style: _textStyle.apply(color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "A) " + optionA,
                      style: _textStyle.apply(color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "B) " + optionB,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "C) " + optionC,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "D) " + optionD,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Doğru Cevap: " +
                            (correctOption == 1
                                ? "A"
                                : correctOption == 2
                                    ? "B"
                                    : correctOption == 3
                                        ? "C"
                                        : correctOption == 4
                                            ? "D"
                                            : "Hata"),
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Puan: " + point.toString(),
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
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

  Widget panelQuestionForm(String question, String optionA, String optionB,
      String optionC, String optionD, int correctOption, int point) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: _width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                question,
                style: _textStyle.apply(color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "A) " + optionA,
                      style: _textStyle.apply(color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "B) " + optionB,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "C) " + optionC,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "D) " + optionD,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Doğru Cevap: " +
                            (correctOption == 1
                                ? "A"
                                : correctOption == 2
                                    ? "B"
                                    : correctOption == 3
                                        ? "C"
                                        : correctOption == 4
                                            ? "D"
                                            : "Hata"),
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Puan: " + point.toString(),
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      hoverColor: Colors.black87,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: Text(
                              "Seçilen Soru",
                              style: _textStyle.apply(
                                  fontSizeDelta: 6, color: Colors.black),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Onayla'),
                                onPressed: () {
                                  if(panelFormKey.currentState!.validate()){
                                    print("Validate");
                                  }
                                },
                              ),
                              TextButton(
                                child: Text('Vazgeç'),
                                onPressed: () => Navigator.pop(c, false),
                              ),
                            ],
                            content: Stack(
                              children: <Widget>[
                                Form(
                                  key: panelFormKey,
                                  child: Container(
                                    width: _width,
                                    height: _height / 1.2,
                                    child: ListView(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            userQuestionForm(
                                              question,
                                              optionA,
                                              optionB,
                                              optionC,
                                              optionD,
                                              correctOption,
                                              point,
                                            ),
                                            TextFormField(
                                              controller: _panelWeek,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              validator: qValidator([
                                                IsRequired(
                                                    msg: "Hafta Numarası girmelisiniz."),
                                              ]),
                                              style: _textStyle.apply(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5)),
                                                labelText: "Hafta Numarası",
                                                labelStyle: _textStyle.apply(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                border: new OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              controller: _panelYear,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              validator: qValidator([
                                                IsRequired(
                                                    msg: "Yıl girmelisiniz."),
                                              ]),
                                              style: _textStyle.apply(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5)),
                                                labelText: "Yıl",
                                                labelStyle: _textStyle.apply(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                border: new OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.white,
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.greenAccent,
                            )),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Onayla",
                            style: _textStyle.apply(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 20,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () {},
                      hoverColor: Colors.black87,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Reddet",
                            style: _textStyle.apply(color: Colors.black),
                            textAlign: TextAlign.center,
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
}
