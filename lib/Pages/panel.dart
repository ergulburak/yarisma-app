import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Widgets/panelPendingQuestions.dart';

class Panel extends StatelessWidget {
  Panel({required this.pendingQuestions});
  final CollectionReference pendingQuestions;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: pendingQuestions.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                children: [
                  PanelPendingQuestions(pendingQuestions: pendingQuestions),
                ],
              ),
            ),
          );
        } else
          return Container();
      },
    );
  }
}
