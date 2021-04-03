import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/hexToColor.dart';
import 'Services/authServices.dart' as authServices;
import 'Services/globals.dart' as globals;

enum Screens { HOME, PROFIL, LEADERBOARD }

class HomePage extends StatefulWidget {
  HomePage({required this.auth});
  final FirebaseAuth auth;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle _textStyle = AppFont().getAppFont();
  Screens _screens = Screens.HOME;
  @override
  void initState() {
    super.initState();
  }

  sayfa(BuildContext context) {
    if (_screens == Screens.HOME)
      return home(context);
    else if (_screens == Screens.PROFIL)
      return profil(context);
    else if (_screens == Screens.LEADERBOARD) return leaderBoard(context);
  }

  @override
  Widget build(BuildContext context) {
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("PUAN",
                                      style:
                                          _textStyle.apply(fontSizeDelta: -2)),
                                  Text(
                                    "999",
                                    style: _textStyle.apply(
                                      fontSizeDelta: 5,
                                      color: HexColor().getColor("#03fcc2"),
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
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  iconSize: 40,
                  onPressed: () {
                    showAdaptiveActionSheet(
                      context: context,
                      title: const Text('Title'),
                      actions: <BottomSheetAction>[
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
                                content:
                                    Text('Çıkış yapmak istediğine emin misin?'),
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
            sayfa(context),
          ],
        ),
      ),
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
            Navigator.pop(context,false);
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
            Navigator.pop(context,false);
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
            Navigator.pop(context,false);
          }
        },
      ),
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
                          "50/50 Joker sayın: 0",
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
                          "Giriş Bileti: 0",
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
                              "0/3",
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
                          "Toplam doğru: 0",
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
                          "Toplam yanlış: 0",
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
}
