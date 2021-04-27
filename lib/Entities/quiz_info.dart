import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yarisma_app/Services/date_utils.dart';

class QuizInfo {
  String quizState;
  int quizWeek = CustomDateUtils.weekOfYear(DateTime.now());

  QuizInfo({required this.quizState});

  factory QuizInfo.fromJson(Map<String, dynamic> json) {
    return QuizInfo(quizState: json['quizState']);
  }

  factory QuizInfo.fromFirestore(DocumentSnapshot documentSnapshot) {
    return QuizInfo.fromJson(documentSnapshot.data()!);
  }

  toJson() {
    return {
      "quizState": quizState,
      "quizWeek": quizWeek,
    };
  }
}
