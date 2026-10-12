/// Utilitário puro em Dart para normalização de strings e remoção de diacríticos.
///
/// Desenvolvido sem pacotes externos para garantir conformidade estrita com o RF06
/// e independência de dependências externas.
abstract final class TextNormalizer {
  static const String _withDiacritics =
      'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÇçÑñÝýÿ';
  static const String _withoutDiacritics =
      'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuCcNnYyy';

  /// Remove acentos e converte a string para caixa alta.
  ///
  /// Exemplo:
  /// ```dart
  /// TextNormalizer.normalize('Coração'); // 'CORACAO'
  /// TextNormalizer.normalize('Sul-Americano'); // 'SUL-AMERICANO'
  /// ```
  static String normalize(String input) {
    var result = input;
    for (var i = 0; i < _withDiacritics.length; i++) {
      result = result.replaceAll(_withDiacritics[i], _withoutDiacritics[i]);
    }
    return result.toUpperCase();
  }

  /// Normaliza apenas um caractere individual para caixa alta sem acento.
  static String normalizeChar(String char) {
    if (char.isEmpty) return '';
    return normalize(char[0]);
  }

  /// Verifica se o caractere fornecido representa uma letra alfabética válida (A-Z).
  ///
  /// Caracteres como espaços, hífens, pontuações ou números retornarão `false`.
  static bool isLetter(String char) {
    if (char.isEmpty) return false;
    final normalized = normalizeChar(char);
    if (normalized.length != 1) return false;
    final codeUnit = normalized.codeUnitAt(0);
    return codeUnit >= 65 && codeUnit <= 90; // 'A' (65) até 'Z' (90)
  }

  /// Verifica se uma tentativa [guessedLetter] corresponde a um caractere da resposta [answerChar],
  /// ignorando acentuação e diferenças de maiúsculas/minúsculas.
  static bool matches(String guessedLetter, String answerChar) {
    if (guessedLetter.isEmpty || answerChar.isEmpty) return false;
    return normalizeChar(guessedLetter) == normalizeChar(answerChar);
  }
}
