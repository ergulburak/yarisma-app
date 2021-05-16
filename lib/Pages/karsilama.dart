import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yarisma_app/Entities/scoreHandler.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Services/dateUtils.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

class Karsilama extends StatefulWidget {
  @override
  _KarsilamaState createState() => _KarsilamaState();
}

class _KarsilamaState extends State<Karsilama> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    globals.scoreHandler = new ScoreHandler(
      quizName: CustomDateUtils.currentWeek().toString() +
          "+" +
          DateTime.now().year.toString(),
      correctCount: 0,
      wrongCount: 0,
      point: 0,
    );
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        print("Oturum kapalı");
        Future.delayed(const Duration(seconds: 2),
            () => Navigator.pushNamed(context, "/login"));
      } else {
        print(firebaseUser.uid);
        DocumentReference user = FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid);
        user.get().then((value) => {
              if (value.exists)
                {
                  globals.userData = new UserData.fromJson(value.data()!),
                  globals.userCollectionID = firebaseUser.uid,
                  Future.delayed(
                      const Duration(seconds: 2),
                      () => Navigator.pushNamed(context, "/home",
                          arguments: _auth))
                }
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Quiz Ship",
                  style: _googleFonts.apply(fontSizeDelta: 30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
