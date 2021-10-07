import 'dart:convert';
import 'package:yarisma_app/Entities/question.dart';
import 'package:yarisma_app/Entities/scoreHandler.dart';
part 'userData.g.dart';

class UserData {
  String uid;
  String nickname;
  String mailAdress;
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
      required this.mailAdress,
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

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
