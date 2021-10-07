import 'package:json_annotation/json_annotation.dart';
part 'weeklyScore.g.dart';

@JsonSerializable()
class WeeklyScore {
  String nickname;
  String weekAndYear;
  int weeklyScore;

  WeeklyScore({
    required this.nickname,
    required this.weekAndYear,
    required this.weeklyScore,
  });

  factory WeeklyScore.fromJson(Map<String, dynamic> json) => _$WeeklyScoreFromJson(json);

  Map<String, dynamic> toJson() => _$WeeklyScoreToJson(this);
}
