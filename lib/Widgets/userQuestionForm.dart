import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

class UserQuestionForm extends StatelessWidget {
  UserQuestionForm({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.point,
  });
  final String question, optionA, optionB, optionC, optionD;
  final int correctOption, point;
  final double _width = globals.telefonWidth! - 70;
  final TextStyle _textStyle = AppFont().getAppFont();
  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                question,
                style: _textStyle.apply(color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      "A) " + optionA,
                      style: _textStyle.apply(color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "B) " + optionB,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "C) " + optionC,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "D) " + optionD,
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Doğru Cevap: " +
                            (correctOption == 1
                                ? "A"
                                : correctOption == 2
                                    ? "B"
                                    : correctOption == 3
                                        ? "C"
                                        : correctOption == 4
                                            ? "D"
                                            : "Hata"),
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text(
                        "Puan: " + point.toString(),
                        style: _textStyle.apply(color: Colors.black),
                        textAlign: TextAlign.left,
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
