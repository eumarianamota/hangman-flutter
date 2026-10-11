import '../../../../core/enums/answer_category.dart';
import '../../../../core/enums/difficulty.dart';

class AnswerEntry {
  const AnswerEntry({
    required this.rawAnswer,
    required this.normalizedAnswer,
    required this.category,
    required this.difficulty,
    required this.hints,
  });

  final String rawAnswer;

  final String normalizedAnswer;

  final AnswerCategory category;

  final Difficulty difficulty;

  final List<String> hints;

  factory AnswerEntry.fromJson(
    Map<String, dynamic> json, {
    String Function(String)? normalizer,
  }) {
    final rawAnswer = json['answer'] as String;
    final normalized = normalizer != null
        ? normalizer(rawAnswer)
        : _defaultNormalize(rawAnswer);

    final rawHints = json['hints'] as List<dynamic>? ?? const [];
    final hints = rawHints.map((e) => e.toString()).toList(growable: false);

    return AnswerEntry(
      rawAnswer: rawAnswer,
      normalizedAnswer: normalized,
      category: AnswerCategory.fromJson(json['category'] as String),
      difficulty: Difficulty.fromJson(json['difficulty'] as String),
      hints: hints,
    );
  }

  Map<String, dynamic> toJson() => {
    'answer': rawAnswer,
    'category': category.toJson(),
    'difficulty': difficulty.toJson(),
    'hints': hints,
  };

  static String _defaultNormalize(String input) {
    const withDiacritics =
        'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÇçÑñÝýÿ';
    const withoutDiacritics =
        'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuCcNnYyy';

    var result = input;
    for (var i = 0; i < withDiacritics.length; i++) {
      result = result.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return result.toUpperCase();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnswerEntry &&
          runtimeType == other.runtimeType &&
          rawAnswer == other.rawAnswer &&
          category == other.category &&
          difficulty == other.difficulty;

  @override
  int get hashCode => Object.hash(rawAnswer, category, difficulty);

  @override
  String toString() =>
      'AnswerEntry(rawAnswer: $rawAnswer, category: ${category.name}, difficulty: ${difficulty.name})';
}
