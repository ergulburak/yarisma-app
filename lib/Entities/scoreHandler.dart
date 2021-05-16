class ScoreHandler {
  String quizName;
  int correctCount;
  int wrongCount;
  int point;

  ScoreHandler({
    required this.quizName,
    required this.correctCount,
    required this.wrongCount,
    required this.point,
  });

  factory ScoreHandler.fromJson(Map<String, dynamic> json) {
    return ScoreHandler(
      quizName: json['quizName'],
      correctCount: json['correctCount'],
      wrongCount: json['wrongCount'],
      point: json['point'],
    );
  }

  toJson() {
    return {
      "quizName": quizName,
      "correctCount": correctCount,
      "wrongCount": wrongCount,
      "point": point,
    };
  }
}
