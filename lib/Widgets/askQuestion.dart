import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;
import 'package:yarisma_app/Widgets/questionOptionButton.dart';

class AskQuestion extends StatefulWidget {
  AskQuestion({
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctOption,
    required this.point,
  });
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final int correctOption;
  final int point;

  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  TextStyle _textStyle = AppFont().getAppFont();

  void _scoreHandler(bool isCorrect) {
    if (isCorrect) {
      globals.scoreHandler!.correctCount += 1;
      globals.scoreHandler!.point += widget.point;
    } else {
      globals.scoreHandler!.wrongCount += 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight,
      child: FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.scaleDown,
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  width: globals.telefonWidth,
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      widget.question,
                      textAlign: TextAlign.center,
                      style: _textStyle.apply(
                        color: Colors.black,
                        fontSizeDelta: 3,
                        fontWeightDelta: 2,
                      ),
                    ),
                  ),
                ),
              ),
              QuestionOptionButton(
                optionText: widget.optionA,
                isCorrect: widget.correctOption == 1 ? true : false,
                answer: _scoreHandler,
              ),
              QuestionOptionButton(
                optionText: widget.optionB,
                isCorrect: widget.correctOption == 2 ? true : false,
                answer: _scoreHandler,
              ),
              QuestionOptionButton(
                optionText: widget.optionC,
                isCorrect: widget.correctOption == 3 ? true : false,
                answer: _scoreHandler,
              ),
              QuestionOptionButton(
                optionText: widget.optionD,
                isCorrect: widget.correctOption == 4 ? true : false,
                answer: _scoreHandler,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
