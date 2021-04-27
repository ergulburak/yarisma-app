import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Entities/quiz.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Widgets/userQuestionForm.dart';

class UserQuestions extends StatelessWidget {
  UserQuestions({required this.userQuestion});
  final DocumentReference userQuestion;
  final TextStyle _textStyle = AppFont().getAppFont();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: userQuestion.snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          List<Question> userQuest =
              Quiz.parseQuestion(snapshot.data!["questions"].toString());
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Sorularım",
                      style: _textStyle.apply(fontSizeDelta: 10.0),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userQuest.length,
                      itemBuilder: (context, index) {
                        return UserQuestionForm(
                          question: userQuest[index].question,
                          optionA: userQuest[index].optionA,
                          optionB: userQuest[index].optionB,
                          optionC: userQuest[index].optionC,
                          optionD: userQuest[index].optionD,
                          correctOption: userQuest[index].correctOption,
                          point: userQuest[index].point,
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