enum Difficulty {
  easy,
  medium,
  hard;

  String get displayName => switch (this) {
    Difficulty.easy => 'Fácil',
    Difficulty.medium => 'Médio',
    Difficulty.hard => 'Difícil',
  };

  factory Difficulty.fromJson(String value) => switch (value) {
    'easy' => Difficulty.easy,
    'medium' => Difficulty.medium,
    'hard' => Difficulty.hard,
    _ => throw FormatException('Unknown Difficulty: "$value"'),
  };

  String toJson() => name;
}
