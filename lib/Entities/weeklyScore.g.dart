part of 'weeklyScore.dart';

WeeklyScore _$WeeklyScoreFromJson(Map<String, dynamic> json) => WeeklyScore(
      nickname: json['nickname'] as String,
      weekAndYear: json['weekAndYear'] as String,
      weeklyScore: json['weeklyScore'] as int,
    );

Map<String, dynamic> _$WeeklyScoreToJson(WeeklyScore instance) =>
    <String, dynamic>{
      'nickname': instance.nickname,
      'weekAndYear': instance.weekAndYear,
      'weeklyScore': instance.weeklyScore,
    };
