import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  String question;
  String optionA;
  String optionB;
  String optionC;
  String optionD;
  int correctOption;
  int point;

  Question(
      {required this.question,
      required this.optionA,
      required this.optionB,
      required this.optionC,
      required this.optionD,
      required this.correctOption,
      required this.point});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      optionA: json['optionA'] as String,
      optionB: json['optionB'] as String,
      optionC: json['optionC'] as String,
      optionD: json['optionD'] as String,
      correctOption: json['correctOption'] as int,
      point: json['point'] as int,
    );
  }

  factory Question.fromFirestore(DocumentSnapshot documentSnapshot) {
    return Question.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  toJson() {
    return {
      "question": question,
      "optionA": optionA,
      "optionB": optionB,
      "optionC": optionC,
      "optionD": optionD,
      "correctOption": correctOption,
      "point": point
    };
  }
}
