class Question {
  final String questionTitle;
  final List<String> questionText;
  final List<List<String>> answers;

  Question(
      {required this.questionTitle,
      required this.questionText,
      required this.answers});
}
