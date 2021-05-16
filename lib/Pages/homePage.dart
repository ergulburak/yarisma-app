import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Pages/addQuestion.dart';
import 'package:yarisma_app/Pages/profile.dart';
import 'package:yarisma_app/Pages/quizHandler.dart';
import 'package:yarisma_app/Pages/userQuestions.dart';
import 'package:yarisma_app/Services/dateUtils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/hexToColor.dart';
import 'package:yarisma_app/Pages/panel.dart';
import '../Services/authServices.dart' as authServices;
import '../Services/globals.dart' as globals;

enum Screens { HOME, PROFIL, LEADERBOARD, PANEL, ADDQUESTION, MYQUESTIONS }

class HomePage extends StatefulWidget {
  HomePage({required this.auth});
  final FirebaseAuth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle _textStyle = AppFont().getAppFont();
  bool hamburgerCompetitionController = true;
  Screens screens = Screens.HOME;
  late UserData _userData;

  final formKey = GlobalKey<FormState>();
  final panelFormKey = GlobalKey<FormState>();

  CollectionReference pendingQuestions =
      FirebaseFirestore.instance.collection("pendingQuestions");

  DocumentReference questionState = FirebaseFirestore.instance
      .collection("quizzes")
      .doc(CustomDateUtils.currentWeek().toString() +
          "+" +
          DateTime.now().year.toString());
  DocumentReference userQuestion = FirebaseFirestore.instance
      .collection("users")
      .doc(globals.userCollectionID);
  DocumentReference users = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
    super.initState();
    setUserData();
  }

  setUserData() {
    if (globals.userData != null) _userData = globals.userData!;
  }

  void hamburgerController(String value) {
    if (value.contains("COMPETITION")) {
      hamburgerCompetitionController = false;
    } else if (value.contains("HANDLER")) {
      hamburgerCompetitionController = true;
    } else {
      hamburgerCompetitionController = true;
    }
  }

  sayfa(BuildContext context) {
    if (screens == Screens.HOME)
      return QuizHandler(
        questionState: questionState,
        stateInfo: hamburgerController,
        finish: _update,
      );
    else if (screens == Screens.PROFIL)
      return Profile(userData: _userData);
    else if (screens == Screens.LEADERBOARD)
      return leaderBoard(context);
    else if (screens == Screens.MYQUESTIONS)
      return UserQuestions(userQuestion: userQuestion);
    else if (screens == Screens.ADDQUESTION)
      return AddQuestion(setHome: _update);
    else if (screens == Screens.PANEL)
      return Panel(pendingQuestions: pendingQuestions);
  }

  void _update(Screens screen) {
    setState(() => screens = screen);
  }

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
                    screens != Screens.ADDQUESTION &&
                    screens != Screens.MYQUESTIONS &&
                    screens != Screens.PANEL)
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
                if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                    hamburgerCompetitionController)
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
                                      screens = Screens.PANEL;
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
                                      screens = Screens.ADDQUESTION;
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
                                      screens = Screens.MYQUESTIONS;
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
                                    screens = Screens.HOME;
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
                                    screens = Screens.PROFIL;
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
                                    screens = Screens.LEADERBOARD;
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
}
