import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Widgets/panelAllUsers.dart';
import 'package:yarisma_app/Widgets/panelPendingQuestions.dart';

class Panel extends StatelessWidget {
  Panel({
    required this.pendingQuestions,
    required this.allUsers,
  });
  final CollectionReference pendingQuestions;
  final CollectionReference allUsers;

  final TextStyle _textStyle = AppFont().getAppFont();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              labelStyle:
                  _textStyle.apply(color: Colors.white, fontWeightDelta: 2),
              tabs: [
                Tab(
                  text: "Onay Bekleyen Sorular",
                ),
                Tab(
                  text: "Kullanıcılar",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PanelPendingQuestions(pendingQuestions: pendingQuestions),
                  PanelAllUsers(allUsers: allUsers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
