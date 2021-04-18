import 'package:cloud_firestore/cloud_firestore.dart';

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
      required this.ticketAdCounter});

  factory UserData.fromJson(Map<String, dynamic> json) {
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
      ticketAdCounter: int.parse(json['ticketAdCounter'].toString())
    );
  }

  factory UserData.fromFirestore(DocumentSnapshot documentSnapshot){
    return UserData.fromJson(documentSnapshot.data()!);
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
      "ticketAdCounter": ticketAdCounter
    };
  }
}
