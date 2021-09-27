import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Entities/usersInfo.dart';
import 'package:yarisma_app/Services/font.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard(
      {Key? key,
      required this.leaderboardTotalPoints,
      required this.leaderboardWeekPoints})
      : super(key: key);
  final Future<QuerySnapshot<Map<String, dynamic>>> leaderboardTotalPoints;
  final Future<QuerySnapshot<Map<String, dynamic>>> leaderboardWeekPoints;

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard>
    with SingleTickerProviderStateMixin {
  TextStyle _textStyle = AppFont().getAppFont();

  late List<UsersInfo> _userDatas = <UsersInfo>[];
  List<UsersInfo> _userWeekDatas = <UsersInfo>[];

  @override
  void initState() {
    widget.leaderboardTotalPoints.then((value) {
      for (QueryDocumentSnapshot tempUser in value.docs) {
        _userDatas.add(
            UsersInfo.forBoardTotal(tempUser.data() as Map<String, dynamic>));
      }
    });
    widget.leaderboardWeekPoints.then((value) {
      for (QueryDocumentSnapshot tempUser in value.docs) {
        _userWeekDatas.add(
            UsersInfo.forBoardWeek(tempUser.data() as Map<String, dynamic>));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _userDatas.clear();
    _userWeekDatas.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 120),
        child: SafeArea(
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                ButtonsTabBar(
                  height: 70,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  backgroundColor: Colors.blue[600],
                  unselectedBackgroundColor: Colors.white,
                  unselectedLabelStyle: TextStyle(
                      color: Colors.blue[600], fontWeight: FontWeight.bold),
                  borderWidth: 2,
                  borderColor: Colors.blue,
                  unselectedBorderColor: Colors.blue,
                  radius: 12,
                  center: true,
                  duration: 100,
                  physics: AlwaysScrollableScrollPhysics(),
                  labelStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  tabs: [
                    Tab(
                      text: "Genel",
                    ),
                    Tab(
                      text: "Haftalık",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      listBar(context, _userDatas),
                      listBar(context, _userWeekDatas),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget listBar(BuildContext context, List<UsersInfo> list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (BuildContext ctxt, int index) {
          switch (index) {
            case 0:
              {
                return Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    height: 100,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (index + 1).toString() +
                                  ") " +
                                  list[index].nickname,
                              style: _textStyle.apply(fontSizeDelta: 25),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              list[index].totalScore.toString(),
                              style: _textStyle.apply(fontSizeDelta: 25),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            case 1:
              {
                return Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (index + 1).toString() +
                                  ") " +
                                  list[index].nickname,
                              style: _textStyle.apply(fontSizeDelta: 20),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              list[index].totalScore.toString(),
                              style: _textStyle.apply(fontSizeDelta: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            case 2:
              {
                return Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    height: 60,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                (index + 1).toString() +
                                    ") " +
                                    list[index].nickname,
                                style: _textStyle.apply(fontSizeDelta: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              list[index].totalScore.toString(),
                              style: _textStyle.apply(fontSizeDelta: 15),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            default:
              {
                return Padding(
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blueAccent,
                        width: 2,
                      ),
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5)),
                    ),
                    height: 50,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (index + 1).toString() +
                                  ") " +
                                  list[index].nickname,
                              style: _textStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              list[index].totalScore.toString(),
                              style: _textStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          }
        });
  }
}
