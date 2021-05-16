import 'package:cloud_firestore/cloud_firestore.dart';

class QuizInfo {
  String quizState;
  String quizID;
  int correctCount;
  int wrongCount;

  QuizInfo(
      {required this.quizState,
      required this.quizID,
      required this.correctCount,
      required this.wrongCount});

  factory QuizInfo.fromJson(Map<String, dynamic> json) {
    return QuizInfo(
      quizState: json['quizState'],
      quizID: json['quizID'],
      correctCount: int.parse(json['correctCount']),
      wrongCount: int.parse(json['wrongCount']),
    );
  }

  factory QuizInfo.fromFirestore(DocumentSnapshot documentSnapshot) {
    return QuizInfo.fromJson(documentSnapshot.data()!);
  }

  toJson() {
    return {
      "quizState": quizState,
      "quizID": quizID,
      "correctCount": correctCount,
      "wrongCount": wrongCount,
    };
  }
}
