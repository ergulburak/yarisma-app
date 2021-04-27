import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/home_page.dart';

final formKey = GlobalKey<FormState>();

class AddQuestion extends StatelessWidget {
  AddQuestion({required this.setHome});

  final _question = TextEditingController();
  final _optionA = TextEditingController();
  final _optionB = TextEditingController();
  final _optionC = TextEditingController();
  final _optionD = TextEditingController();
  final _correctOption = TextEditingController();
  final _point = TextEditingController();
  final ValueChanged<Screens> setHome;
  final TextStyle _textStyle = AppFont().getAppFont();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Soru Ekle",
                      style: _textStyle.apply(
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
                    controller: _question,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 6,
                    validator: qValidator([
                      IsRequired(msg: "Soru giriniz"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "Soru giriniz",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
                    controller: _optionA,
                    keyboardType: TextInputType.emailAddress,
                    validator: qValidator([
                      IsRequired(msg: "A şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "A şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
                    controller: _optionB,
                    validator: qValidator([
                      IsRequired(msg: "B şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "B şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
                    controller: _optionC,
                    validator: qValidator([
                      IsRequired(msg: "C şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "C şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _optionD,
                    validator: qValidator([
                      IsRequired(msg: "D şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "D şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _correctOption,
                    validator: qValidator([
                      IsRequired(msg: "Doğru şık"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "Doğru şık",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    controller: _point,
                    validator: qValidator([
                      IsRequired(msg: "Puan"),
                    ]),
                    style: _textStyle.apply(color: Colors.white),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.white, width: 0.5)),
                      labelText: "Puan",
                      labelStyle: _textStyle.apply(color: Colors.white),
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
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Question question = new Question(
                            question: _question.text,
                            optionA: _optionA.text,
                            optionB: _optionB.text,
                            optionC: _optionC.text,
                            optionD: _optionD.text,
                            correctOption: int.parse(_correctOption.text),
                            point: int.parse(_point.text));
                        CollectionReference pendingQuestions = FirebaseFirestore
                            .instance
                            .collection("pendingQuestions");
                        DocumentReference user = FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        pendingQuestions.add(question.toJson()).then((value) =>
                            {
                              if (globals.userData!.questions != null)
                                {
                                  globals.userData!.questions!.add(question),
                                  user.update({
                                    'questions': json
                                        .encode(globals.userData!.questions!)
                                  })
                                }
                              else
                                {
                                  globals.userData!.questions = <Question>[],
                                  globals.userData!.questions!.add(question),
                                  user.update({
                                    'questions': json
                                        .encode(globals.userData!.questions!)
                                  })
                                }
                            });
                        _question.clear();
                        _optionA.clear();
                        _optionB.clear();
                        _optionC.clear();
                        _optionD.clear();
                        _correctOption.clear();
                        _point.clear();
                        setHome(Screens.MYQUESTIONS);
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
                          "Ekle",
                          style: _textStyle.apply(
                              color: Colors.black, fontSizeDelta: 6),
                        ),
                      ),
                    )),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
