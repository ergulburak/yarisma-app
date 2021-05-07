import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Services/font.dart';
import 'package:yarisma_app/Services/globals.dart' as globals;

class QuestionOptionButton extends StatefulWidget {
  QuestionOptionButton({
    required this.optionText,
    required this.isCorrect,
    required this.answer,
  });
  final String optionText;
  final bool isCorrect;
  final ValueChanged<bool> answer;
  @override
  _QuestionOptionButtonState createState() => _QuestionOptionButtonState();
}

class _QuestionOptionButtonState extends State<QuestionOptionButton> {
  TextStyle _textStyle = AppFont().getAppFont();
  Color correctColor = Colors.green;
  Color wrongColor = Colors.red;
  Color defaultColor = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: InkWell(
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: defaultColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          alignment: Alignment.centerLeft,
          width: globals.telefonWidth,
          height: 50,
          duration: Duration(milliseconds: 100),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.optionText,
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
        onTap: () {
          setState(() {
            if (widget.isCorrect) {
              defaultColor = correctColor;
              showDialog(
                context: context,
                builder: (BuildContext context) => trueAnswer(context),
              );
            } else {
              defaultColor = wrongColor;
              showDialog(
                context: context,
                builder: (BuildContext context) => falseAnswer(context),
              );
            }
          });
        },
      ),
    );
  }

  Widget trueAnswer(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight! / 2,
      child: FlareActor(
        "assets/success-1.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'verified',
        callback: (name) {
          if (name == "verified") {
            widget.answer(true);
            Navigator.pop(context, false);
          }
        },
      ),
    );
  }

  Widget falseAnswer(BuildContext context) {
    return Container(
      width: globals.telefonWidth,
      height: globals.telefonHeight! / 2,
      child: FlareActor(
        "assets/success_error.flr",
        alignment: Alignment.center,
        fit: BoxFit.contain,
        animation: 'go',
        callback: (name) {
          if (name == "go") {
            widget.answer(false);
            Navigator.pop(context, false);
          }
        },
      ),
    );
  }
}
