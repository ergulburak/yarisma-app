import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yarisma_app/Entities/question.dart';

class Quiz {
  List<Question> questions;
  int year;
  int week;
  String state;

  Quiz(
      {required this.questions,
      required this.year,
      required this.week,
      required this.state});

  factory Quiz.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return Quiz(
        questions: parseQuestion(json['questions']),
        year: int.parse(json['year'].toString()),
        week: int.parse(json['week'].toString()),
        state: json['state'],
      );
    } else {
      return Quiz(questions: parseQuestion(""), year: 0, week: 0, state: "");
    }
  }

  factory Quiz.fromFirestore(DocumentSnapshot documentSnapshot) {
    return Quiz.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  toJson() {
    return {
      "questions": json.encode(questions),
      "year": year,
      "week": week,
      "state": state
    };
  }

  static List<Question> parseQuestion(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }
}
