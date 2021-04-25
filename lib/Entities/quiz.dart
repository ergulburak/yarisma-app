import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yarisma_app/Entities/question.dart';

class Quiz {
  List<Question> questions;
  int year;
  int week;

  Quiz({required this.questions, required this.year, required this.week});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
        questions: parseQuestion(json['questions']),
        year: int.parse(json['year'].toString()),
        week: int.parse(json['week'].toString()));
  }

  factory Quiz.fromFirestore(DocumentSnapshot documentSnapshot) {
    return Quiz.fromJson(documentSnapshot.data()!);
  }

  toJson() {
    return {"questions": json.encode(questions), "year": year, "week": week};
  }

  static List<Question> parseQuestion(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }
}
