import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Pages/homePage.dart';
import 'package:yarisma_app/Pages/login.dart';

import '../main.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => BeklemeSayfasi());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginEkrani());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomePage(auth: args as FirebaseAuth,));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Hata"),
        ),
        body: Center(
          child: Text("Bir şey oldu."),
        ),
      );
    });
  }
}
