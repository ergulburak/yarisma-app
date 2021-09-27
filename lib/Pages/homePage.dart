import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Pages/addQuestion.dart';
import 'package:yarisma_app/Pages/leaderboardPage.dart';
import 'package:yarisma_app/Pages/profile.dart';
import 'package:yarisma_app/Pages/quizHandler.dart';
import 'package:yarisma_app/Pages/userQuestions.dart';
import 'package:yarisma_app/Services/color.dart';
import 'package:yarisma_app/Services/dateUtils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Pages/panel.dart';
import 'package:yarisma_app/Widgets/infoPillSheet.dart';
import '../Services/authServices.dart' as authServices;
import '../Services/globals.dart' as globals;

enum Screens { HOME, LEADERBOARD, PROFIL, ADDQUESTION, MYQUESTIONS, PANEL }

class HomePage extends StatefulWidget {
  HomePage({required this.auth});
  final FirebaseAuth auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle _textStyle = AppFont().getAppFont();
  bool navbarCompetitionController = true;
  Screens screens = Screens.HOME;
  late UserData _userData;
  late String title;

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

  Future<QuerySnapshot<Map<String, dynamic>>> leaderboardWeekPoints =
      FirebaseFirestore.instance
          .collection("users")
          .where("lastWeek",
              isEqualTo: (CustomDateUtils.currentWeek() - 1).toString() +
                  "+" +
                  DateTime.now().year.toString())
          .orderBy("weekScore", descending: true)
          .limit(10)
          .get();

  Future<QuerySnapshot<Map<String, dynamic>>> leaderboardTotalPoints =
      FirebaseFirestore.instance
          .collection("users")
          .orderBy("totalScore", descending: true)
          .limit(10)
          .get();

  @override
  void initState() {
    title = "Home";
    super.initState();
    setUserData();
  }

  setUserData() {
    if (globals.userData != null) _userData = globals.userData!;
  }

  void navbarController(String value) {
    if (value.contains("COMPETITION")) {
      navbarCompetitionController = false;
    } else if (value.contains("HANDLER")) {
      navbarCompetitionController = true;
    } else {
      navbarCompetitionController = true;
    }
  }

  sayfa(BuildContext context) {
    if (screens == Screens.HOME)
      return QuizHandler(
        questionState: questionState,
        stateInfo: navbarController,
      );
    else if (screens == Screens.PROFIL)
      return Profile(userData: _userData);
    else if (screens == Screens.LEADERBOARD)
      return Leaderboard(
        leaderboardTotalPoints: leaderboardTotalPoints,
        leaderboardWeekPoints: leaderboardWeekPoints,
      );
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

  void _handleIndexChanged(int i) {
    setState(() {
      screens = Screens.values[i];
    });
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
        return navbarCompetitionController
            ? navbarOpen(context)
            : navbarClose(context);
      },
    );
  }

  Widget navbarOpen(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Uyarı'),
          content: Text('Çıkış yapmak istediğine emin misin?'),
          actions: [
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                authServices.AuthService().signOut();
                Navigator.pop(context, false);
                Navigator.pushNamed(context, '/login');
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
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: EdgeInsets.all(0),
          child: DotNavigationBar(
            currentIndex: Screens.values.indexOf(screens),
            marginR: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            paddingR: const EdgeInsets.only(bottom: 0, top: 0),
            dotIndicatorColor: Colors.blue,
            onTap: _handleIndexChanged,
            items: [
              /// Home
              DotNavigationBarItem(
                icon: Icon(Icons.home),
                selectedColor: Colors.greenAccent[600],
              ),

              /// Leaderboard
              DotNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                selectedColor: Colors.pink[600],
              ),

              /// Profile
              DotNavigationBarItem(
                icon: Icon(Icons.person),
                selectedColor: Colors.orange[600],
              ),

              /// Add Question
              if (globals.userData!.rank == "admin" ||
                  globals.userData!.rank == "moderator")
                DotNavigationBarItem(
                  icon: Icon(Icons.add),
                  selectedColor: Colors.blue[600],
                ),

              /// My Question
              if (globals.userData!.rank == "admin" ||
                  globals.userData!.rank == "moderator")
                DotNavigationBarItem(
                  icon: Icon(Icons.search),
                  selectedColor: Colors.blue[600],
                ),

              /// Panel
              if (globals.userData!.rank == "admin")
                DotNavigationBarItem(
                  icon: Icon(Icons.settings),
                  selectedColor: Colors.blue[600],
                ),
            ],
          ),
        ),
        body: Stack(
          children: [
            sayfa(context),
            if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                screens != Screens.ADDQUESTION &&
                screens != Screens.MYQUESTIONS &&
                screens != Screens.PANEL)
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 110,
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
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    authServices.AuthService().getUser() ??
                                        "---",
                                    style: _textStyle.apply(
                                        fontSizeDelta: 25, color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 2, 10),
                                      child: InfoPillSheet(
                                        userData: _userData.tickets.toString(),
                                        textStyle: _textStyle,
                                        icon: Icons.local_offer_outlined,
                                        color: AppColors().pillColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 2, 10),
                                      child: InfoPillSheet(
                                        userData: _userData.joker.toString(),
                                        textStyle: _textStyle,
                                        icon: Icons.local_attraction_outlined,
                                        color: AppColors().pillColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "PUAN",
                                      style:
                                          _textStyle.apply(color: Colors.white),
                                    ),
                                    Text(
                                      _userData.totalScore.toString(),
                                      style: _textStyle.apply(
                                        fontSizeDelta: 5,
                                        color: AppColors().allPointColor,
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
          ],
        ),
      ),
    );
  }

  Widget navbarClose(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: Text('Uyarı'),
          content: Text('Çıkış yapmak istediğine emin misin?'),
          actions: [
            TextButton(
              child: Text('Evet'),
              onPressed: () {
                authServices.AuthService().signOut();
                Navigator.pop(context, false);
                Navigator.pushNamed(context, '/login');
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
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            sayfa(context),
            if (MediaQuery.of(context).viewInsets.bottom == 0 &&
                screens != Screens.ADDQUESTION &&
                screens != Screens.MYQUESTIONS &&
                screens != Screens.LEADERBOARD &&
                screens != Screens.PANEL)
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 110,
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
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    authServices.AuthService().getUser() ??
                                        "---",
                                    style: _textStyle.apply(
                                        fontSizeDelta: 25, color: Colors.white),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 2, 10),
                                      child: InfoPillSheet(
                                        userData: _userData.tickets.toString(),
                                        textStyle: _textStyle,
                                        icon: Icons.local_offer_outlined,
                                        color: AppColors().pillColor,
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 2, 2, 10),
                                      child: InfoPillSheet(
                                        userData: _userData.joker.toString(),
                                        textStyle: _textStyle,
                                        icon: Icons.local_attraction_outlined,
                                        color: AppColors().pillColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Container(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "PUAN",
                                      style:
                                          _textStyle.apply(color: Colors.white),
                                    ),
                                    Text(
                                      _userData.totalScore.toString(),
                                      style: _textStyle.apply(
                                        fontSizeDelta: 5,
                                        color: AppColors().allPointColor,
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
          ],
        ),
      ),
    );
  }
}
