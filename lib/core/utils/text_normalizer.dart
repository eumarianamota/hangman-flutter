abstract final class TextNormalizer {
  static const String _withDiacritics =
      'ÀÁÂÃÄÅàáâãäåÈÉÊËèéêëÌÍÎÏìíîïÒÓÔÕÖØòóôõöøÙÚÛÜùúûüÇçÑñÝýÿ';
  static const String _withoutDiacritics =
      'AAAAAAaaaaaaEEEEeeeeIIIIiiiiOOOOOOooooooUUUUuuuuCcNnYyy';

  static String normalize(String input) {
    var result = input;
    for (var i = 0; i < _withDiacritics.length; i++) {
      result = result.replaceAll(_withDiacritics[i], _withoutDiacritics[i]);
    }
    return result.toUpperCase();
  }

  static String normalizeChar(String char) {
    if (char.isEmpty) return '';
    return normalize(char[0]);
  }

  static bool isLetter(String char) {
    if (char.isEmpty) return false;
    final normalized = normalizeChar(char);
    if (normalized.length != 1) return false;
    final codeUnit = normalized.codeUnitAt(0);
    return codeUnit >= 65 && codeUnit <= 90; // 'A' (65) até 'Z' (90)
  }

  static bool matches(String guessedLetter, String answerChar) {
    if (guessedLetter.isEmpty || answerChar.isEmpty) return false;
    return normalizeChar(guessedLetter) == normalizeChar(answerChar);
  }
}
