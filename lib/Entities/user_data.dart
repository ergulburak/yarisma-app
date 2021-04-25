import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yarisma_app/Entities/question.dart';

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
  List<Question>? questions;

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
      this.questions});

  factory UserData.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != "null") {
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
          questions: parseQuestion(json['questions']));
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
          ticketAdCounter: int.parse(json['ticketAdCounter'].toString()));
    }
  }

  factory UserData.fromFirestore(DocumentSnapshot documentSnapshot) {
    Map<String,dynamic> data=documentSnapshot.data()!;
    if(data==null){
      
      return UserData.fromJson(data);
    }
    else{
      return UserData.fromJson(data);
    }
  }

  static List<Question> parseQuestion(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
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
      "questions": json.encode(questions)
    };
  }
}
