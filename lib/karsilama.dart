import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yarisma_app/Services/authServices.dart';
import 'package:yarisma_app/home_page.dart';
import 'Services/hexToColor.dart' as HexColor;

class Karsilama extends StatefulWidget {
  @override
  _KarsilamaState createState() => _KarsilamaState();
}

class _KarsilamaState extends State<Karsilama> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // _handleStartScreen();
    FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
      if (firebaseUser == null) {
        print("Oturum kapalı");
        Future.delayed(const Duration(seconds: 2),
            () => Navigator.pushNamed(context, "/login"));
      } else {
        print(firebaseUser.displayName);
        Future.delayed(const Duration(seconds: 2),
            () => Navigator.pushNamed(context, "/home", arguments: _auth));
      }
    });
  }

  /*Future<void> _handleStartScreen() async {
    AuthService _auth = AuthService();
    if (await _auth.isLoggedIn()) {
      print("Oturum açık"+_auth.getUser()!);
      Future.delayed(const Duration(seconds: 2),
          () => Navigator.pushNamed(context, "/home"));
    } else {
      print("Oturum kapalı");
      Future.delayed(const Duration(seconds: 2),
          () => Navigator.pushNamed(context, "/login"));
    }
  }*/
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
                  "Manga Ship",
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
