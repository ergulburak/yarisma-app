import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Entities/quiz.dart';
import 'package:yarisma_app/Services/date_utils.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Widgets/userQuestionForm.dart';

class PanelQuestionForm extends StatelessWidget {
  PanelQuestionForm({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.point,
    required this.docID,
  });
  final String question, optionA, optionB, optionC, optionD, docID;
  final int correctOption, point;
  final panelFormKey = GlobalKey<FormState>();
  final _panelWeek = TextEditingController();
  final _panelYear = TextEditingController();
  final TextStyle _textStyle = AppFont().getAppFont();
  final double _height = globals.telefonHeight! * 0.45;
  final double _width = globals.telefonWidth! - 70;
  @override
  Widget build(BuildContext context) {
    _panelWeek.text = CustomDateUtils.currentWeek().toString();
    _panelYear.text = DateTime.now().year.toString();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        width: _width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              bottomRight: Radius.circular(5)),
        ),
        child: Column(
          children: [
            UserQuestionForm(
              question: question,
              optionA: optionA,
              optionB: optionB,
              optionC: optionC,
              optionD: optionD,
              correctOption: correctOption,
              point: point,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      hoverColor: Colors.black87,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (c) => AlertDialog(
                            title: Text(
                              "Seçilen Soru",
                              style: _textStyle.apply(
                                  fontSizeDelta: 6, color: Colors.black),
                            ),
                            actions: [
                              TextButton(
                                child: Text('Onayla'),
                                onPressed: () {
                                  //Quiz quiz=new Quiz(,CustomDateUtils.currentWeek(),DateTime.now().year);
                                  if (panelFormKey.currentState!.validate()) {
                                    late Quiz quiz;
                                    FirebaseFirestore.instance
                                        .collection("quizzes")
                                        .doc(_panelWeek.text +
                                            "+" +
                                            _panelYear.text)
                                        .get()
                                        .then((value) {
                                          if (value.exists) {
                                            quiz =
                                                new Quiz.fromFirestore(value);
                                            quiz.questions.add(Question(
                                                question: question,
                                                optionA: optionA,
                                                optionB: optionB,
                                                optionC: optionC,
                                                optionD: optionD,
                                                correctOption: correctOption,
                                                point: point));
                                          } else {
                                            List<Question> temp = <Question>[];
                                            temp.add(Question(
                                                question: question,
                                                optionA: optionA,
                                                optionB: optionB,
                                                optionC: optionC,
                                                optionD: optionD,
                                                correctOption: correctOption,
                                                point: point));
                                            quiz = new Quiz(
                                                questions: temp,
                                                week:
                                                    int.parse(_panelWeek.text),
                                                year:
                                                    int.parse(_panelYear.text),
                                                state: "unCompleted");
                                          }
                                        })
                                        .then((value) => FirebaseFirestore
                                            .instance
                                            .collection("quizzes")
                                            .doc(_panelWeek.text +
                                                "+" +
                                                _panelYear.text)
                                            .set(quiz.toJson()))
                                        .then((value) => FirebaseFirestore
                                            .instance
                                            .collection("pendingQuestions")
                                            .doc(docID)
                                            .delete());
                                    Navigator.pop(c, false);
                                  }
                                },
                              ),
                              TextButton(
                                child: Text('Vazgeç'),
                                onPressed: () => Navigator.pop(c, false),
                              ),
                            ],
                            content: Stack(
                              children: <Widget>[
                                Form(
                                  key: panelFormKey,
                                  child: Container(
                                    width: _width,
                                    height: _height,
                                    child: ListView(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            UserQuestionForm(
                                              question: question,
                                              optionA: optionA,
                                              optionB: optionB,
                                              optionC: optionC,
                                              optionD: optionD,
                                              correctOption: correctOption,
                                              point: point,
                                            ),
                                            TextFormField(
                                              controller: _panelWeek,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              validator: qValidator([
                                                IsRequired(
                                                    msg:
                                                        "Hafta Numarası girmelisiniz."),
                                              ]),
                                              style: _textStyle.apply(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5)),
                                                labelText: "Hafta Numarası",
                                                labelStyle: _textStyle.apply(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
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
                                            SizedBox(
                                              height: 10,
                                            ),
                                            TextFormField(
                                              controller: _panelYear,
                                              keyboardType:
                                                  TextInputType.visiblePassword,
                                              validator: qValidator([
                                                IsRequired(
                                                    msg: "Yıl girmelisiniz."),
                                              ]),
                                              style: _textStyle.apply(
                                                  color: Colors.black),
                                              decoration: InputDecoration(
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: Colors
                                                                    .black,
                                                                width: 0.5)),
                                                labelText: "Yıl",
                                                labelStyle: _textStyle.apply(
                                                    color: Colors.black),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Colors.black,
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
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.greenAccent,
                            )),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Onayla",
                            style: _textStyle.apply(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      width: 20,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                                  title: Text(
                                    "Seçilen Soru",
                                    style: _textStyle.apply(
                                        fontSizeDelta: 6, color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('Evet'),
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection("pendingQuestions")
                                            .doc(docID)
                                            .delete();
                                        Navigator.pop(c, false);
                                      },
                                    ),
                                    TextButton(
                                      child: Text('Vazgeç'),
                                      onPressed: () => Navigator.pop(c, false),
                                    ),
                                  ],
                                  content: Container(
                                    width: _width,
                                    height: _height,
                                    child: ListView(
                                      children: [
                                        Column(
                                          children: <Widget>[
                                            UserQuestionForm(
                                              question: question,
                                              optionA: optionA,
                                              optionB: optionB,
                                              optionC: optionC,
                                              optionD: optionD,
                                              correctOption: correctOption,
                                              point: point,
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text(
                                              "Silmek istediğinize emin misiniz?",
                                              style: _textStyle.apply(
                                                color: Colors.black,
                                                fontWeightDelta: 2,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                      hoverColor: Colors.black87,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.redAccent),
                        ),
                        height: 50,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Reddet",
                            style: _textStyle.apply(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
