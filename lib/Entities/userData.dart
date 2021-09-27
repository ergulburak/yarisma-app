import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Entities/scoreHandler.dart';

class UserData {
  String uid;
  String nickname;
  int allWrongAnswers;
  int allTrueAnswers;
  int tickets;
  int joker;
  String rank;
  int totalScore;
  int weekScore;
  int ticketAdCounter;
  String? lastWeek;
  List<Question>? questions;
  List<ScoreHandler>? scoreHandler;

  UserData(
      {required this.uid,
      required this.nickname,
      required this.allWrongAnswers,
      required this.allTrueAnswers,
      required this.tickets,
      required this.joker,
      required this.rank,
      required this.totalScore,
      required this.weekScore,
      required this.ticketAdCounter,
      this.lastWeek,
      this.questions,
      this.scoreHandler});

  factory UserData.fromJson(Map<String, dynamic> json) {
    if (!["", null, false, 0].contains(json['questions']) &&
        !["", null, false, 0].contains(json['scoreHandler'])) {
      return UserData(
        uid: json['uid'],
        nickname: json['nickname'],
        allWrongAnswers: int.parse(json['allWrongAnswers'].toString()),
        allTrueAnswers: int.parse(json['allTrueAnswers'].toString()),
        tickets: int.parse(json['tickets'].toString()),
        joker: int.parse(json['joker'].toString()),
        rank: json['rank'],
        totalScore: int.parse(json['totalScore'].toString()),
        weekScore: int.parse(json['weekScore'].toString()),
        ticketAdCounter: int.parse(json['ticketAdCounter'].toString()),
        lastWeek: json["lastWeek"],
        questions: parseQuestion(json['questions']),
        scoreHandler: parseScoreHandler(json['scoreHandler']),
      );
    } else if (!["", null, false, 0].contains(json['questions']) &&
        ["", null, false, 0].contains(json['scoreHandler'])) {
      return UserData(
        uid: json['uid'],
        nickname: json['nickname'],
        allWrongAnswers: int.parse(json['allWrongAnswers'].toString()),
        allTrueAnswers: int.parse(json['allTrueAnswers'].toString()),
        tickets: int.parse(json['tickets'].toString()),
        joker: int.parse(json['joker'].toString()),
        rank: json['rank'],
        totalScore: int.parse(json['totalScore'].toString()),
        weekScore: int.parse(json['weekScore'].toString()),
        lastWeek: json["lastWeek"],
        ticketAdCounter: int.parse(json['ticketAdCounter'].toString()),
        questions: parseQuestion(json['questions']),
      );
    } else if (["", null, false, 0].contains(json['questions']) &&
        !["", null, false, 0].contains(json['scoreHandler'])) {
      return UserData(
        uid: json['uid'],
        nickname: json['nickname'],
        allWrongAnswers: int.parse(json['allWrongAnswers'].toString()),
        allTrueAnswers: int.parse(json['allTrueAnswers'].toString()),
        tickets: int.parse(json['tickets'].toString()),
        joker: int.parse(json['joker'].toString()),
        rank: json['rank'],
        totalScore: int.parse(json['totalScore'].toString()),
        weekScore: int.parse(json['weekScore'].toString()),
        lastWeek: json["lastWeek"],
        ticketAdCounter: int.parse(json['ticketAdCounter'].toString()),
        scoreHandler: parseScoreHandler(json['scoreHandler']),
      );
    } else {
      return UserData(
          uid: json['uid'],
          nickname: json['nickname'],
          allWrongAnswers: int.parse(json['allWrongAnswers'].toString()),
          allTrueAnswers: int.parse(json['allTrueAnswers'].toString()),
          tickets: int.parse(json['tickets'].toString()),
          joker: int.parse(json['joker'].toString()),
          rank: json['rank'],
          totalScore: int.parse(json['totalScore'].toString()),
          weekScore: int.parse(json['weekScore'].toString()),
          lastWeek: json["lastWeek"],
          ticketAdCounter: int.parse(json['ticketAdCounter'].toString()));
    }
  }

  factory UserData.fromFirestore(DocumentSnapshot documentSnapshot) {
    return UserData.fromJson(documentSnapshot.data() as Map<String, dynamic>);
  }

  static List<Question> parseQuestion(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }

  static List<ScoreHandler> parseScoreHandler(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<ScoreHandler>((json) => ScoreHandler.fromJson(json))
        .toList();
  }

  toJson() {
    return {
      "uid": uid,
      "nickname": nickname,
      "allWrongAnswers": allWrongAnswers,
      "allTrueAnswers": allTrueAnswers,
      "tickets": tickets,
      "joker": joker,
      "rank": rank,
      "totalScore": totalScore,
      "weekScore": weekScore,
      "ticketAdCounter": ticketAdCounter,
      "questions": json.encode(questions),
      "scoreHandler": json.encode(scoreHandler),
      "lastWeek": lastWeek
    };
  }
}
