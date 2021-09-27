class UsersInfo {
  String nickname;
  int totalScore;

  UsersInfo({
    required this.nickname,
    required this.totalScore,
  });

  factory UsersInfo.forBoardTotal(Map<String, dynamic> json) {
    return UsersInfo(
        nickname: json['nickname'],
        totalScore: int.parse(json['totalScore'].toString()));
  }
  factory UsersInfo.forBoardWeek(Map<String, dynamic> json) {
    return UsersInfo(
        nickname: json['nickname'],
        totalScore: int.parse(json['weekScore'].toString()));
  }
}
