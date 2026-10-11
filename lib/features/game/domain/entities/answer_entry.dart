import '../../../../core/enums/answer_category.dart';
import '../../../../core/enums/difficulty.dart';

/// Representa uma entrada de resposta do jogo da forca com sua respectiva
/// categoria, nível de dificuldade e lista de dicas associadas.
class AnswerEntry {
  const AnswerEntry({
    required this.rawAnswer,
    required this.normalizedAnswer,
    required this.category,
    required this.difficulty,
    required this.hints,
  });

  /// A resposta com grafia e acentuação originais (utilizada para exibição na UI).
  final String rawAnswer;

  /// A resposta sem acentos diacríticos e em caixa alta (utilizada para validação lógica de tentativas).
  final String normalizedAnswer;

  /// A categoria temática da resposta.
  final AnswerCategory category;

  /// O nível de dificuldade da resposta.
  final Difficulty difficulty;

  /// A lista de dicas disponíveis para esta resposta.
  final List<String> hints;

  /// Constrói uma instância de [AnswerEntry] a partir de um Map serializado do JSON.
  ///
  /// Um [normalizer] customizado pode ser fornecido; caso omitido, utiliza
  /// a normalização padrão de diacríticos da língua portuguesa.
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

  /// Converte a entidade de volta para uma estrutura serializável compatível com o JSON.
  Map<String, dynamic> toJson() => {
    'answer': rawAnswer,
    'category': category.toJson(),
    'difficulty': difficulty.toJson(),
    'hints': hints,
  };

  /// Normalização padrão pura em Dart para remoção de acentos em português.
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
