import 'package:flutter/material.dart';
import 'package:yarisma_app/Entities/userData.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

class Profile extends StatelessWidget {
  Profile({required this.userData,});
  final TextStyle _textStyle = AppFont().getAppFont();
  final UserData userData;
  @override
  Widget build(BuildContext context) {
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
                          "50/50 Joker sayın: " + userData.joker.toString(),
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
                          "Giriş Bileti: " + userData.tickets.toString(),
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
                              userData.ticketAdCounter.toString() + "/3",
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
                              userData.allTrueAnswers.toString(),
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
                              userData.allWrongAnswers.toString(),
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