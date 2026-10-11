enum AnswerCategory {
  animals,
  humanBody,
  sports,
  technology;

  String get displayName => switch (this) {
    AnswerCategory.animals => 'Animais',
    AnswerCategory.humanBody => 'Corpo humano',
    AnswerCategory.sports => 'Esportes',
    AnswerCategory.technology => 'Tecnologia',
  };

  factory AnswerCategory.fromJson(String value) => switch (value) {
    'animals' => AnswerCategory.animals,
    'humanBody' => AnswerCategory.humanBody,
    'sports' => AnswerCategory.sports,
    'technology' => AnswerCategory.technology,
    _ => throw FormatException('Unknown AnswerCategory: "$value"'),
  };

  String toJson() => name;
}
