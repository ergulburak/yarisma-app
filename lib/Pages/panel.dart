import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Widgets/panelQuestionForm.dart';

class Panel extends StatelessWidget {
  Panel({required this.pendingQuestions});
  final CollectionReference pendingQuestions;
  final TextStyle _textStyle = AppFont().getAppFont();

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
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Onay Bekleyen Sorular",
                      style: _textStyle.apply(fontSizeDelta: 10.0),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return PanelQuestionForm(
                          question:
                              snapshot.data!.docs[index].data()!['question'],
                          optionA:
                              snapshot.data!.docs[index].data()!['optionA'],
                          optionB:
                              snapshot.data!.docs[index].data()!['optionB'],
                          optionC:
                              snapshot.data!.docs[index].data()!['optionC'],
                          optionD:
                              snapshot.data!.docs[index].data()!['optionD'],
                          correctOption: snapshot.data!.docs[index]
                              .data()!['correctOption'],
                          point: snapshot.data!.docs[index].data()!['point'],
                          docID: snapshot.data!.docs[index].reference.id,
                        );
                      },
                    ),
                  ),
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
