enum Difficulty {
  easy,
  medium,
  hard;

  /// Retorna o nome amigável da dificuldade em português para exibição na UI.
  String get displayName => switch (this) {
    Difficulty.easy => 'Fácil',
    Difficulty.medium => 'Médio',
    Difficulty.hard => 'Difícil',
  };

  /// Converte o valor textual em inglês vindo do JSON para o tipo enumerado [Difficulty].
  ///
  /// Lança [FormatException] caso o valor fornecido não seja reconhecido.
  factory Difficulty.fromJson(String value) => switch (value) {
    'easy' => Difficulty.easy,
    'medium' => Difficulty.medium,
    'hard' => Difficulty.hard,
    _ => throw FormatException('Unknown Difficulty: "$value"'),
  };

  /// Retorna o identificador técnico em inglês para serialização.
  String toJson() => name;
}
