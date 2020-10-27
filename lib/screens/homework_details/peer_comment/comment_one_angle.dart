class CommentOfOneAngle {
  String content;
  int angle, score;

  CommentOfOneAngle(this.angle, this.score, this.content);

  bool validate() {
    if (content.isEmpty) return false;
    if (score == 0) return false;
    return true;
  }
}
