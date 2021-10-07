import 'dart:ui';
import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:queen_validators/queen_validators.dart';
import '../Services/globals.dart' as globals;
import '../Services/authServices.dart' as authServices;
import 'dart:async';

enum AuthMode { LOGIN, KAYIT, SIFREYENILEME, LOADING }

class LoginEkrani extends StatefulWidget {
  @override
  _LoginEkraniState createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {
  TextStyle _googleFonts = GoogleFonts.robotoMono(
      color: Colors.white, fontSize: 17, fontWeight: FontWeight.normal);
  AuthMode _authMode = AuthMode.LOGIN;
  double _height = globals.telefonHeight! * 0.45;
  double _width = globals.telefonWidth! - 70;
  double _borderCircle = 40.0;
  bool _isSignIn = false;
  final _emailLogin = TextEditingController();
  final _passwordLogin = TextEditingController();

  final _emailKayit = TextEditingController();
  final _passwordKayit = TextEditingController();
  final _adSoyadKayit = TextEditingController();
  final _passwordKontrolKayit = TextEditingController();
  final _recovery = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  sayfa(BuildContext context) {
    if (_authMode == AuthMode.LOGIN)
      return loginMenu(context);
    else if (_authMode == AuthMode.KAYIT)
      return kayitMenu(context);
    else if (_authMode == AuthMode.SIFREYENILEME)
      return kurtarmaMenu(context);
    else if (_authMode == AuthMode.LOADING) return loading(context);
  }

  void submit() async {
    try {
      final auth = authServices.AuthService();
      if (_authMode == AuthMode.LOGIN) {
        _authMode = AuthMode.LOADING;
        setState(() {});
        try {
          await auth
              .signIn(_emailLogin.text.trim(), _passwordLogin.text.trim())
              .then((value) {
            if (value)
              Navigator.pushNamed(context, "/home",
                  arguments: FirebaseAuth.instance);
            else {
              _authMode = AuthMode.LOGIN;
              BotToast.showText(
                  text: "İşlem Başarısız.(Şifre yanlış olabilir.)");
              setState(() {});
            }
          });
          print("Signed In");
        } catch (e) {
          BotToast.showText(text: "İşlem Başarısız!\n" + e.toString());
          _authMode = AuthMode.LOGIN;
          setState(() {});
        }
      } else if (_authMode == AuthMode.KAYIT) {
        if (_passwordKayit.text == _passwordKontrolKayit.text) {
          _authMode = AuthMode.LOADING;
          setState(() {});
          await auth
              .createUser(_adSoyadKayit.text.trimRight(),
                  _emailKayit.text.trim(), _passwordKayit.text.trim())
              .then((value) {
            _isSignIn = value;
            if (!_isSignIn) {
              _authMode = AuthMode.LOGIN;
              BotToast.showText(text: "İşlem Başarısız.");
            } else {
              Navigator.pushNamed(context, "/home",
                  arguments: FirebaseAuth.instance);
            }
          });
          print("Signed up");
        } else {
          BotToast.showText(text: "Şifreler Uyuşmuyor");
        }
      } else {
        try {
          await auth.recovery(_recovery.text.trim());
          BotToast.showText(text: "Mail Gönderildi.");
          _authMode = AuthMode.LOGIN;
          setState(() {});
        } catch (e) {
          BotToast.showText(text: e.toString());
        }
      }
    } catch (e) {
      BotToast.showText(text: e.toString());
    }
  }

  Widget loading(BuildContext context) {
    return FlareActor(
      "assets/Loading.flr",
      alignment: Alignment.center,
      fit: BoxFit.contain,
      animation: 'Alarm',
    );
  }

  Widget loginMenu(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Giriş",
                  style: _googleFonts.apply(
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
                controller: _emailLogin,
                keyboardType: TextInputType.visiblePassword,
                validator: qValidator(
                    [IsRequired("Email Giriniz."), IsEmail("Hatalı Email.")]),
                style: _googleFonts.apply(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.5)),
                  labelText: "Email",
                  labelStyle: _googleFonts.apply(color: Colors.white),
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
                controller: _passwordLogin,
                validator: qValidator([
                  IsRequired("Şifre giriniz."),
                  MinLength(8, "En az 8 karakter olmalıdır."),
                  MaxLength(16, "En fazla 16 karakter olmalıdır."),
                  RegExpRule(
                      RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)'),
                      "Hatalı Şifre")
                ]),
                obscureText: true,
                style: _googleFonts.apply(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.5)),
                  labelText: "Şifre",
                  labelStyle: _googleFonts.apply(color: Colors.white),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _authMode = AuthMode.SIFREYENILEME;
                        _height = globals.telefonHeight! * 0.30;
                      });
                    },
                    child: Text(
                      "Şifremi Unuttum",
                      style: _googleFonts.apply(
                          color: Colors.white, fontSizeDelta: 3),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: InkWell(
                      onTap: () {
                        if (formKey.currentState!.validate()) submit();
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
                            "Giriş Yap",
                            style: _googleFonts.apply(
                                color: Colors.black, fontSizeDelta: 6),
                          ),
                        ),
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget kayitMenu(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: ListView(children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Form(
          key: formKey2,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Kayıt",
                    style: _googleFonts.apply(
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
                  controller: _adSoyadKayit,
                  validator: qValidator([
                    IsRequired("Nickname'inizi giriniz."),
                    MinLength(3, "En az 3 karakter olmalıdır."),
                  ]),
                  style: _googleFonts.apply(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Nickname",
                    labelStyle: _googleFonts.apply(color: Colors.white),
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
                  controller: _emailKayit,
                  keyboardType: TextInputType.emailAddress,
                  validator: qValidator([
                    IsRequired("Email Giriniz."),
                    IsEmail("Geçersiz email.")
                  ]),
                  style: _googleFonts.apply(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Email",
                    labelStyle: _googleFonts.apply(color: Colors.white),
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
                  controller: _passwordKayit,
                  keyboardType: TextInputType.visiblePassword,
                  validator: qValidator([
                    IsRequired("Şifre giriniz."),
                    MinLength(8, "En az 8 karakter olmalıdır."),
                    MaxLength(16, "En fazla 16 karakter olmalıdır."),
                    RegExpRule(
                        RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)'),
                        "Şifrenizde harf ve rakam bulunması gerekir.\nÖrneğin:'Deneme123'"),
                  ]),
                  style: _googleFonts.apply(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Şifre",
                    labelStyle: _googleFonts.apply(color: Colors.white),
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
                  controller: _passwordKontrolKayit,
                  keyboardType: TextInputType.visiblePassword,
                  validator: qValidator([
                    IsRequired("Şifre giriniz."),
                    MinLength(8, "En az 8 karakter olmalıdır."),
                    MaxLength(16, "En fazla 16 karakter olmalıdır."),
                    RegExpRule(
                        RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)'),
                        "Şifrenizde harf ve rakam bulunması gerekir."),
                  ]),
                  style: _googleFonts.apply(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Şifre Kontrol",
                    labelStyle: _googleFonts.apply(color: Colors.white),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: InkWell(
                          onTap: () {
                            _authMode = AuthMode.LOGIN;
                            _height = globals.telefonHeight! * 0.45;
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Geri",
                                style: _googleFonts.apply(
                                    color: Colors.white, fontSizeDelta: 3),
                              ),
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: InkWell(
                          onTap: () {
                            if (formKey2.currentState!.validate()) submit();
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
                                "Giriş Yap",
                                style: _googleFonts.apply(
                                    color: Colors.black, fontSizeDelta: 6),
                              ),
                            ),
                          )),
                    ),
                  ]),
            ),
            SizedBox(height: 20)
          ]),
        ),
      ]),
    );
  }

  Widget kurtarmaMenu(BuildContext context) {
    return Form(
      key: formKey3,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Şifremi Kurtar",
                    style: _googleFonts.apply(
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
                  controller: _recovery,
                  validator: qValidator([
                    IsRequired("Email Giriniz."),
                    IsEmail("Geçersiz email.")
                  ]),
                  style: _googleFonts.apply(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.white, width: 0.5)),
                    labelText: "Email",
                    labelStyle: _googleFonts.apply(color: Colors.white),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: InkWell(
                        onTap: () {
                          _authMode = AuthMode.LOGIN;
                          _height = globals.telefonHeight! * 0.45;
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              "Geri",
                              style: _googleFonts.apply(
                                  color: Colors.white, fontSizeDelta: 4),
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 100,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: InkWell(
                        onTap: () {
                          if (formKey3.currentState!.validate()) {
                            submit();
                            _height = globals.telefonHeight! * 0.45;
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
                              "Kurtar",
                              style: _googleFonts.apply(
                                  color: Colors.black, fontSizeDelta: 5),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: <Widget>[
            new FlareActor(
              "assets/Cosmos.flr",
              alignment: Alignment.center,
              fit: BoxFit.cover,
              animation: 'idle',
            ),
            Align(
              alignment: Alignment.topCenter,
              child: new Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            SafeArea(
              child: Stack(
                children: <Widget>[
                  MediaQuery.of(context).viewInsets.bottom != 0
                      ? Container()
                      : _authMode == AuthMode.KAYIT
                          ? Container()
                          : Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: 175,
                                  height: 175,
                                ),
                              ),
                            ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 700),
                        curve: Curves.fastOutSlowIn,
                        decoration: BoxDecoration(
                            color: /*hexToColor("#3D3D3D")*/ Colors.black
                                .withOpacity(0.00),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(_borderCircle),
                                topRight: Radius.circular(_borderCircle),
                                bottomLeft: Radius.circular(_borderCircle),
                                bottomRight: Radius.circular(_borderCircle))),
                        height: _height,
                        width: _width,
                        //width: MediaQuery.of(context).size.width - 10,
                        alignment: Alignment.center,
                        child: sayfa(context),
                      ),
                    ),
                  ),
                  _authMode != AuthMode.KAYIT
                      ? MediaQuery.of(context).viewInsets.bottom != 0
                          ? Container()
                          : Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Hala üye değil misin?",
                                        style: _googleFonts,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      InkWell(
                                        child: Text("Üye ol",
                                            style: _googleFonts.apply(
                                              color: Colors.white,
                                              fontWeightDelta: 3,
                                              decoration:
                                                  TextDecoration.underline,
                                            )),
                                        onTap: () {
                                          _authMode = AuthMode.KAYIT;
                                          _height =
                                              globals.telefonHeight! * 0.78;
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                      : Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
