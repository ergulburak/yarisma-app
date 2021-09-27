import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Widgets/panelQuestionForm.dart';

class PanelPendingQuestions extends StatelessWidget {
  PanelPendingQuestions({required this.pendingQuestions});
  final CollectionReference pendingQuestions;
  final TextStyle _textStyle = AppFont().getAppFont();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: pendingQuestions.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Expanded(
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
                  flex: 1,
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return PanelQuestionForm(
                        question: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['question'],
                        optionA: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['optionA'],
                        optionB: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['optionB'],
                        optionC: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['optionC'],
                        optionD: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['optionD'],
                        correctOption: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['correctOption'],
                        point: (snapshot.data!.docs[index].data()
                            as Map<String, dynamic>)['point'],
                        docID: snapshot.data!.docs[index].reference.id,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else
          return Container();
      },
    );
  }
}
