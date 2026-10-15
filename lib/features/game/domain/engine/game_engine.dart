import '../../../../core/enums/game_status.dart';
import '../../../../core/utils/text_normalizer.dart';
import '../entities/answer_entry.dart';

class GameEngine {
  GameEngine({required this.currentAnswer, this.maxErrors = 6})
    : assert(maxErrors > 0, 'maxErrors deve ser maior que zero.'),
      _guessedLetters = <String>{},
      _errorCount = 0,
      _hintUsed = false,
      _status = GameStatus.playing;

  final AnswerEntry currentAnswer;

  final int maxErrors;

  final Set<String> _guessedLetters;
  int _errorCount;
  bool _hintUsed;
  GameStatus _status;

  Set<String> get guessedLetters => Set.unmodifiable(_guessedLetters);

  int get errorCount => _errorCount;

  bool get hintUsed => _hintUsed;

  GameStatus get status => _status;

  int get remainingErrors => maxErrors - _errorCount;

  bool get isWon => _status == GameStatus.won;

  bool get isLost => _status == GameStatus.lost;

  bool get isGameOver => _status.isGameOver;

  bool guessLetter(String letter) {
    if (isGameOver) return false;
    if (!TextNormalizer.isLetter(letter)) return false;

    final normalized = TextNormalizer.normalizeChar(letter);

    if (_guessedLetters.contains(normalized)) {
      return false;
    }

    _guessedLetters.add(normalized);

    final isCorrect = currentAnswer.normalizedAnswer.contains(normalized);

    if (isCorrect) {
      if (_checkVictoryCondition()) {
        _status = GameStatus.won;
      }
      return true;
    } else {
      _errorCount++;
      if (_errorCount >= maxErrors) {
        _status = GameStatus.lost;
      }
      return false;
    }
  }

  String? requestHint() {
    _hintUsed = true;
    if (currentAnswer.hints.isEmpty) return null;
    return currentAnswer.hints.first;
  }

  void forfeit() {
    if (_status == GameStatus.playing) {
      _status = GameStatus.lost;
    }
  }

  bool isCharRevealed(String char) {
    if (!TextNormalizer.isLetter(char)) {
      return true;
    }
    return _guessedLetters.contains(TextNormalizer.normalizeChar(char));
  }

  String get displayWord {
    final buffer = StringBuffer();
    for (var i = 0; i < currentAnswer.rawAnswer.length; i++) {
      final char = currentAnswer.rawAnswer[i];
      if (isCharRevealed(char)) {
        buffer.write(char);
      } else {
        buffer.write('_');
      }
    }
    return buffer.toString();
  }

  bool _checkVictoryCondition() {
    for (var i = 0; i < currentAnswer.rawAnswer.length; i++) {
      final char = currentAnswer.rawAnswer[i];
      if (TextNormalizer.isLetter(char)) {
        final normalized = TextNormalizer.normalizeChar(char);
        if (!_guessedLetters.contains(normalized)) {
          return false;
        }
      }
    }
    return true;
  }
}
