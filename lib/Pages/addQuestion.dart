import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:queen_validators/queen_validators.dart';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Pages/homePage.dart';

class AddQuestion extends StatefulWidget {
  AddQuestion({required this.setHome});

  final ValueChanged<Screens> setHome;

  @override
  _AddQuestionState createState() => _AddQuestionState();
}

class _AddQuestionState extends State<AddQuestion> {
  final formKey = GlobalKey<FormState>();
  final _question = TextEditingController();
  final _optionA = TextEditingController();
  final _optionB = TextEditingController();
  final _optionC = TextEditingController();
  final _optionD = TextEditingController();
  final _correctOption = TextEditingController();
  final TextStyle _textStyle = AppFont().getAppFont();

  String dropdownValue = 'A';

  String dropdownPoint = '10';

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
                          color: Colors.black,
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
                      IsRequired("Soru giriniz"),
                    ]),
                    style: _textStyle.apply(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 0.5)),
                      labelText: "Soru giriniz",
                      labelStyle: _textStyle.apply(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
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
                      IsRequired("A şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 0.5)),
                      labelText: "A şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
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
                      IsRequired("B şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 0.5)),
                      labelText: "B şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
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
                      IsRequired("C şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 0.5)),
                      labelText: "C şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
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
                      IsRequired("D şıkkı"),
                    ]),
                    style: _textStyle.apply(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.black, width: 0.5)),
                      labelText: "D şıkkı",
                      labelStyle: _textStyle.apply(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      border: new OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: Colors.black,
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Doğru şık : ",
                            style: _textStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                            ),
                            iconSize: 20,
                            elevation: 16,
                            dropdownColor: Colors.white,
                            style: _textStyle,
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['A', 'B', 'C', 'D']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: _textStyle,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(
                        color: Colors.black,
                      )),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            "Puan : ",
                            style: _textStyle,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: DropdownButton<String>(
                            value: dropdownPoint,
                            icon: const Icon(
                              Icons.arrow_downward,
                              color: Colors.black,
                            ),
                            iconSize: 20,
                            elevation: 16,
                            dropdownColor: Colors.white,
                            style: _textStyle,
                            underline: Container(
                              height: 2,
                              color: Colors.black,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownPoint = newValue!;
                              });
                            },
                            items: <String>['5', '10', '15']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: _textStyle,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Question question = new Question(
                            question: _question.text,
                            optionA: _optionA.text,
                            optionB: _optionB.text,
                            optionC: _optionC.text,
                            optionD: _optionD.text,
                            correctOption: dropdownValue == "A"
                                ? 1
                                : dropdownValue == "B"
                                    ? 2
                                    : dropdownValue == "C"
                                        ? 3
                                        : 4,
                            point: int.parse(dropdownPoint));
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
                        widget.setHome(Screens.MYQUESTIONS);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: [0.5, 1.0],
                          colors: [
                            Colors.blueAccent.shade400,
                            Colors.blueAccent.shade700,
                          ],
                        ),
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
                              color: Colors.white, fontSizeDelta: 6),
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
