import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yarisma_app/karsilama.dart';
import 'Services/sayfaYonlendirici.dart';
import 'Services/globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(BeklemeSayfasi());
}

class BeklemeSayfasi extends StatelessWidget {
  const BeklemeSayfasi({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      theme: ThemeData(bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent)),
      navigatorObservers: [BotToastNavigatorObserver()],
      home: new Scaffold(
        backgroundColor: Colors.transparent,
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  TextStyle _googleFonts = GoogleFonts.robotoMono(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal);

  @override
  Widget build(BuildContext context) {
    globals.telefonHeight = MediaQuery.of(context).size.height;
    globals.telefonWidth = MediaQuery.of(context).size.width;
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorPage();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Karsilama();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

Widget ErrorPage() {
  return Scaffold(
    appBar: AppBar(
      title: Text("Hata"),
    ),
    body: Center(
      child: Text("Bir şey oldu."),
    ),
  );
}

Widget Loading() {
  TextStyle _googleFonts = GoogleFonts.robotoMono(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal);
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Stack(
        children: [
          new FlareActor(
            "assets/Loading.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: 'Alarm',
          ),
        ],
      ),
    ),
  );
}
