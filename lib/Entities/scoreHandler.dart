class ScoreHandler {
  int correctCount;
  int wrongCount;
  int point;

  ScoreHandler({
    required this.correctCount,
    required this.wrongCount,
    required this.point,
  });

  factory ScoreHandler.fromJson(Map<String, dynamic> json) {
    return ScoreHandler(
      correctCount: int.parse(json['correctCount']),
      wrongCount: int.parse(json['wrongCount']),
      point: int.parse(json['point']),
    );
  }

  toJson() {
    return {
      "correctCount": correctCount,
      "wrongCount": wrongCount,
      "point": point,
    };
  }
}
