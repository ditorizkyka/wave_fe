class Question {
  final int questionId;
  final String? questionType;
  final String questionText;
  List<Option>? option;

  Question({
    required this.questionId,
    required this.questionText,
    this.questionType,
    this.option,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'],
      questionType: json['questionType'],
      questionText: json['questionText'],
      option: (json['options'] as List<dynamic>?)?.map((item) {
        return Option.fromJson(item);
      }).toList(),
    );
  }
}

class Option {
  final int optionId;
  final String optionText;

  Option({required this.optionId, required this.optionText});

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      optionId: json['optionId'],
      optionText: json['options'],
    );
  }
}
