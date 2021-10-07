part of 'userData.dart';

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      uid: json['uid'] as String,
      nickname: json['nickname'] as String,
      mailAdress: json['mailAdress'] as String,
      allWrongAnswers: json['allWrongAnswers'] as int,
      allTrueAnswers: json['allTrueAnswers'] as int,
      tickets: json['tickets'] as int,
      joker: json['joker'] as int,
      rank: json['rank'] as String,
      totalScore: json['totalScore'] as int,
      weekScore: json['weekScore'] as int,
      ticketAdCounter: json['ticketAdCounter'] as int,
      lastWeek: json['lastWeek'] as String?,
      questions:
          json['questions'] == null ? null : parseQuestion(json['questions']),
      scoreHandler: json['scoreHandler'] == null
          ? null
          : parseScoreHandler(json['scoreHandler']),
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'uid': instance.uid,
      'nickname': instance.nickname,
      'mailAdress': instance.mailAdress,
      'allWrongAnswers': instance.allWrongAnswers,
      'allTrueAnswers': instance.allTrueAnswers,
      'tickets': instance.tickets,
      'joker': instance.joker,
      'rank': instance.rank,
      'totalScore': instance.totalScore,
      'weekScore': instance.weekScore,
      'ticketAdCounter': instance.ticketAdCounter,
      'lastWeek': instance.lastWeek,
      'questions': instance.questions,
      'scoreHandler': instance.scoreHandler,
    };

List<Question>? parseQuestion(String data) {
  if (["", null, false, 0, "null"].contains(data))
    return null;
  else {
    final parsed = json.decode(data).cast<Map<String, dynamic>>();
    return parsed.map<Question>((json) => Question.fromJson(json)).toList();
  }
}

List<ScoreHandler>? parseScoreHandler(String data) {
  if (["", null, false, 0, "null"].contains(data))
    return null;
  else {
    final parsed = json.decode(data).cast<Map<String, dynamic>>();
    return parsed
        .map<ScoreHandler>((json) => ScoreHandler.fromJson(json))
        .toList();
  }
}
